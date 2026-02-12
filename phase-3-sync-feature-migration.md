# Phase 3: Sync Feature Extraction

## Goal
Выделить sync в отдельную `features/sync` и убрать глобальные `lib/data/sync` и `lib/domain/sync`.

## Scope
1. Перенести в `features/sync`:
- `lib/data/sync/**`
- `lib/domain/sync/**`
- `lib/core/sync/sync_coordinator.dart` (в sync feature слой orchestration)
2. Ввести публичные use cases sync feature:
- `EnqueueSyncOpUseCase`
- `RequestSyncUseCase`
- `RunSyncUseCase`
- `GetSyncStateUseCase` / `SaveSyncStateUseCase` (по необходимости)
3. Обновить integrations:
- `features/tasks` использует sync только через use case, без прямой зависимости от `SyncRepository`.
- app-level компоненты (`AuthCubit`, startup flow) получают coordinator из `features/sync` DI.
4. Удалить глобальный `lib/data/sync/sync_di.dart`; регистрация sync зависимостей только в feature DI.

## Target Structure
- Владелец sync-моделей и оркестрации: `features/sync`.
- Внешние фичи видят только use case API sync.

## Acceptance Criteria
1. Нет импортов `package:taskify/domain/sync/...` и `package:taskify/data/sync/...` вне `features/sync`.
2. Tasks enqueue и schedule sync через sync use cases.
3. Startup/auth/foreground/network триггеры sync работают как раньше.
4. Session restore продолжает использовать `AuthRepository.getSession()` как source of truth.

## Dependencies
- Phase 1 завершен (tasks domain стабилен).
- Phase 2 завершен или совместим по DI (startup tasks и auth orchestration не ломаются).

## Definition of Done
1. Глобальные sync папки удалены.
2. Sync flow проходит smoke-проверку:
- enqueue ops;
- push/pull;
- apply changes;
- device id restore/save.
3. `flutter analyze` без новых ошибок.

