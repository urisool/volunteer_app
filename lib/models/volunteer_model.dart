import 'user_model.dart';

class Volunteer extends User {
  List<String> skills;
  String experience;
  List<String> certifications;
  String education;
  
  Volunteer({
    required String id,
    required String name,
    required String bio,
    required String profileImageUrl,
    required this.skills,
    required this.experience,
    required this.certifications,
    required this.education,
  }) : super(
    id: id,
    name: name,
    bio: bio,
    profileImageUrl: profileImageUrl,
    role: 'volunteer',
  );
}