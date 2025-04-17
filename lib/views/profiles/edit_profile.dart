import 'dart:io';

import 'package:flutter/material.dart';
import 'package:volunteer_app/models/organization_model.dart';
import 'package:volunteer_app/models/user_model.dart';
import 'package:volunteer_app/models/volunteer_model.dart';
import 'package:volunteer_app/services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  final bool isOrganization;
  final Future<Null> Function(dynamic updatedUser) onSave;

  const EditProfilePage({
    super.key,
    required this.user,
    required this.isOrganization,
    required this.onSave, // تمرير الدالة هنا
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final ProfileService _profileService;
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _skillsController;
  late final TextEditingController _experienceController;
  late final TextEditingController _educationController;
  late final TextEditingController _certificationsController;
  late final TextEditingController _fieldController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _projectsController;

  double _rating = 0.0;
  String _profileImageUrl = '';
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService();
    _initializeControllers();
    _initializeFields();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _skillsController = TextEditingController();
    _experienceController = TextEditingController();
    _educationController = TextEditingController();
    _certificationsController = TextEditingController();
    _fieldController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _projectsController = TextEditingController();
  }

  void _initializeFields() {
    _nameController.text = widget.user.name;
    _bioController.text = widget.user.bio;
    _profileImageUrl = widget.user.profileImageUrl;

    if (widget.user is Volunteer) {
      final volunteer = widget.user as Volunteer;
      _skillsController.text = volunteer.skills.join(', ');
      _experienceController.text = volunteer.experience;
      _educationController.text = volunteer.education;
      _certificationsController.text = volunteer.certifications.join('\n');
    } else if (widget.user is Organization) {
      final organization = widget.user as Organization;
      _fieldController.text = organization.field;
      _phoneController.text = organization.phone;
      _emailController.text = organization.email;
      _addressController.text = organization.address;
      _projectsController.text = organization.currentProjects.join('\n');
      _rating = organization.rating;
    }
  }

  Future<void> _changeProfileImage() async {
    try {
      final pickedFile = await _profileService.pickImage();
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _saveChanges() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      User updatedUser = _createUpdatedUser();
      widget.onSave(updatedUser); // استدعاء الدالة onSave هنا
      Navigator.pop(context, updatedUser); // إرجاع البيانات المعدلة
    } catch (e) {
      _showErrorSnackBar('Error saving changes: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  User _createUpdatedUser() {
    final newImageUrl = _imageFile != null 
        ? 'local://${_imageFile!.path}' 
        : _profileImageUrl;

    return widget.isOrganization
        ? Organization(
            id: widget.user.id,
            name: _nameController.text,
            bio: _bioController.text,
            profileImageUrl: newImageUrl,
            field: _fieldController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            address: _addressController.text,
            currentProjects: _projectsController.text.split('\n'),
            rating: _rating,
          )
        : Volunteer(
            id: widget.user.id,
            name: _nameController.text,
            bio: _bioController.text,
            profileImageUrl: newImageUrl,
            skills: _skillsController.text.split(',').map((s) => s.trim()).toList(),
            experience: _experienceController.text,
            education: _educationController.text,
            certifications: _certificationsController.text.split('\n'), upcomingEvents: [], completedEvents: [], totalHours: 0, badges: [],
          );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildProfileImageSection() {
    return GestureDetector(
      onTap: _changeProfileImage,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _getProfileImage(),
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Change Profile Picture',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (_imageFile != null) return FileImage(_imageFile!);
    if (_profileImageUrl.startsWith('http')) return NetworkImage(_profileImageUrl);
    return const AssetImage('assets/default_profile.png');
  }

  Widget _buildCommonFields() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _bioController,
          decoration: const InputDecoration(labelText: 'Bio'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildVolunteerFields() {
    return Column(
      children: [
        TextField(
          controller: _skillsController,
          decoration: const InputDecoration(labelText: 'Skills (comma separated)'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _experienceController,
          decoration: const InputDecoration(labelText: 'Experience'),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _educationController,
          decoration: const InputDecoration(labelText: 'Education'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _certificationsController,
          decoration: const InputDecoration(labelText: 'Certifications (one per line)'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildOrganizationFields() {
    return Column(
      children: [
        TextField(
          controller: _fieldController,
          decoration: const InputDecoration(labelText: 'Field'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Phone'),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Address'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _projectsController,
          decoration: const InputDecoration(labelText: 'Current Projects (one per line)'),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Rating:'),
            Expanded(
              child: Slider(
                value: _rating,
                min: 0,
                max: 5,
                divisions: 10,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) => setState(() => _rating = value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileImageSection(),
                  const SizedBox(height: 24),
                  _buildCommonFields(),
                  const SizedBox(height: 16),
                  if (!widget.isOrganization) 
                    _buildVolunteerFields() 
                  else 
                    _buildOrganizationFields(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    _certificationsController.dispose();
    _fieldController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _projectsController.dispose();
    super.dispose();
  }
}
