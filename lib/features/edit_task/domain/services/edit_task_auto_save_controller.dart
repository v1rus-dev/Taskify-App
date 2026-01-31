import 'dart:async';

class EditTaskAutoSaveController {
  EditTaskAutoSaveController({
    required Duration debounce,
    required bool Function() shouldSave,
    required void Function() onTrigger,
  })  : _debounce = debounce,
        _shouldSave = shouldSave,
        _onTrigger = onTrigger;

  final Duration _debounce;
  final bool Function() _shouldSave;
  final void Function() _onTrigger;

  Timer? _timer;
  bool _enabled = false;

  void enable() {
    _enabled = true;
  }

  void scheduleSave() {
    if (!_enabled) {
      return;
    }
    _timer?.cancel();
    if (!_shouldSave()) {
      return;
    }
    _timer = Timer(_debounce, _onTrigger);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}
