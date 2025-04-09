import 'user_model.dart';

class Organization extends User {
  String field;
  String phone;
  String email;
  String address;
  List<String> currentProjects;
  double rating;
  
  Organization({
    required String id,
    required String name,
    required String bio,
    required String profileImageUrl,
    required this.field,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentProjects,
    required this.rating,
  }) : super(
    id: id,
    name: name,
    bio: bio,
    profileImageUrl: profileImageUrl,
    role: 'organization',
  );
}