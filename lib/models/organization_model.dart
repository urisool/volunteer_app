import 'user_model.dart';

class Organization extends User {
  String field;
  String phone;
  String email;
  String address;
  List<String> currentProjects;
  double rating;
  
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
}