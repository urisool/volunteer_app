import 'user_model.dart';

class Organization extends User {
  final String field;
  final String phone;
  final String email;
  final String address;
  final List<String> currentProjects;
  final double rating;

  Organization({
    required super.id,
    required super.name,
    required super.bio,
    required super.profileImageUrl,
    required this.field,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentProjects,
    required this.rating,
  }) : super(
          role: 'organization',
        );

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
      field: json['field'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      currentProjects: List<String>.from(json['currentProjects']),
      rating: json['rating'].toDouble(),
    );
  }

  get description => null;

  get website => null;

  get contactEmail => null;

  get services => null;

  get logoUrl => null;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'field': field,
      'phone': phone,
      'email': email,
      'address': address,
      'currentProjects': currentProjects,
      'rating': rating,
    };
  }
}