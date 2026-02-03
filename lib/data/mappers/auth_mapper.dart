import 'package:taskify/data/auth/models/auth_user_model.dart';
import 'package:taskify/domain/auth/models/auth_user.dart';

extension AuthUserModelMapper on AuthUserModel {
  AuthUser toEntity() {
    return AuthUser(
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


extension AuthUserMapper on AuthUser {
  AuthUserModel toModel() {
    return AuthUserModel(
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