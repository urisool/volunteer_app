import 'package:flutter/material.dart';
import 'package:volunteer_app/models/organization_model.dart';
import 'package:volunteer_app/views/profiles/edit_profile.dart';
import 'package:volunteer_app/widgets/profile_header.dart';
import 'package:volunteer_app/widgets/profile_section.dart';
import '../models/organization_model.dart';

class OrganizationProfilePage extends StatefulWidget {
  Organization organization;
  
  const OrganizationProfilePage({super.key, required this.organization});
  
  @override
  _OrganizationProfilePageState createState() => _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends State<OrganizationProfilePage> {
  @override
  Widget build(BuildContext context) {
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
            ProfileSection(
              title: 'Bio',
              content: widget.organization.bio,
            ),
            ProfileSection(
              title: 'Field',
              content: widget.organization.field,
            ),
            ProfileSection(
              title: 'Contact Information',
              content: 'Email: ${widget.organization.email}\n'
                  'Phone: ${widget.organization.phone}\n'
                  'Address: ${widget.organization.address}',
            ),
            ProfileSection(
              title: 'Current Projects',
              content: widget.organization.currentProjects.join('\n'),
            ),
            ProfileSection(
              title: 'Rating',
              content: '${widget.organization.rating}/5',
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
    ).then((updatedUser) {
      if (updatedUser != null) {
        setState(() {
          widget.organization = updatedUser as Organization;
        });
      }
    });
  }
}