import 'package:equatable/equatable.dart';
import 'package:taskify/features/spaces/domain/models/space_role.dart';

DateTime? _parseDate(dynamic value) {
  if (value is! String || value.isEmpty) {
    return null;
  }
  return DateTime.tryParse(value);
}

String? _stringOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  return value.toString();
}

class PagedResultModel<T> extends Equatable {
  const PagedResultModel({required this.items, this.nextCursor});

  final List<T> items;
  final String? nextCursor;

  factory PagedResultModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    final rawItems =
        (json['items'] ?? json['data'] ?? json['results']) as List<dynamic>? ??
        const <dynamic>[];
    return PagedResultModel(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(itemParser)
          .toList(),
      nextCursor: _stringOrNull(json['next_cursor'] ?? json['nextCursor']),
    );
  }

  @override
  List<Object?> get props => [items, nextCursor];
}

class SpaceModel extends Equatable {
  const SpaceModel({
    required this.id,
    required this.name,
    required this.role,
    required this.isLightweight,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final SpaceRole role;
  final bool isLightweight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: _stringOrNull(json['id']) ?? '',
      name: _stringOrNull(json['name']) ?? '',
      description: _stringOrNull(json['description']),
      role: SpaceRole.fromValue(_stringOrNull(json['role'])),
      isLightweight: (json['is_lightweight'] ?? json['isLightweight']) == true,
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    role,
    isLightweight,
    createdAt,
    updatedAt,
  ];
}

class SpaceMemberModel extends Equatable {
  const SpaceMemberModel({
    required this.spaceId,
    required this.userId,
    required this.role,
    this.name,
    this.avatarUrl,
    this.joinedAt,
  });

  final String spaceId;
  final String userId;
  final String? name;
  final String? avatarUrl;
  final SpaceRole role;
  final DateTime? joinedAt;

  factory SpaceMemberModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackSpaceId,
  }) {
    final user = json['user'] as Map<String, dynamic>?;
    return SpaceMemberModel(
      spaceId:
          _stringOrNull(json['space_id'] ?? json['spaceId']) ??
          fallbackSpaceId ??
          '',
      userId:
          _stringOrNull(json['user_id'] ?? json['userId'] ?? user?['id']) ?? '',
      name: _stringOrNull(json['name'] ?? user?['name']),
      avatarUrl: _stringOrNull(
        json['avatar_url'] ?? json['avatarUrl'] ?? user?['avatar_url'],
      ),
      role: SpaceRole.fromValue(_stringOrNull(json['role'])),
      joinedAt: _parseDate(json['joined_at'] ?? json['joinedAt']),
    );
  }

  @override
  List<Object?> get props => [spaceId, userId, name, avatarUrl, role, joinedAt];
}

class SpaceInviteModel extends Equatable {
  const SpaceInviteModel({
    required this.id,
    required this.spaceId,
    required this.role,
    required this.isRevoked,
    this.token,
    this.expiresAt,
    this.createdAt,
  });

  final String id;
  final String spaceId;
  final String? token;
  final SpaceRole role;
  final bool isRevoked;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  factory SpaceInviteModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackSpaceId,
  }) {
    return SpaceInviteModel(
      id: _stringOrNull(json['id'] ?? json['invite_id']) ?? '',
      spaceId:
          _stringOrNull(json['space_id'] ?? json['spaceId']) ??
          fallbackSpaceId ??
          '',
      token: _stringOrNull(json['token']),
      role: SpaceRole.fromValue(_stringOrNull(json['role'])),
      isRevoked: (json['is_revoked'] ?? json['isRevoked']) == true,
      expiresAt: _parseDate(json['expires_at'] ?? json['expiresAt']),
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    spaceId,
    token,
    role,
    isRevoked,
    expiresAt,
    createdAt,
  ];
}

class SpaceListModel extends Equatable {
  const SpaceListModel({
    required this.id,
    required this.spaceId,
    required this.title,
    required this.order,
    this.updatedAt,
  });

  final String id;
  final String spaceId;
  final String title;
  final int order;
  final DateTime? updatedAt;

  factory SpaceListModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackSpaceId,
  }) {
    return SpaceListModel(
      id: _stringOrNull(json['id'] ?? json['list_id']) ?? '',
      spaceId:
          _stringOrNull(json['space_id'] ?? json['spaceId']) ??
          fallbackSpaceId ??
          '',
      title: _stringOrNull(json['title']) ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [id, spaceId, title, order, updatedAt];
}

class SpaceTaskModel extends Equatable {
  const SpaceTaskModel({
    required this.id,
    required this.spaceId,
    required this.title,
    required this.isCompleted,
    this.listId,
    this.description,
    this.assigneeId,
    this.claimedById,
    this.completedAt,
    this.updatedAt,
  });

  final String id;
  final String spaceId;
  final String title;
  final String? listId;
  final String? description;
  final String? assigneeId;
  final String? claimedById;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? updatedAt;

  factory SpaceTaskModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackSpaceId,
  }) {
    return SpaceTaskModel(
      id: _stringOrNull(json['id'] ?? json['task_id']) ?? '',
      spaceId:
          _stringOrNull(json['space_id'] ?? json['spaceId']) ??
          fallbackSpaceId ??
          '',
      title: _stringOrNull(json['title']) ?? '',
      listId: _stringOrNull(json['list_id'] ?? json['listId']),
      description: _stringOrNull(json['description']),
      assigneeId: _stringOrNull(json['assignee_id'] ?? json['assigneeId']),
      claimedById: _stringOrNull(json['claimed_by_id'] ?? json['claimedById']),
      isCompleted: (json['is_completed'] ?? json['isCompleted']) == true,
      completedAt: _parseDate(json['completed_at'] ?? json['completedAt']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    spaceId,
    title,
    listId,
    description,
    assigneeId,
    claimedById,
    isCompleted,
    completedAt,
    updatedAt,
  ];
}

class SpaceSubTaskModel extends Equatable {
  const SpaceSubTaskModel({
    required this.id,
    required this.spaceId,
    required this.taskId,
    required this.title,
    required this.isCompleted,
    this.updatedAt,
  });

  final String id;
  final String spaceId;
  final String taskId;
  final String title;
  final bool isCompleted;
  final DateTime? updatedAt;

  factory SpaceSubTaskModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackSpaceId,
    String? fallbackTaskId,
  }) {
    return SpaceSubTaskModel(
      id: _stringOrNull(json['id'] ?? json['subtask_id']) ?? '',
      spaceId:
          _stringOrNull(json['space_id'] ?? json['spaceId']) ??
          fallbackSpaceId ??
          '',
      taskId:
          _stringOrNull(json['task_id'] ?? json['taskId']) ??
          fallbackTaskId ??
          '',
      title: _stringOrNull(json['title']) ?? '',
      isCompleted: (json['is_completed'] ?? json['isCompleted']) == true,
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    spaceId,
    taskId,
    title,
    isCompleted,
    updatedAt,
  ];
}

class SpaceNoteModel extends Equatable {
  const SpaceNoteModel({
    required this.id,
    required this.spaceId,
    required this.title,
    this.body,
    this.updatedAt,
  });

  final String id;
  final String spaceId;
  final String title;
  final String? body;
  final DateTime? updatedAt;

  factory SpaceNoteModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackSpaceId,
  }) {
    return SpaceNoteModel(
      id: _stringOrNull(json['id'] ?? json['note_id']) ?? '',
      spaceId:
          _stringOrNull(json['space_id'] ?? json['spaceId']) ??
          fallbackSpaceId ??
          '',
      title: _stringOrNull(json['title']) ?? '',
      body: _stringOrNull(json['body'] ?? json['content'] ?? json['text']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [id, spaceId, title, body, updatedAt];
}

class SpaceCreateRequestModel {
  const SpaceCreateRequestModel({
    required this.name,
    this.description,
    this.isLightweight = false,
  });

  final String name;
  final String? description;
  final bool isLightweight;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'is_lightweight': isLightweight,
    };
  }
}

class SpaceMemberCreateRequestModel {
  const SpaceMemberCreateRequestModel({
    required this.userId,
    required this.role,
  });

  final String userId;
  final SpaceRole role;

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'role': role.value};
  }
}

class SpaceMemberRoleUpdateRequestModel {
  const SpaceMemberRoleUpdateRequestModel({required this.role});

  final SpaceRole role;

  Map<String, dynamic> toJson() {
    return {'role': role.value};
  }
}

class SpaceInviteCreateRequestModel {
  const SpaceInviteCreateRequestModel({required this.role, this.expiresAt});

  final SpaceRole role;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() {
    return {
      'role': role.value,
      if (expiresAt != null) 'expires_at': expiresAt!.toUtc().toIso8601String(),
    };
  }
}

class SpaceTaskListCreateRequestModel {
  const SpaceTaskListCreateRequestModel({required this.title});

  final String title;

  Map<String, dynamic> toJson() {
    return {'title': title};
  }
}

class SpaceTaskListUpdateRequestModel {
  const SpaceTaskListUpdateRequestModel({required this.title});

  final String title;

  Map<String, dynamic> toJson() {
    return {'title': title};
  }
}

class SpaceTaskListReorderRequestModel {
  const SpaceTaskListReorderRequestModel({required this.orderedIds});

  final List<String> orderedIds;

  Map<String, dynamic> toJson() {
    return {'ordered_ids': orderedIds};
  }
}

class SpaceTaskCreateRequestModel {
  const SpaceTaskCreateRequestModel({
    required this.title,
    this.listId,
    this.description,
  });

  final String title;
  final String? listId;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (listId != null) 'list_id': listId,
      if (description != null) 'description': description,
    };
  }
}

class SpaceTaskUpdateRequestModel {
  const SpaceTaskUpdateRequestModel({
    this.title,
    this.listId,
    this.description,
  });

  final String? title;
  final String? listId;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (listId != null) 'list_id': listId,
      if (description != null) 'description': description,
    };
  }
}

class SpaceTaskAssignRequestModel {
  const SpaceTaskAssignRequestModel({required this.userId});

  final String userId;

  Map<String, dynamic> toJson() {
    return {'user_id': userId};
  }
}

class SpaceSubTaskCreateRequestModel {
  const SpaceSubTaskCreateRequestModel({required this.title});

  final String title;

  Map<String, dynamic> toJson() {
    return {'title': title};
  }
}

class SpaceSubTaskUpdateRequestModel {
  const SpaceSubTaskUpdateRequestModel({this.title, this.isCompleted});

  final String? title;
  final bool? isCompleted;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (isCompleted != null) 'is_completed': isCompleted,
    };
  }
}

class SpaceNoteCreateRequestModel {
  const SpaceNoteCreateRequestModel({required this.title, this.body});

  final String title;
  final String? body;

  Map<String, dynamic> toJson() {
    return {'title': title, if (body != null) 'body': body};
  }
}

class SpaceNoteUpdateRequestModel {
  const SpaceNoteUpdateRequestModel({this.title, this.body});

  final String? title;
  final String? body;

  Map<String, dynamic> toJson() {
    return {if (title != null) 'title': title, if (body != null) 'body': body};
  }
}
