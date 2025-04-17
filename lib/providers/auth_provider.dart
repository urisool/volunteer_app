import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../models/volunteer_model.dart';
import '../models/organization_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final ApiService _apiService;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService, this._apiService);

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // تسجيل الدخول
  Future<bool> login(String email, String password, {bool isOrganization = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      _currentUser = user;
      await _saveUserData(user);
      _error = null;
      return true;
    } catch (e) {
      _error = 'فشل تسجيل الدخول: $e';
      throw Exception(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    await _clearUserData();
    notifyListeners();
  }

  // التحقق من حالة المصادقة
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      try {
        _currentUser = await _apiService.getCurrentUser();
      } catch (e) {
        await _clearUserData();
      }
    }
    notifyListeners();
  }

  // حفظ بيانات المستخدم محلياً
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', user.token!);
    await prefs.setString('userId', user.id);
  }

  // مسح البيانات المحلية
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userId');
  }

  // التسجيل
  Future<void> register(Map<String, dynamic> data, bool isOrganization) async {
    try {
      _isLoading = true;
      notifyListeners();

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
          upcomingEvents: [],
          completedEvents: [],
          totalHours: 0,
          badges: [],
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

  // تحديث الملف الشخصي
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

  void updateUser(Volunteer volunteer) {
    if (_currentUser is Volunteer) {
      _currentUser = volunteer;
      notifyListeners();
    }
  }
}
