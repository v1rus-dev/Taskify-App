# Phase 4: Settings + Auth Cleanup and Final Removal of Global Layers

## Goal
Завершить отказ от глобальных `lib/data` и `lib/domain`: вынести настройки в `features/settings`, auth API/preferences в feature-владельцев, удалить остатки общих бизнес-слоёв.

## Scope
1. Создать `features/settings` и перенести:
- `lib/data/interactors/app_configuration_interactor.dart`
- `lib/domain/models/time_format_type.dart`
2. Обновить потребителей settings:
- `lib/features/profile/**`
- `lib/core/providers/time_format_notifier.dart`
- `lib/app/app.dart`
3. Перенести auth-specific инфраструктуру:
- `lib/data/api/auth_api.dart` -> `features/auth/data/api/auth_api.dart`
- `lib/data/preferences/app_preferences.dart` -> владелец feature (по текущему коду: `features/auth`)
4. Удалить global API aggregation:
- `lib/data/api/api_di.dart`
- регистрация API в DI конкретных фич (`auth`, `friends_list`).
5. Финальная очистка:
- удалить `lib/data/**` и `lib/domain/**`
- обновить `core/services/locator.dart` на feature-only composition root.

## Target Structure
- `core` содержит только инфраструктуру.
- Бизнес-логика целиком в feature-first структуре.
- Межфичевые зависимости только через use case API владельцев.

## Acceptance Criteria
1. В репозитории отсутствуют папки `lib/data` и `lib/domain`.
2. Нет импортов `package:taskify/data/...` и `package:taskify/domain/...`.
3. Time format, profile, auth flows работают через feature-level интерфейсы.
4. DI инициализируется без global business modules.

## Dependencies
- Phases 1-3 завершены.
- Все критические use case контракты (tasks/friends/sync) уже зафиксированы.

## Definition of Done
1. Полная компиляция и `flutter analyze` без новых ошибок.
2. Пройдены ключевые e2e smoke-сценарии:
- sign in/sign out/session restore;
- home/tasks/edit task;
- friends list + requests;
- profile settings (time format/language/theme).
3. Архитектурная цель достигнута: feature-first без общих business data/domain в core-уровне.

