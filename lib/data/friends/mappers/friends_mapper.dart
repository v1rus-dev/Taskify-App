import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/data/friends/models/friend_request_item_response_model.dart';
import 'package:taskify/data/friends/models/friend_response_model.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';

extension FriendResponseModelMapper on FriendResponseModel {
  db.FriendsTableCompanion toCompanion() {
    return db.FriendsTableCompanion(
      id: Value(id),
      friendTag: Value(friendTag),
      name: Value(name),
      avatarUrl: Value(avatarUrl),
      anonymousNumber: Value(anonymousNumber),
    );
  }
}

extension FriendEntityMapper on FriendEntity {
  db.FriendsTableCompanion toCompanion() {
    return db.FriendsTableCompanion(
      id: Value(id),
      friendTag: Value(friendTag),
      name: Value(name),
      avatarUrl: Value(avatarUrl),
      anonymousNumber: Value(anonymousNumber),
    );
  }
}

extension FriendRequestItemResponseModelMapper
    on FriendRequestItemResponseModel {
  db.FriendRequestsTableCompanion toCompanion({required bool isIncoming}) {
    return db.FriendRequestsTableCompanion(
      requestId: Value(requestId),
      userId: Value(user.id),
      friendTag: Value(user.friendTag),
      name: Value(user.name),
      avatarUrl: Value(user.avatarUrl),
      anonymousNumber: Value(user.anonymousNumber),
      isIncoming: Value(isIncoming),
    );
  }
}

extension FriendRequestEntityMapper on FriendRequestEntity {
  db.FriendRequestsTableCompanion toCompanion({bool? isIncoming}) {
    return db.FriendRequestsTableCompanion(
      requestId: Value(requestId),
      userId: Value(user.id),
      friendTag: Value(user.friendTag),
      name: Value(user.name),
      avatarUrl: Value(user.avatarUrl),
      anonymousNumber: Value(user.anonymousNumber),
      isIncoming: Value(isIncoming ?? this.isIncoming),
    );
  }
}

extension FriendDriftMapper on db.FriendsTableData {
  FriendEntity toDomain() {
    return FriendEntity(
      id: id,
      friendTag: friendTag,
      name: name,
      avatarUrl: avatarUrl,
      anonymousNumber: anonymousNumber,
    );
  }
}

extension FriendRequestDriftMapper on db.FriendRequestsTableData {
  FriendRequestEntity toDomain() {
    return FriendRequestEntity(
      requestId: requestId,
      isIncoming: isIncoming,
      user: FriendEntity(
        id: userId,
        friendTag: friendTag,
        name: name,
        avatarUrl: avatarUrl,
        anonymousNumber: anonymousNumber,
      ),
    );
  }
}
