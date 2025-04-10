import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/volunteer_model.dart';
import '../models/organization_model.dart';

class ProfileService {
  static const String _baseUrl = 'https://your-api-url.com/api';
  final http.Client _client;

  ProfileService({http.Client? client}) : _client = client ?? http.Client();

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
          profileImageUrl:
              data['profileImageUrl'] ?? 'https://via.placeholder.com/150',
          skills: List<String>.from(data['skills'] ?? []),
          experience: data['experience'] ?? '',
          certifications: List<String>.from(data['certifications'] ?? []),
          education: data['education'] ?? '',
        );
      } else {
        throw Exception(
          'Failed to load volunteer profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching volunteer profile: $e');
    }
  }

  // جلب بيانات المنظمة
  Future<Organization> getOrganizationProfile(String orgId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/organizations/$orgId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Organization(
          id: data['id'],
          name: data['name'],
          bio: data['bio'] ?? '',
          profileImageUrl:
              data['profileImageUrl'] ?? 'https://via.placeholder.com/150',
          field: data['field'] ?? '',
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
          address: data['address'] ?? '',
          currentProjects: List<String>.from(data['currentProjects'] ?? []),
          rating: (data['rating'] ?? 0).toDouble(),
        );
      } else {
        throw Exception(
          'Failed to load organization profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching organization profile: $e');
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
        throw Exception(
          'Failed to update volunteer profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating volunteer profile: $e');
    }
  }

  // تحديث بيانات المنظمة
  Future<Organization> updateOrganizationProfile(
    Organization organization,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl/organizations/${organization.id}'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': organization.name,
          'bio': organization.bio,
          'profileImageUrl': organization.profileImageUrl,
          'field': organization.field,
          'phone': organization.phone,
          'email': organization.email,
          'address': organization.address,
          'currentProjects': organization.currentProjects,
          'rating': organization.rating,
        }),
      );

      if (response.statusCode == 200) {
        return organization;
      } else {
        throw Exception(
          'Failed to update organization profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating organization profile: $e');
    }
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
      request.fields['userType'] =
          isOrganization ? 'organization' : 'volunteer';
      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        return data['imageUrl'];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading profile image: $e');
    }
  }

  // Headers
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
}
