import 'package:dart_either/dart_either.dart';
import 'package:taskify/core/error/failures.dart';
import 'package:taskify/features/sync/domain/models/sync_op_data_entity.dart';
import 'package:taskify/features/sync/domain/models/sync_queue_entry_entity.dart';
import 'package:taskify/features/sync/domain/repositories/sync_repository.dart';

class EnqueueSyncOpUseCase {
  EnqueueSyncOpUseCase(this._repository);

  final SyncRepository _repository;

  Future<Either<Failure, void>> call(EnqueueSyncOpCommand command) {
    return _repository.enqueueOp(
      SyncQueueEntryEntity(
        opId: command.opId,
        entity: command.entity,
        op: command.op,
        id: command.id,
        clientId: command.clientId,
        data: command.data == null
            ? null
            : SyncOpDataEntity(
                title: command.data!.title,
                description: command.data!.description,
                isCompleted: command.data!.isCompleted,
                text: command.data!.text,
                taskId: command.data!.taskId,
                taskClientId: command.data!.taskClientId,
                name: command.data!.name,
                color: command.data!.color,
                isUserTag: command.data!.isUserTag,
              ),
      ),
    );
  }
}

class EnqueueSyncOpCommand {
  const EnqueueSyncOpCommand({
    required this.opId,
    required this.entity,
    required this.op,
    this.id,
    this.clientId,
    this.data,
  });

  final String opId;
  final String entity;
  final String op;
  final int? id;
  final String? clientId;
  final EnqueueSyncOpData? data;
}

class EnqueueSyncOpData {
  const EnqueueSyncOpData({
    this.title,
    this.description,
    this.isCompleted,
    this.text,
    this.taskId,
    this.taskClientId,
    this.name,
    this.color,
    this.isUserTag,
  });

  final String? title;
  final String? description;
  final bool? isCompleted;
  final String? text;
  final int? taskId;
  final String? taskClientId;
  final String? name;
  final String? color;
  final bool? isUserTag;
}
