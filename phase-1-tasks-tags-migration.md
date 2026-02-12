# Phase 1: Tasks/Tags Consolidation

## Goal
Сделать `features/tasks` единственным владельцем задач, тегов и сабтасков, убрав зависимость от глобальных `lib/data` и `lib/domain` для этого домена.

## Scope
1. Перенести в `features/tasks`:
- `lib/domain/tags/**`
- `lib/domain/repository/task_repository.dart`
- `lib/data/repositories/task_repository_impl.dart`
- `lib/data/repositories/tag_repository_impl.dart`
- `lib/data/mappers/task_mapper.dart`
- `lib/data/mappers/tag_mapper.dart`
2. Обновить импорты в:
- `lib/features/home/**`
- `lib/features/tasks/**`
- `lib/features/activity/**`
- `lib/core/widgets/tag_cheap.dart`
3. Убрать прямую зависимость `home` от `TaskRepository`.
4. Оставить временную интеграцию с текущим sync-слоем до Phase 3.

## Target Structure
- Владелец доменных моделей `Tag/SubTask/Task*`: `features/tasks`.
- Межфичевой доступ к tasks/tags только через use case API `features/tasks`.

## Acceptance Criteria
1. Нет импортов `package:taskify/domain/tags/...` и `package:taskify/domain/repository/task_repository.dart` вне `features/tasks` (или они полностью удалены).
2. `home` использует use case API tasks, а не `TaskRepository`.
3. Функции create/update/delete task, tags, subtasks работают без регрессий.
4. `flutter analyze` проходит без новых ошибок.

## Dependencies
- Базовый перенос `edit_task` в `features/tasks` уже завершен.
- DI в `core/services/locator.dart` допускает подключение feature-level модулей.

## Definition of Done
1. Глобальные task/tag репозитории и мапперы удалены из `lib/data` и `lib/domain`.
2. Все потребители task/tag моделей переведены на `features/tasks`.
3. Проверены сценарии:
- список задач;
- task info;
- edit task;
- операции с тегами и сабтасками.

