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
    required this.education, required List upcomingEvents, required List completedEvents, required int totalHours, required List badges,
  }) : super(
          role: 'volunteer',
        );

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      experience: json['experience'] ?? '',
      certifications: List<String>.from(json['certifications'] ?? []),
      education: json['education'] ?? '', upcomingEvents: [], completedEvents: [], totalHours: 0, badges: [],
    );
  }

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

  Volunteer copyWith({
    String? id,
    String? name,
    String? bio,
    String? profileImageUrl,
    List<String>? skills,
    String? experience,
    List<String>? certifications,
    String? education,
  }) {
    return Volunteer(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      certifications: certifications ?? this.certifications,
      education: education ?? this.education, upcomingEvents: [], completedEvents: [], totalHours: 0, badges: [],
    );
  }
}
