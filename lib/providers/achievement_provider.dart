// providers/achievement_provider.dart
import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';

class AchievementProvider with ChangeNotifier {
  List<Achievement> _allAchievements = [];
  List<Achievement> _earnedAchievements = [];

  // Getters
  List<Achievement> get allAchievements => _allAchievements;
  List<Achievement> get earnedAchievements => _earnedAchievements;

  // جلب جميع الإنجازات الممكنة
  Future<void> fetchAllAchievements() async {
    _allAchievements = await ApiService().getAllAchievements();
    notifyListeners();
  }

  // جلب الإنجازات المكتسبة
  Future<void> fetchEarnedAchievements(String userId) async {
    _earnedAchievements = await ApiService().getUserAchievements(userId);
    notifyListeners();
  }

  // منح إنجاز جديد
  Future<void> grantAchievement(String userId, Achievement achievement) async {
    await ApiService().grantAchievement(userId, achievement.id);
    _earnedAchievements.add(achievement);
    notifyListeners();
  }
}

class ApiService {
  getAllAchievements() {}
  
  grantAchievement(String userId, String id) {}
  
  getUserAchievements(String userId) {}
}