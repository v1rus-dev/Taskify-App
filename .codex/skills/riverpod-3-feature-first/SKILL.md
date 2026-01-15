---
name: riverpod-3-feature-first
description: Use for Riverpod 3 feature-first Flutter work such as “создай notifier”, “создай фичу”, “создай экран с функционалом”, or “создай часть экрана с отдельным Riverpod/Notifier”. Apply Riverpod 3 providers without provider codegen, use @freezed for state only, and resolve dependencies via get_it when they are not passed in explicitly.
---

# Riverpod 3 Feature-First

## Overview
Create feature-first Flutter code with Riverpod 3 Notifiers, Freezed state classes, and get_it-based dependency lookup. Focus on clear folder structure, minimal boilerplate, and codegen only for state (`@freezed`).

## Workflow Decision Tree
- If asked “создай фичу”, scaffold the feature directory and core files, then implement the screen and notifier.
- If asked “создай notifier”, create the notifier + state (Freezed) and expose a provider.
- If asked “создай экран с функционалом”, create a screen widget plus its notifier/state and wire to UI.
- If asked “создай часть экрана с отдельным Riverpod/Notifier”, create a widget and a dedicated notifier/state scoped to it.

## Feature-First Structure
Use this baseline layout (adjust as needed for the request):

```
lib/features/<feature>/
  presentation/
    screens/
    widgets/
    providers/
  domain/
    models/
    use_cases/
  data/
    repositories/
    sources/
```

Name files in `snake_case` and keep provider code close to its feature (e.g., `presentation/providers/<scope>/`).

## Notifier + Freezed State (No Provider Codegen)
Define the state with `@freezed` and use a manual `NotifierProvider`:

```dart
// presentation/providers/<scope>/<name>_state.dart
@freezed
class <Name>State with _$<Name>State {
  const factory <Name>State({
    @Default(false) bool isLoading,
    @Default([]) List<<Type>> items,
    String? error,
  }) = _<Name>State;
}
```

```dart
// presentation/providers/<scope>/<name>_notifier.dart
final <name>Provider =
    NotifierProvider<<Name>Notifier, <Name>State>(<Name>Notifier.new);

class <Name>Notifier extends Notifier<<Name>State> {
  final <Service> _service = getIt<<Service>>();

  @override
  <Name>State build() => const <Name>State();

  Future<void> load() async { /* update state */ }
}
```

Run codegen for state only:
`dart run build_runner build --delete-conflicting-outputs`.

## Screen or Widget Wiring
Use `ConsumerWidget`/`HookConsumerWidget` and read state via `ref.watch(<name>Provider)`. Trigger actions with `ref.read(<name>Provider.notifier)`.

For partial-screen requests, put widget code in `presentation/widgets/` and keep its notifier under `presentation/providers/<widget_name>/`.

## Dependency Rules
If the user does not pass a dependency explicitly, resolve it via `get_it` (e.g., `getIt<MyRepo>()`). Do not inject through constructors unless the request specifies it.

## Output Checklist
- Create folders and files under `lib/features/<feature>/`.
- Add `@freezed` state and run build_runner instructions.
- Implement notifier logic with Riverpod 3 `Notifier` + `NotifierProvider`.
- Wire UI to provider state/actions.
