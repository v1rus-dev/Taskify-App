enum SpaceRole {
  owner('owner'),
  admin('admin'),
  editor('editor'),
  viewer('viewer');

  const SpaceRole(this.value);

  final String value;

  static SpaceRole fromValue(String? value) {
    return SpaceRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => SpaceRole.viewer,
    );
  }
}
