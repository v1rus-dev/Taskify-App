import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart' as db;
import 'package:taskify/data/friends/models/friend_request_item_response_model.dart';
import 'package:taskify/data/friends/models/friend_response_model.dart';
import 'package:taskify/domain/friends/models/friend_entity.dart';
import 'package:taskify/domain/friends/models/friend_request_entity.dart';
import 'package:taskify/domain/friends/models/friend_request_user_entity.dart';

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

extension FriendRequestItemResponseModelMapper
    on FriendRequestItemResponseModel {
  db.IncomingFriendRequestsTableCompanion toIncomingCompanion() {
    return db.IncomingFriendRequestsTableCompanion(
      requestId: Value(requestId),
      userId: Value(user.id),
      userName: Value(user.name),
      userImageUrl: Value(user.imageUrl),
      userDisplayName: Value(user.displayName),
    );
  }

  db.OutgoingFriendRequestsTableCompanion toOutgoingCompanion() {
    return db.OutgoingFriendRequestsTableCompanion(
      requestId: Value(requestId),
      userId: Value(user.id),
      userName: Value(user.name),
      userImageUrl: Value(user.imageUrl),
      userDisplayName: Value(user.displayName),
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

extension IncomingRequestDriftMapper on db.IncomingFriendRequestsTableData {
  FriendRequestEntity toDomain() {
    return FriendRequestEntity(
      requestId: requestId,
      user: FriendRequestUserEntity(
        id: userId,
        displayName: userDisplayName,
        name: userName,
        imageUrl: userImageUrl,
      ),
    );
  }
}

extension OutgoingRequestDriftMapper on db.OutgoingFriendRequestsTableData {
  FriendRequestEntity toDomain() {
    return FriendRequestEntity(
      requestId: requestId,
      user: FriendRequestUserEntity(
        id: userId,
        displayName: userDisplayName,
        name: userName,
        imageUrl: userImageUrl,
      ),
    );
  }
}
