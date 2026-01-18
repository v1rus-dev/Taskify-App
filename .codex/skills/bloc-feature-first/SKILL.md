---
name: bloc-feature-first
description: Use for BLoC feature-first Flutter work such as “создай bloc”, “создай фичу”, “создай экран с функционалом”, or “создай часть экрана с отдельным BLoC”. Default to Bloc (event-based). Use Cubit only when event semantics are not needed. Use @freezed for state/events only and resolve dependencies via get_it when they are not passed explicitly.
---

# BLoC Feature-First (Default) + Cubit (When Needed)

## Overview
Create feature-first Flutter code using **BLoC (default)**, **Freezed for events/states only**, and **get_it** for dependency lookup.

Goals:
- predictable structure
- minimal boilerplate
- explicit event-driven flows by default
- no business logic in UI

---

## Workflow Decision Tree

- If asked **“создай фичу”**
  → scaffold the feature directory and core files, then implement screen + **Bloc**.

- If asked **“создай bloc”**
  → create **events (Freezed)** + **state (Freezed)** + Bloc class.

- If asked **“создай экран с функционалом”**
  → create screen widget + bloc + events/state and wire them together.

- If asked **“создай часть экрана с отдельным BLoC”**
  → create a widget and a dedicated bloc scoped only to that widget.

- If asked explicitly **“сделай cubit”** (or it’s a very small state without meaningful events)
  → use **Cubit**.

---

## Code rules

- File names use `snake_case`
- One Bloc/Cubit = one responsibility
- Bloc + event/state live together under the feature
- Feature code never depends on another feature directly

---

## Default Choice: Bloc (Event-based)

### Events (Freezed unions)

Use the pattern below (same as your example):

```dart
@freezed
class EditTaskEvent with _$EditTaskEvent {
  const factory EditTaskEvent.started() = _Started;

  const factory EditTaskEvent.titleChanged(String title) = _TitleChanged;

  const factory EditTaskEvent.subTaskToggle(int index) = _SubTaskToggle;
  const factory EditTaskEvent.subTaskRemoved(int index) = _SubTaskRemoved;
  const factory EditTaskEvent.subTaskTextChanged(int index, String text) =
      _SubTaskTextChanged;

  const factory EditTaskEvent.selectDate(
    DateTime date,
    bool isAllDay,
    DateTime? startTime,
    DateTime? endTime,
  ) = _SelectDate;

  const factory EditTaskEvent.saveTask(Completer completer) = _SaveTask;
}
````

---

## State Patterns (Choose One)

### Option A: Union states (initial/loading/loaded/error)

Use when:

* screen has clearly different phases
* initial vs loaded UI differs a lot
* you want strict “can’t access fields before loaded”

Example (your style):

```dart
@freezed
class EditTaskState with _$EditTaskState {
  const factory EditTaskState.initial() = _Initial;

  const factory EditTaskState.loaded(
    String title,
    String description,
    int? taskId,
    int? networkId,
    bool isCompleted,
    DateTime? selectedDate,
    DateTime? startTime,
    DateTime? endTime,
    bool isAllDay,
    bool titleIsNotEmpty,
    List<SubTaskUiModel> subTasks,
  ) = _LoadedState;
}
```

Recommended additions (optional):

* `const factory EditTaskState.loading(...)`
* `const factory EditTaskState.failure(String message, {Failure? failure})`

---

### Option B: Single state object (data class)

Use when:

* UI mostly the same
* fields always exist
* you just flip flags and replace lists

Example (your style):

```dart
@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isHeaderExpanded,
    required DateTime selectedDate,
    required DateTime currentDate,
    required List<TaskEntity> tasks,
    @Default(TasksViewType.tasks) TasksViewType tasksViewType,
    @Default(false) bool isLoading,
    @Default('') String message,
    @Default('') String error,
  }) = _HomeState;
}
```

Rule of thumb:

* **Union** for “modes”
* **Single** for “toggles + data”

---

## Bloc Implementation Skeleton

```dart
class <Name>Bloc extends Bloc<<Name>Event, <Name>State> {
  final <Service> _service = getIt<<Service>>();

  <Name>Bloc() : super(const <Name>State.initial()) {
    on<<Name>Event>(_onEvent);
  }

  Future<void> _onEvent(
    <Name>Event event,
    Emitter<<Name>State> emit,
  ) async {
    await event.map(
      started: (_) async {
        // emit loading/loaded
      },
      // other events...
    );
  }
}
```

Notes:

* Prefer `event.map(...)` / `maybeMap(...)` or `when(...)` patterns from Freezed.
* Keep handler methods small; extract private methods for complex logic.

---

## Screen / Widget Wiring

```dart
BlocProvider(
  create: (_) => <Name>Bloc()..add(const <Name>Event.started()),
  child: BlocBuilder<<Name>Bloc, <Name>State>(
    builder: (context, state) {
      return state.when(
        initial: () => const SizedBox.shrink(),
        loaded: (/* fields */) => /* UI */,
      );
    },
  ),
);
```

### Side effects (navigation, snackbars)

```dart
BlocListener<<Name>Bloc, <Name>State>(
  listenWhen: (prev, curr) => prev != curr,
  listener: (context, state) {
    // show snackbar, navigate, etc.
  },
  child: ...
);
```

---

## Cubit (Only When Needed)

Use **Cubit** when:

* no meaningful events (only “set X”, “toggle”, “load once”)
* very small isolated widget state
* event semantics add noise

Cubit + single state is the typical combo.

---

## Dependency Rules

* If dependency is **not passed explicitly** → resolve via `getIt<T>()`
* UI never calls repositories directly
* Bloc/Cubit talks to services/usecases

---

## Codegen

Run build_runner for Freezed or Drift Database:

```bash
dart run build_runner build --delete-conflicting-outputs
```

```bash
dart run build_runner watch --delete-conflicting-outputs
```
