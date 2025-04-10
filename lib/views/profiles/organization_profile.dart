// ignore_for_file: unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:volunteer_app/models/organization_model.dart';
import 'package:volunteer_app/services/profile_service.dart';
import 'package:volunteer_app/views/profiles/edit_profile.dart';
import 'package:volunteer_app/widgets/profile_header.dart';
import 'package:volunteer_app/widgets/profile_section.dart';

class OrganizationProfilePage extends StatefulWidget {
  Organization organization; // جعل الحقل final
  // إزالة const من constructor
  OrganizationProfilePage({super.key, required this.organization});

  @override
  OrganizationProfilePageState createState() => OrganizationProfilePageState();
}

class OrganizationProfilePageState extends State<OrganizationProfilePage> {
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
      final organization = await _profileService.getVolunteerProfile(
        widget.organization.id,
      );
      setState(() {
        widget.organization = Organization as Organization;
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
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              imageUrl: widget.organization.profileImageUrl,
              name: widget.organization.name,
              role: 'Organization',
            ),
            ProfileSection(title: 'Bio', content: widget.organization.bio),
            ProfileSection(
              title: 'Location',
              content: widget.organization.location.join(', '),
            ),
            ProfileSection(
              title: 'Facebook Page',
              content: widget.organization.facebook,
            ),
            ProfileSection(
              title: 'Instagram Page',
              content: widget.organization.instagram,
            ),
            ProfileSection(title: 'Email', content: widget.organization.email),
          ],
        ),
      ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          var editProfilePage = EditProfilePage(
            user: widget.organization, // FIXED LINE
            isOrganization: true,
            bool:
                null, // you might want to rename this `bool` param; it's a keyword!
          );
          return editProfilePage;
        },
      ),
    ).then((updatedUser) {
      if (updatedUser != null) {
        setState(() {
          widget.organization = updatedUser as Organization;
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
