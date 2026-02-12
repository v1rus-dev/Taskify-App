# Sync в Taskify (Client Side)

Этот документ описывает текущую реализацию синхронизации на клиенте (Flutter), после выноса в `features/sync`.

## 1. Цель синхронизации

Синхронизация в Taskify построена как offline-first поток:
- локальные изменения применяются сразу в Drift;
- изменения ставятся в локальную очередь sync-операций;
- при триггере выполняется push локальной очереди и pull серверных изменений;
- локальное состояние синка (`cursor`, `deviceId`, `lastSyncedAt`) хранится в БД.

## 2. Границы ответственности (Ownership)

Sync полностью принадлежит `features/sync`:
- `lib/features/sync/data/**`
- `lib/features/sync/domain/**`

Что важно:
- не добавлять новый sync-код в старые глобальные пути `lib/data/sync`, `lib/domain/sync`, `lib/core/sync`;
- внешние фичи работают с sync через публичные use case (`EnqueueSyncOpUseCase`, `RequestSyncUseCase`), а не через `SyncRepository` напрямую.

## 3. Структура и ключевые классы

## 3.1 Domain API (публичный контракт)

Файлы:
- `lib/features/sync/domain/usecases/enqueue_sync_op_use_case.dart`
- `lib/features/sync/domain/usecases/request_sync_use_case.dart`
- `lib/features/sync/domain/usecases/run_sync_use_case.dart`
- `lib/features/sync/domain/usecases/get_sync_state_use_case.dart`
- `lib/features/sync/domain/usecases/save_sync_state_use_case.dart`

Назначение:
- `EnqueueSyncOpUseCase`: добавить операцию в локальную очередь.
- `RequestSyncUseCase`: попросить синк (debounced), не блокируя UI.
- `RunSyncUseCase`: выполнить полный sync цикл (push + pull).
- `GetSyncStateUseCase` / `SaveSyncStateUseCase`: доступ к sync state.

## 3.2 Оркестрация

Файл:
- `lib/features/sync/domain/services/sync_coordinator.dart`

`SyncCoordinator` отвечает за:
- триггеры (`onAppStart`, `setAuthenticated`, `onForeground`, `onNetworkRestored`);
- debounce (`scheduleSync`, по умолчанию 3 секунды);
- защиту от параллельных запусков (`_isSyncing`);
- повторный запуск после завершения, если во время sync пришел новый запрос (`_pending`);
- получение/сохранение `deviceId` через `FirebaseInstallations` и `sync_state`.

Важно:
- coordinator проверяет авторизацию через `AuthRepository.getSession()` (source of truth).
- если пользователь не авторизован, sync не запускается.

## 3.3 Бизнес-алгоритм sync

Файл:
- `lib/features/sync/domain/usecases/sync_interactor.dart`

`SyncInteractor.sync(deviceId)` делает следующее:
1. Читает `SyncState` (`lastCursor`, `deviceId`, `lastSyncedAt`).
2. Читает очередь операций (`getQueuedOps`).
3. Если очередь не пустая:
- выполняет push (`pushChanges`);
- удаляет подтвержденные `ack` операции из очереди;
- применяет `idMap` (маппинг `clientId -> networkId`);
- логирует серверные `errors`.
4. Выполняет pull (`pullChanges(cursor)`), получает `changes` и `nextCursor`.
5. Применяет `changes` локально.
6. Сохраняет новый state (`lastCursor`, `lastSyncedAt`, `deviceId`).

## 3.4 Data слой

Файлы:
- `lib/features/sync/data/repositories/sync_repository_impl.dart`
- `lib/features/sync/data/datasources/sync_local_datasource.dart`
- `lib/features/sync/data/datasources/sync_remote_datasource.dart`

`SyncRepositoryImpl`:
- маппит domain <-> data модели;
- проксирует вызовы в local/remote data source;
- скрывает детали JSON/DTO от domain.

`SyncLocalDataSource`:
- работает с Drift таблицами `sync_queue_table`, `sync_state_table`;
- enqueue/remove queued ops;
- применяет `idMap` в `tasksTable` и `subtasksTable`;
- применяет pull changes в локальные `tasksTable` и `subtasksTable`.

`SyncRemoteDataSource`:
- `POST /sync/push`
- `GET /sync/changes?cursor=...&limit=...&compact=...`

## 3.5 DI

Файл:
- `lib/features/sync/data/sync_di.dart`

Регистрирует:
- data source: `SyncLocalDataSource`, `SyncRemoteDataSource`;
- `SyncRepository`;
- `SyncInteractor`;
- публичные use case;
- `SyncCoordinator`;
- `RequestSyncUseCase`.

Глобальная инициализация вызывается через:
- `lib/core/services/locator.dart` -> `initSyncDependencies()`.

## 4. Локальные таблицы и что в них хранится

## 4.1 `sync_queue_table`

Файл:
- `lib/core/database/tables/sync_queue_table.dart`

Поля:
- `opId`, `entity`, `op`
- `clientId`, `networkId`
- `payload` (JSON)
- `createdAt`

Назначение:
- durable очередь исходящих операций.

## 4.2 `sync_state_table`

Файл:
- `lib/core/database/tables/sync_state_table.dart`

Поля:
- `id` (фиксированно `defaultId = 0`)
- `deviceId`
- `lastCursor`
- `lastSyncedAt`

Назначение:
- хранение позиции pull и метаданных последнего синка.

## 5. Формат sync-операций

Операция содержит:
- `op_id`: idempotency ключ;
- `entity`: например `task`, `subtask`;
- `op`: `create | update | delete`;
- `id`: server id (`networkId`) если уже известен;
- `client_id`: локальный стабильный id для offline create;
- `data`: payload операции (`title`, `description`, `is_completed`, `text`, `task_id`, `task_client_id` и т.д.).

Формируется через:
- `EnqueueSyncOpCommand`
- `EnqueueSyncOpData`

## 6. Текущие точки интеграции в приложении

## 6.1 Auth

Файл:
- `lib/core/auth/auth_cubit.dart`

Поведение:
- в конструкторе вызывает `_syncCoordinator?.onAppStart()`;
- при sign in / restore session вызывает `_syncCoordinator?.setAuthenticated(true)`;
- при sign out вызывает `_syncCoordinator?.setAuthenticated(false)`.

## 6.2 Home

Файл:
- `lib/features/home/presentation/bloc/home_bloc.dart`

Поведение:
- при `HomeStarted` вызывает `requestSyncUseCase(reason: 'foreground')`.

## 6.3 Tasks/Subtasks

Файлы:
- `lib/features/tasks/data/repositories/task_repository_impl.dart`
- `lib/features/tasks/data/repositories/sub_task_repository_impl.dart`

Поведение:
- после успешной локальной записи создают `EnqueueSyncOpCommand`;
- добавляют op через `EnqueueSyncOpUseCase`;
- запрашивают синк через `RequestSyncUseCase`.

Это гарантирует последовательность:
- сначала локальная консистентность;
- потом eventual consistency с сервером.

## 7. Как пользоваться sync в новой фиче

Базовый паттерн для любой фичи:

1. Сначала записать изменение локально (в Drift).
2. Сформировать sync op и добавить в очередь.
3. Запросить синк.

Пример:

```dart
final enqueue = locator<EnqueueSyncOpUseCase>();
final requestSync = locator<RequestSyncUseCase>();

await enqueue(
  EnqueueSyncOpCommand(
    opId: const Uuid().v4(),
    entity: 'task',
    op: 'update',
    id: task.networkId,
    clientId: task.clientId,
    data: EnqueueSyncOpData(
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
    ),
  ),
);

requestSync(reason: 'task_update');
```

Рекомендации:
- `opId` всегда уникальный (UUID);
- для offline create обязательно сохранять/передавать `clientId`;
- для зависимых сущностей использовать `taskClientId`, если `taskId` еще не сматчен сервером.

## 8. Контракты с backend

Используются endpoint'ы:
- `POST /sync/push`
- `GET /sync/changes`

Ожидаемые ключи:
- push request: `device_id`, `ops[]`;
- op: `op_id`, `entity`, `op`, `id`, `client_id`, `data`;
- push response: `ack[]`, `id_map`, `errors[]`;
- changes response: `next_cursor`, `changes[]`.

## 9. Ограничения текущей реализации

На текущий момент в локальном применении pull (`applyChanges`) явно реализованы только:
- `task`
- `subtask`

И в `applyIdMap` обновляются только:
- `tasksTable.networkId`
- `subtasksTable.networkId`

Если расширяем sync на новые entity, нужно:
- добавить обработку в `SyncLocalDataSourceImpl.applyChanges`;
- добавить `idMap` применение для новых таблиц;
- добавить enqueue из соответствующей feature.

## 10. Отладка и smoke-check

Логи идут через `TalkerService` с тегом `syncTag`.

Минимальная smoke-проверка:
1. Создать/обновить/удалить task offline.
2. Убедиться, что запись попала в `sync_queue_table`.
3. Дождаться запуска sync и очистки `ack` операций.
4. Проверить, что `networkId` проставился через `idMap`.
5. Проверить обновление `sync_state_table.lastCursor` и `lastSyncedAt`.
6. Проверить применение pull-изменений в локальных таблицах.
