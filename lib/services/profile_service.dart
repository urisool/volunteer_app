import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/volunteer_model.dart';
import '../models/organization_model.dart';

class ProfileService {
  static const String _baseUrl = 'https://your-api-url.com/api';
  final http.Client _client;
  final ImagePicker _picker = ImagePicker();

  ProfileService({http.Client? client}) : _client = client ?? http.Client();

  // اختيار صورة من المعرض
  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) return File(image.path);
    return null;
  }

  // رفع صورة الملف الشخصي
  Future<String> uploadProfileImage(
    String userId,
    String filePath,
    bool isOrganization,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload-profile-image'),
      );

      request.headers.addAll(_getHeaders());
      request.fields['userId'] = userId;
      request.fields['userType'] = isOrganization ? 'organization' : 'volunteer';
      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        return data['imageUrl']; // تأكد أن السيرفر يرجع imageUrl
      } else {
        throw Exception('فشل رفع الصورة: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ في رفع الصورة: $e');
    }
  }

  // تحديث بيانات المتطوع
  Future<Volunteer> updateVolunteerProfile(Volunteer volunteer) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/volunteers/${volunteer.id}'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': volunteer.name,
          'bio': volunteer.bio,
          'profileImageUrl': volunteer.profileImageUrl,
          'skills': volunteer.skills,
          'experience': volunteer.experience,
          'certifications': volunteer.certifications,
          'education': volunteer.education,
        }),
      );

      if (response.statusCode == 200) {
        return volunteer;
      } else {
        throw Exception('فشل تحديث الملف الشخصي: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ في تحديث الملف الشخصي: $e');
    }
  }

  // جلب بيانات المتطوع
  Future<Volunteer> getVolunteerProfile(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/volunteers/$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Volunteer(
          id: data['id'],
          name: data['name'],
          bio: data['bio'] ?? '',
          profileImageUrl: data['profileImageUrl'] ?? 'https://via.placeholder.com/150',
          skills: List<String>.from(data['skills'] ?? []),
          experience: data['experience'] ?? '',
          certifications: List<String>.from(data['certifications'] ?? []),
          education: data['education'] ?? '',
        );
      } else {
        throw Exception('فشل تحميل الملف الشخصي: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ في تحميل الملف الشخصي: $e');
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer your_token_if_needed',
    };
  }

  void dispose() {
    _client.close();
  }

  updateOrganizationProfile(Organization updatedUser) {}

  uploadImage(File file, id) {}
}
