class SyncOpErrorEntity {
  const SyncOpErrorEntity({
    required this.opId,
    required this.code,
    required this.message,
  });

  final String opId;
  final String code;
  final String message;
}
