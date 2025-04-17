// providers/organization_provider.dart
import 'package:flutter/foundation.dart';
import '../models/organization_model.dart';
import '../models/opportunity_model.dart';
import '../services/api_service.dart';

class OrganizationProvider with ChangeNotifier {
  Organization? _currentOrganization;
  List<Opportunity> _postedOpportunities = [];

  // Getters
  Organization? get currentOrganization => _currentOrganization;
  List<Opportunity> get postedOpportunities => _postedOpportunities;

  // جلب بيانات المنظمة
  Future<void> fetchOrganizationData(String orgId) async {
    try {
      _currentOrganization = await ApiService().getOrganizationById(orgId);
      _postedOpportunities = await ApiService().getOrgOpportunities(orgId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load organization data: $e');
    }
  }

  // نشر فرصة جديدة
  Future<void> postNewOpportunity(Opportunity opportunity) async {
    final newOpportunity = await ApiService().createOpportunity(
      orgId: _currentOrganization!.id,
      opportunity: opportunity,
    );
    _postedOpportunities.add(newOpportunity);
    notifyListeners();
  }

  // حذف فرصة
  Future<void> deleteOpportunity(String opportunityId) async {
    await ApiService().deleteOpportunity(opportunityId);
    _postedOpportunities.removeWhere((opp) => opp.id == opportunityId);
    notifyListeners();
  }
}