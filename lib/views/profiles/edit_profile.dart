import 'package:flutter/material.dart';
import 'package:volunteer_app/models/organization_model.dart';
import 'package:volunteer_app/models/user_model.dart';
import 'package:volunteer_app/models/volunteer_model.dart';
import 'package:volunteer_app/services/profile_service.dart';
import 'package:volunteer_app/widgets/editable_field.dart';
import '../models/user_model.dart';
import '../models/volunteer_model.dart';
import '../models/organization_model.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';


class EditProfilePage extends StatefulWidget {
  final User user;
  final bool isOrganization;
  
  const EditProfilePage({
    Key? key,
    required this.user,
    required this.isOrganization,
  }) : super(key: key);
  
  get volunteer => null;
  
  set volunteer(Volunteer volunteer) {}
  
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  String? _errorMessage;
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late String _profileImageUrl;
  
  // Volunteer specific fields
  late TextEditingController _skillsController;
  late TextEditingController _experienceController;
  late TextEditingController _educationController;
  late TextEditingController _certificationsController;
  
  // Organization specific fields
  late TextEditingController _fieldController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _projectsController;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);
    _profileImageUrl = widget.user.profileImageUrl;
    
    if (!widget.isOrganization) {
      Volunteer volunteer = widget.user as Volunteer;
      _skillsController = TextEditingController(text: volunteer.skills.join(', '));
      _experienceController = TextEditingController(text: volunteer.experience);
      _educationController = TextEditingController(text: volunteer.education);
      _certificationsController = TextEditingController(text: volunteer.certifications.join('\n'));
    } else {
      Organization organization = widget.user as Organization;
      _fieldController = TextEditingController(text: organization.field);
      _phoneController = TextEditingController(text: organization.phone);
      _emailController = TextEditingController(text: organization.email);
      _addressController = TextEditingController(text: organization.address);
      _projectsController = TextEditingController(text: organization.currentProjects.join('\n'));
      _rating = organization.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _changeProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profileImageUrl),
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            EditableField(controller: _nameController, label: 'Name'),
            EditableField(controller: _bioController, label: 'Bio', maxLines: 3),
            
            if (!widget.isOrganization) ...[
              EditableField(controller: _skillsController, label: 'Skills (comma separated)'),
              EditableField(controller: _experienceController, label: 'Experience', maxLines: 3),
              EditableField(controller: _educationController, label: 'Education'),
              EditableField(controller: _certificationsController, label: 'Certifications (one per line)', maxLines: 3),
            ] else ...[
              EditableField(controller: _fieldController, label: 'Field'),
              EditableField(controller: _phoneController, label: 'Phone', keyboardType: TextInputType.phone),
              EditableField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
              EditableField(controller: _addressController, label: 'Address'),
              EditableField(controller: _projectsController, label: 'Current Projects (one per line)', maxLines: 3),
              SizedBox(height: 16),
              Text('Rating: ${_rating.toStringAsFixed(1)}'),
              Slider(
                value: _rating,
                min: 0,
                max: 5,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
            ],
            
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _changeProfileImage() async {
    // Implement image picker functionality
    // For now, we'll just simulate it
    final newImageUrl = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Profile Image'),
        content: Text('Enter new image URL:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'https://example.com/new_profile.jpg');
            },
            child: Text('Use Example'),
          ),
        ],
      ),
    );
    
    if (newImageUrl != null) {
      setState(() {
        _profileImageUrl = newImageUrl;
      });
    }
  }
  
  

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final volunteer = await _profileService.getVolunteerProfile(widget.user as String);
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
      // باقي الكود كما هو...
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
    ).then((updatedUser) async {
      if (updatedUser != null) {
        try {
          final updatedVolunteer = updatedUser as Volunteer;
          await _profileService.updateVolunteerProfile(updatedVolunteer);
          setState(() {
            widget.volunteer = updatedVolunteer;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _profileService.dispose();
    super.dispose();
  }
}
  
  void _saveChanges() {
    User updatedUser;
    
    if (!widget.isOrganization) {
      updatedUser = Volunteer(
        id: widget.user.id,
        name: _nameController.text,
        bio: _bioController.text,
        profileImageUrl: _profileImageUrl,
        skills: _skillsController.text.split(',').map((s) => s.trim()).toList(),
        experience: _experienceController.text,
        education: _educationController.text,
        certifications: _certificationsController.text.split('\n'),
      );
    } else {
      updatedUser = Organization(
        id: widget.user.id,
        name: _nameController.text,
        bio: _bioController.text,
        profileImageUrl: _profileImageUrl,
        field: _fieldController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
        currentProjects: _projectsController.text.split('\n'),
        rating: _rating,
      );
    }
    
    Navigator.pop(context, updatedUser);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    if (!widget.isOrganization) {
      _skillsController.dispose();
      _experienceController.dispose();
      _educationController.dispose();
      _certificationsController.dispose();
    } else {
      _fieldController.dispose();
      _phoneController.dispose();
      _emailController.dispose();
      _addressController.dispose();
      _projectsController.dispose();
    }
    super.dispose();
  }
}