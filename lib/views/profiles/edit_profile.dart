import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../models/volunteer_model.dart';
import '../../models/organization_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/profile_service.dart';

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

  final ProfileService _profileService = ProfileService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);
    _profileImageUrl = widget.user.profileImageUrl;

    if (!widget.isOrganization) {
      final volunteer = widget.user as Volunteer;
      _skillsController = TextEditingController(text: volunteer.skills.join(', '));
      _experienceController = TextEditingController(text: volunteer.experience);
      _educationController = TextEditingController(text: volunteer.education);
      _certificationsController = TextEditingController(text: volunteer.certifications.join('\n'));
    } else {
      final organization = widget.user as Organization;
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
        title: const Text('Edit Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileImageSection(),
                  const SizedBox(height: 20),
                  _buildCommonFields(),
                  if (!widget.isOrganization) _buildVolunteerFields(),
                  if (widget.isOrganization) _buildOrganizationFields(),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileImageSection() {
    return GestureDetector(
      onTap: _changeProfileImage,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_profileImageUrl),
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text('Change Profile Picture'),
        ],
      ),
    );
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
        const SizedBox(height: 16),
        TextField(
          controller: _skillsController,
          decoration: const InputDecoration(
            labelText: 'Skills (comma separated)',
          ),
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
          decoration: const InputDecoration(
            labelText: 'Certifications (one per line)',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildOrganizationFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: _fieldController,
          decoration: const InputDecoration(labelText: 'Field/Industry'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Phone Number'),
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
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _projectsController,
          decoration: const InputDecoration(
            labelText: 'Current Projects (one per line)',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Text('Rating: ${_rating.toStringAsFixed(1)}'),
        Slider(
          value: _rating,
          min: 0,
          max: 5,
          divisions: 10,
          onChanged: (value) => setState(() => _rating = value),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _saveChanges(context),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _changeProfileImage() async {
    // في التطبيق الحقيقي، استخدم حزمة مثل image_picker
    final newImageUrl = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Profile Image'),
        content: const Text('Enter new image URL:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'https://example.com/new_profile.jpg'),
            child: const Text('Use Example'),
          ),
        ],
      ),
    );

    if (newImageUrl != null) {
      setState(() => _profileImageUrl = newImageUrl);
    }
  }

  Future<void> _saveChanges(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
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

      await authProvider.updateProfile(updatedUser);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
    _profileService.dispose();
    super.dispose();
  }
}