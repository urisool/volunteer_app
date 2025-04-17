// providers/opportunity_provider.dart
import 'package:flutter/material.dart';
import 'package:volunteer_app/models/opportunity_model.dart';
import 'package:volunteer_app/services/api_service.dart';

class OpportunityProvider with ChangeNotifier {
  List<Opportunity> _opportunities = [];

  List<Opportunity> get opportunities => _opportunities;

  get allSkills => null;

  Future<void> loadOpportunities() async {
    // جلب البيانات من API أو Local Storage
    _opportunities = (await ApiService().fetchOpportunities()).cast<Opportunity>();
    notifyListeners();
  
  }

  void applyFilters({required String location, required List<String> skills}) {}
}