abstract class User {
  final String id;
  final String name;
  final String bio;
  final String profileImageUrl;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.role,
  });

  Map<String, dynamic> toJson();
}