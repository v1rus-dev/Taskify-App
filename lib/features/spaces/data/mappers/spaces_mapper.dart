import 'package:taskify/features/spaces/data/models/spaces_models.dart';
import 'package:taskify/features/spaces/domain/models/paged_result.dart';
import 'package:taskify/features/spaces/domain/models/space.dart';
import 'package:taskify/features/spaces/domain/models/space_invite.dart';
import 'package:taskify/features/spaces/domain/models/space_list.dart';
import 'package:taskify/features/spaces/domain/models/space_member.dart';
import 'package:taskify/features/spaces/domain/models/space_note.dart';
import 'package:taskify/features/spaces/domain/models/space_subtask.dart';
import 'package:taskify/features/spaces/domain/models/space_task.dart';

extension SpaceModelMapper on SpaceModel {
  SpaceEntity toDomain() {
    return SpaceEntity(
      id: id,
      name: name,
      description: description,
      role: role,
      isLightweight: isLightweight,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension SpacePagedModelMapper on PagedResultModel<SpaceModel> {
  PagedResultEntity<SpaceEntity> toDomain() {
    return PagedResultEntity(
      items: items.map((space) => space.toDomain()).toList(),
      nextCursor: nextCursor,
    );
  }
}

extension SpaceMemberModelMapper on SpaceMemberModel {
  SpaceMemberEntity toDomain() {
    return SpaceMemberEntity(
      spaceId: spaceId,
      userId: userId,
      name: name,
      avatarUrl: avatarUrl,
      role: role,
      joinedAt: joinedAt,
    );
  }
}

extension SpaceInviteModelMapper on SpaceInviteModel {
  SpaceInviteEntity toDomain() {
    return SpaceInviteEntity(
      id: id,
      spaceId: spaceId,
      token: token,
      role: role,
      isRevoked: isRevoked,
      expiresAt: expiresAt,
      createdAt: createdAt,
    );
  }
}

extension SpaceListModelMapper on SpaceListModel {
  SpaceListEntity toDomain() {
    return SpaceListEntity(
      id: id,
      spaceId: spaceId,
      title: title,
      order: order,
      updatedAt: updatedAt,
    );
  }
}

extension SpaceTaskModelMapper on SpaceTaskModel {
  SpaceTaskEntity toDomain() {
    return SpaceTaskEntity(
      id: id,
      spaceId: spaceId,
      title: title,
      listId: listId,
      description: description,
      assigneeId: assigneeId,
      claimedById: claimedById,
      isCompleted: isCompleted,
      completedAt: completedAt,
      updatedAt: updatedAt,
    );
  }
}

extension SpaceSubTaskModelMapper on SpaceSubTaskModel {
  SpaceSubTaskEntity toDomain() {
    return SpaceSubTaskEntity(
      id: id,
      spaceId: spaceId,
      taskId: taskId,
      title: title,
      isCompleted: isCompleted,
      updatedAt: updatedAt,
    );
  }
}

extension SpaceNoteModelMapper on SpaceNoteModel {
  SpaceNoteEntity toDomain() {
    return SpaceNoteEntity(
      id: id,
      spaceId: spaceId,
      title: title,
      body: body,
      updatedAt: updatedAt,
    );
  }
}
