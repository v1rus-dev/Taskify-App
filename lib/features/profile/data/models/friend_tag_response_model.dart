class FriendTagResponseModel {
  const FriendTagResponseModel({required this.friendTag});

  final String friendTag;

  factory FriendTagResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendTagResponseModel(
      friendTag: json['friend_tag'] as String,
    );
  }
}
