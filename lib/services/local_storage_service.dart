import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/volunteer_model.dart';
import '../models/organization_model.dart';

class ProfileService {
  static const String _baseUrl = 'https://your-api-url.com/api';
  final http.Client _client;
  final ImagePicker _picker = ImagePicker();

  static SharedPreferences? _preferences;

  ProfileService({http.Client? client}) : _client = client ?? http.Client();

  // ------------------------- LocalStorage Methods -------------------------

  static Future<void> initLocalStorage() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _preferences?.setString('user_id', userData['id']);
    await _preferences?.setString('user_email', userData['email']);
    await _preferences?.setString('user_type', userData['userType']);
    await _preferences?.setString('auth_token', userData['token']);
  }

  static String? getAuthToken() {
    return _preferences?.getString('auth_token');
  }

  static String? getUserType() {
    return _preferences?.getString('user_type');
  }

  static Future<void> clearAllData() async {
    await _preferences?.clear();
  }

  static Future<void> saveAppSettings({
    required bool darkMode,
    required String language,
  }) async {
    await _preferences?.setBool('dark_mode', darkMode);
    await _preferences?.setString('app_language', language);
  }

  // ------------------------- Profile API Methods -------------------------

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) return File(image.path);
    return null;
  }

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
        return data['imageUrl'];
      } else {
        throw Exception('فشل رفع الصورة: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ في رفع الصورة: $e');
    }
  }

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
          education: data['education'] ?? '', upcomingEvents: [], completedEvents: [], totalHours: 0, badges: [],
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
      'Authorization': 'Bearer ${getAuthToken() ?? ''}',
    };
  }

  void dispose() {
    _client.close();
  }

  updateOrganizationProfile(Organization updatedUser) {}
  uploadImage(File file, id) {}
}
