import 'package:volunteer_app/models/user_model.dart';

class Organization extends User {
  String field;
  String phone;
  String email;
  String address;
  List<String> currentProjects;
  double rating;

  @override
  // ignore: overridden_fields
  String profileImageUrl;

  Organization({
    required super.id,
    required super.name,
    required super.bio,
    required this.field,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentProjects,
    required this.rating,
    this.profileImageUrl = '', // إذا لم يتم توفيره، سيكون فارغًا
  }) : super(
          profileImageUrl: profileImageUrl, // تمريرها للكلاس الأب
          role: 'organization', // إذا كان لديك تعديل آخر في الكلاس الأب
        );

  String get logoUrl => profileImageUrl;

  String get description => bio;

  List<String> get services => currentProjects;

  String get website => email;

  String get contactEmail => email;
}
