import 'user_model.dart';

class Volunteer extends User {
  final List<String> skills;
  final String experience;
  final List<String> certifications;
  final String education;

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

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
      skills: List<String>.from(json['skills']),
      experience: json['experience'],
      certifications: List<String>.from(json['certifications']),
      education: json['education'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'skills': skills,
      'experience': experience,
      'certifications': certifications,
      'education': education,
    };
  }
}