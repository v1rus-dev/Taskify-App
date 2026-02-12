# Phase 2: Friends Consolidation

## Goal
Сделать `features/friends_list` единственным владельцем friends-домена и убрать глобальные `lib/data/friends` и `lib/domain/friends`.

## Scope
1. Перенести в `features/friends_list`:
- `lib/data/friends/**`
- `lib/domain/friends/**`
2. Перенести API:
- `lib/data/api/friends_api.dart` -> `features/friends_list/data/api/friends_api.dart`
3. Обновить потребителей:
- `lib/features/friends_list/**` на собственный feature API/use cases.
- `lib/features/profile/data/repository/profile_repository.dart` заменить прямой API вызов на use case из friends feature (`RegenerateFriendTagUseCase`).
4. Перенести startup-задачу friends в friends feature и зарегистрировать через DI как задачу для `AppStartupCoordinator`.

## Target Structure
- Владелец friends моделей/репозиториев/use cases: `features/friends_list`.
- Другие фичи работают с friends только через публичные use case контракты.

## Acceptance Criteria
1. Нет импортов `package:taskify/domain/friends/...` и `package:taskify/data/friends/...` в feature/core коде.
2. `friends_list` и связанные bottom sheets работают через новый feature API.
3. `profile` не использует `FriendsApi` напрямую.
4. `AppStartupCoordinator` продолжает запускать friends startup flow при авторизации.

## Dependencies
- Phase 1 завершен и DI структура стабилизирована.
- `NetworkInfo` используется как shared infra через `core/network/network_info.dart`.

## Definition of Done
1. `lib/data/friends/**` и `lib/domain/friends/**` удалены.
2. Все друзья/заявки операции работают без регрессий:
- refresh friends;
- refresh requests;
- accept/decline/cancel/remove;
- friend info.
3. `flutter analyze` и smoke-check ключевых flow успешны.

