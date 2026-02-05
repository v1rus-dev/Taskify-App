import 'package:taskify/data/auth/models/auth_user_response_model.dart';
import 'package:taskify/domain/auth/models/auth_user_entity.dart';

extension AuthUserResponseModelMapper on AuthUserResponseModel {
  AuthUserEntity toEntity() {
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


extension AuthUserMapper on AuthUserEntity {
  AuthUserResponseModel toModel() {
    return AuthUserResponseModel(
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
