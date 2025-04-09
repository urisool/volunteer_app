import 'package:flutter/material.dart';
import '../models/volunteer_model.dart';

class VolunteerProfilePage extends StatefulWidget {
  final Volunteer volunteer;
  
  const VolunteerProfilePage({Key? key, required this.volunteer}) : super(key: key);
  
  @override
  _VolunteerProfilePageState createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Profile'),
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
              imageUrl: widget.volunteer.profileImageUrl,
              name: widget.volunteer.name,
              role: 'Volunteer',
            ),
            ProfileSection(
              title: 'Bio',
              content: widget.volunteer.bio,
            ),
            ProfileSection(
              title: 'Skills',
              content: widget.volunteer.skills.join(', '),
            ),
            ProfileSection(
              title: 'Experience',
              content: widget.volunteer.experience,
            ),
            ProfileSection(
              title: 'Education',
              content: widget.volunteer.education,
            ),
            ProfileSection(
              title: 'Certifications',
              content: widget.volunteer.certifications.join('\n'),
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
          user: widget.volunteer,
          isOrganization: false,
        ),
      ),
    ).then((updatedUser) {
      if (updatedUser != null) {
        setState(() {
          widget.volunteer = updatedUser as Volunteer;
        });
      }
    });
  }
}