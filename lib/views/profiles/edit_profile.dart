import 'package:flutter/material.dart';
import 'package:volunteer_app/models/organization_model.dart';
import 'package:volunteer_app/models/user_model.dart';
import 'package:volunteer_app/models/volunteer_model.dart';
import 'package:volunteer_app/widgets/editable_field.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  final bool isOrganization;

  const EditProfilePage({
    super.key,
    required this.user,
    required this.isOrganization,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late String _profileImageUrl;

  late TextEditingController _skillsController;
  late TextEditingController _experienceController;
  late TextEditingController _educationController;
  late TextEditingController _certificationsController;

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

    if (!widget.isOrganization && widget.user is Volunteer) {
      final volunteer = widget.user as Volunteer;
      _skillsController = TextEditingController(
        text: volunteer.skills.join(', '),
      );
      _experienceController = TextEditingController(text: volunteer.experience);
      _educationController = TextEditingController(text: volunteer.education);
      _certificationsController = TextEditingController(
        text: volunteer.certifications.join('\n'),
      );
    } else if (widget.user is Organization) {
      final organization = widget.user as Organization;
      _fieldController = TextEditingController(text: organization.field);
      _phoneController = TextEditingController(text: organization.phone);
      _emailController = TextEditingController(text: organization.email);
      _addressController = TextEditingController(text: organization.address);
      _projectsController = TextEditingController(
        text: organization.currentProjects.join('\n'),
      );
      _rating = organization.rating;
    }
  }

  void _saveChanges() {
    User updatedUser;

    if (!widget.isOrganization && widget.user is Volunteer) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
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
            EditableField(
              controller: _bioController,
              label: 'Bio',
              maxLines: 3,
            ),

            if (!widget.isOrganization) ...[
              EditableField(controller: _skillsController, label: 'Skills'),
              EditableField(
                controller: _experienceController,
                label: 'Experience',
                maxLines: 3,
              ),
              EditableField(
                controller: _educationController,
                label: 'Education',
              ),
              EditableField(
                controller: _certificationsController,
                label: 'Certifications',
                maxLines: 3,
              ),
            ] else ...[
              EditableField(controller: _fieldController, label: 'Field'),
              EditableField(controller: _phoneController, label: 'Phone'),
              EditableField(controller: _emailController, label: 'Email'),
              EditableField(controller: _addressController, label: 'Address'),
              EditableField(
                controller: _projectsController,
                label: 'Current Projects',
                maxLines: 3,
              ),
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
                ),
                ElevatedButton(onPressed: _saveChanges, child: Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changeProfileImage() async {
    final newImageUrl = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Change Profile Image'),
            content: Text('Enter new image URL:'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed:
                    () =>
                        Navigator.pop(context, 'https://example.com/image.jpg'),
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
}
