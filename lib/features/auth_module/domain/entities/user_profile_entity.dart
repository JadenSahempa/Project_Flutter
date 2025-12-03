class UserProfileEntity {
  final String uid;
  final String email;
  final String? name;
  final String role;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    this.name,
    required this.role,
  });
}
