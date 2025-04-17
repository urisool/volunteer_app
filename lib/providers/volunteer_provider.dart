// providers/volunteer_provider.dart
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:volunteer_app/models/opportunity_model.dart';
import '../models/volunteer_model.dart';
import '../models/skill_model.dart';
import '../models/achievement_model.dart';
import '../services/api_service.dart';

class VolunteerProvider with ChangeNotifier {
  Volunteer? _currentVolunteer;
  List<Skill> _skills = [];
  List<Achievement> _achievements = [];

  // Getters
  Volunteer? get currentVolunteer => _currentVolunteer;
  List<Skill> get skills => _skills;
  List<Achievement> get achievements => _achievements;

  get upcomingEvents => null;

  // جلب بيانات المتطوع من الخادم
  Future<void> fetchVolunteerData(String volunteerId) async {
    try {
      _currentVolunteer = await ApiService().getVolunteerById(volunteerId);
      _skills = await ApiService().getVolunteerSkills(volunteerId);
      _achievements = await ApiService().getVolunteerAchievements(volunteerId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load volunteer data: $e');
    }
  }

  // إضافة مهارة جديدة
  Future<void> addSkill(Skill newSkill) async {
    await ApiService().addSkillToVolunteer(_currentVolunteer!.id, newSkill);
    _skills.add(newSkill);
    notifyListeners();
  }

  // تحديث مستوى المهارة
  Future<void> updateSkillProficiency(String skillId, int newLevel) async {
    await ApiService().updateSkillProficiency(
      _currentVolunteer!.id,
      skillId,
      newLevel,
    );
    final index = _skills.indexWhere((skill) => skill.id == skillId);
    _skills[index] = _skills[index].copyWith(proficiencyLevel: newLevel);
    notifyListeners();
  }

  Widget joinOpportunity(Opportunity opportunity) {
  // منطق تنفيذ الانضمام
  return const Text("joined the opportunity "); // كمثال
}

Widget cancelEvent(event) {
  // منطق تنفيذ الإلغاء
  return const Text("the event was canceled"); // كمثال
}
}