import 'package:flutter/material.dart';
import 'package:volunteer_app/models/organization_model.dart';
import 'package:volunteer_app/services/profile_service.dart';
import 'package:volunteer_app/views/profiles/edit_profile.dart';
import 'package:volunteer_app/widgets/profile_header.dart';
import 'package:volunteer_app/widgets/profile_section.dart';

// ignore: must_be_immutable
class OrganizationProfilePage extends StatefulWidget {
  Organization organization;
  OrganizationProfilePage({super.key, required this.organization});

  @override
  // ignore: library_private_types_in_public_api
  _OrganizationProfilePageState createState() => _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends State<OrganizationProfilePage> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final org = await _profileService.getOrganizationProfile(widget.organization.id);
      setState(() {
        widget.organization = org;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              imageUrl: widget.organization.logoUrl,
              name: widget.organization.name,
              role: 'Organization',
            ),
            ProfileSection(
              title: 'Description',
              content: widget.organization.description,
            ),
            ProfileSection(
              title: 'Services',
              content: widget.organization.services.join(', '),
            ),
            ProfileSection(
              title: 'Website',
              content: widget.organization.website,
            ),
            ProfileSection(
              title: 'Contact',
              content: widget.organization.contactEmail,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          user: widget.organization,
          isOrganization: true,
        ),
      ),
    ).then((updatedOrg) {
      if (updatedOrg != null) {
        setState(() {
          widget.organization = updatedOrg as Organization;
        });
      }
    });
  }

  @override
  void dispose() {
    _profileService.dispose();
    super.dispose();
  }
}
