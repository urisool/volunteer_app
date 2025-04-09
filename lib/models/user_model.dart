abstract class User {
  String id;
  String name;
  String bio;
  String profileImageUrl;
  String role; // 'volunteer' or 'organization'
  
  User({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.role,
  });
}