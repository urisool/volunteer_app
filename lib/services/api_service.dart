import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volunteer_app/models/skill_model.dart';
import '../models/user_model.dart';
import '../models/opportunity_model.dart';

class ApiService {
  final String _baseUrl = 'https://your-api-domain.com/v1';

  get client => null;

  Future<User> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Opportunity>> fetchOpportunities() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/opportunities'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Opportunity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load opportunities');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  getOrganizationById(String orgId) {}

  deleteOpportunity(String opportunityId) {}

  createOpportunity({required String orgId, required Opportunity opportunity}) {}

  getOrgOpportunities(String orgId) {}

  getVolunteerSkills(String volunteerId) {}

  updateSkillProficiency(String id, String skillId, int newLevel) {}

  getVolunteerById(String volunteerId) {}

  getVolunteerAchievements(String volunteerId) {}

  addSkillToVolunteer(String id, Skill newSkill) {}
}