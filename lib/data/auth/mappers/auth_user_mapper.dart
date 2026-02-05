import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/auth/models/auth_user_entity.dart';

extension UsersTableDataMapper on UsersTableData {
  AuthUserEntity toDomain() {
    return AuthUserEntity(
      id: id,
      provider: provider,
      providerUserId: providerUserId,
      email: email,
      friendTag: friendTag,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension AuthUserCompanionMapper on AuthUserEntity {
  UsersTableCompanion toCompanion() {
    return UsersTableCompanion(
      id: Value(id),
      provider: Value(provider),
      providerUserId: Value(providerUserId),
      email: Value(email),
      name: Value(name),
      avatarUrl: Value(avatarUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
