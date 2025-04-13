import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/volunteer_model.dart';
import '../models/organization_model.dart';
import '../services/local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(
    String email,
    String password, {
    required bool isOrganization,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // محاكاة اتصال بالخادم
      await Future.delayed(const Duration(seconds: 1));

      // في التطبيق الحقيقي، سيتم استدعاء API هنا
      if (isOrganization) {
        _currentUser = Organization(
          id: 'org_${email.hashCode}',
          name: 'Charity Organization',
          bio: 'Helping people since 2000',
          profileImageUrl: 'https://example.com/org.jpg',
          field: 'Education',
          phone: '+123456789',
          email: email,
          address: '123 Main St, City',
          currentProjects: ['School Building', 'Food Drive'],
          rating: 4.5,
        );
      } else {
        _currentUser = Volunteer(
          id: 'vol_${email.hashCode}',
          name: 'Volunteer User',
          bio: 'I love volunteering!',
          profileImageUrl: 'https://example.com/volunteer.jpg',
          skills: ['Teaching', 'First Aid'],
          experience: '5 years of volunteering',
          certifications: ['First Aid Certified'],
          education: 'Bachelor in Social Work',
        );
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(Map<String, dynamic> data, bool isOrganization) async {
    try {
      _isLoading = true;
      notifyListeners();

      // محاكاة اتصال بالخادم
      await Future.delayed(const Duration(seconds: 1));

      if (isOrganization) {
        _currentUser = Organization(
          id: 'org_${data['email'].hashCode}',
          name: data['name'],
          bio: data['bio'],
          profileImageUrl: 'https://example.com/new_org.jpg',
          field: data['field'],
          phone: data['phone'],
          email: data['email'],
          address: data['address'],
          currentProjects: [],
          rating: 0,
        );
      } else {
        _currentUser = Volunteer(
          id: 'vol_${data['email'].hashCode}',
          name: data['name'],
          bio: data['bio'],
          profileImageUrl: 'https://example.com/new_volunteer.jpg',
          skills: [],
          experience: '',
          certifications: [],
          education: '',
        );
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(User updatedUser) async {
    try {
      _isLoading = true;
      notifyListeners();

      final profileService = ProfileService();

      if (updatedUser is Volunteer) {
        await profileService.updateVolunteerProfile(updatedUser);
      } else if (updatedUser is Organization) {
        await profileService.updateOrganizationProfile(updatedUser);
      }

      _currentUser = updatedUser;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
