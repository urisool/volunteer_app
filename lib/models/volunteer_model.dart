import 'user_model.dart';

class Volunteer extends User {
  List<String> skills;
  String experience;
  List<String> certifications;
  String education;
  
  Volunteer({
    required super.id,
    required super.name,
    required super.bio,
    required super.profileImageUrl,
    required this.skills,
    required this.experience,
    required this.certifications,
    required this.education,
  }) : super(
    role: 'volunteer',
  );
}