import 'package:flutter/material.dart';
import 'package:volunteer_app/models/volunteer_model.dart';
import 'package:volunteer_app/services/profile_service.dart';
import 'package:volunteer_app/views/profiles/edit_profile.dart';
import 'package:volunteer_app/widgets/profile_header.dart';
import 'package:volunteer_app/widgets/profile_section.dart';

class VolunteerProfilePage extends StatefulWidget {
  Volunteer volunteer; // جعل الحقل final
  VolunteerProfilePage({Key? key, required this.volunteer}) : super(key: key); // إزالة const

  @override
  _VolunteerProfilePageState createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
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
      final volunteer = await _profileService.getVolunteerProfile(widget.volunteer.id); // التأكد من أنه id الصحيح
      setState(() {
        widget.volunteer = volunteer;
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

  @override
  void dispose() {
    _profileService.dispose();
    super.dispose();
  }
}
