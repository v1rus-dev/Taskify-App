# Project Overview

Taskify is a ToDo application for mobile, working on Android and iOS, powered by Flutter. The main function of application: todo, auth, friends, group spaces and group todos.

## Flutter Expert Profile

You are an expert in Flutter, Bloc, and Clean Architecture. Use feature-first organization.

## Documentation Requirements

- Complex Logic: Try not to use a comments

### Updating this document

AI agents should update this file whenever they learn something new about this project, only something what can be usefull for all project, like architecture, common component etc. Not specific features. Keeping the guidelines current helps everyone work more effectively.

## Architecture

This is a Flutter app with the main code under `lib/` and design package in `design/lib`

- Spaces backend contract source of truth for client implementation is `spaces_swagger.yaml` in project root (current MVP contract).

`lib` areas include:
-`app`- application initialization.
-`app/router` - navigation system powered by GoRouter.
-`core` - shared utilities, constants, and cross-cutting concerns.
-`data` - implementation of the data layer, which keep database (Drift), datasource, and api (Dio). And implementation of shared buisness logic from `domain`;
-`domain` - shared domain models and shared buisness logic.
-`features` - features powered by feature-first.
-`l10n` - application translation module.

`design/lib` areas includes:
-`bottom_sheets` - base bottom sheets widgets.
-`constants` - application resources constants like: AnimationDuration, Icon, Inset, Radiuse.
-`dialogs` - application dialog system.
-`enum` - shared ui enums, like `enums/app_theme_mode.dart`.
-`model` - shared ui models.
-`themes` - implementation of application themes.
-`themes/color` - implementation of application colors.
-`themes/typography` - implementation of application typography.
-`widgets` - shared widgets.

UI Components which can uses more then one feature, write reusable and keep in `design/lib/widgets`.

### Auth session source of truth

- `AuthRepository.getSession()` is the single source of truth for "is authenticated" in app-wide coordinators.
- Session restore must support both Firebase providers (Google/Apple) and non-Firebase local sessions (test accounts via saved tokens + local user).
- Startup/sync coordinators should refresh auth state through `AuthRepository.getSession()` on app start, not rely only on in-memory cubit state.

## Dependency Injection

- Use GetIt as a service locator for dependency injection `libs/core/services/locator.dart`.
- Implement lazy initialization where appropriate.
- Use factories for transient objects and singletons for services.
- Register dependencies by feature in separate files.
- Shared network availability checks should go through `core/network/network_info.dart` (`NetworkInfo`), not directly from feature BLoCs.

## Code style

- Keep code simple, explicit, typed.
- Adhere to generally accepted code style standards in Flutter.
- Don't use freezed, can use Equetable.
- Use `either` for async function results.

## UI code style & principals

- Functions called in widgets are written as a separate function inside the widget.
- Divide logical UI blocks into different widgets and different files.
- Use Material with InkWell for all buttons, for ripple effects, except clicked text, in this situation you can use simple GestureDetector.
- Use centralized dialog helpers from `design/lib/dialogs/app_dialogs.dart`; avoid direct `showDialog` in feature screens.

## Build commands

- `flutter pub get` - for updating libraries or build flutter project after.
- `flutter clean` - for clean project.
- `dart run build_ranner build --delete-conflicting-outputs` - for regenerate database after changing models.

## Commit & Pull Request Quidelines

- Commits: imperative mood; prefer Conventional Commits (e.g., ‘feat:‘, ‘fix:‘, ‘docs:‘) with a clear scope.- Friends screen should not auto-fetch on every open: subscribe to local streams and use pull-to-refresh for manual sync.
