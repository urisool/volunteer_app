import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/volunteer_model.dart';
import '../../providers/auth_provider.dart';
import 'edit_profile.dart';

class VolunteerProfilePage extends StatefulWidget {
  const VolunteerProfilePage({super.key, required Volunteer volunteer});

  @override
  // ignore: library_private_types_in_public_api
  _VolunteerProfilePageState createState() => _VolunteerProfilePageState();
}

class _VolunteerProfilePageState extends State<VolunteerProfilePage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final path = picked.path;

      setState(() {
        _imageFile = File(path);
      });

      // ignore: use_build_context_synchronously
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final volunteer = authProvider.currentUser as Volunteer;

      // حفظ مسار الصورة محليًا
      volunteer.profileImageUrl = path;
      authProvider.updateUser(volunteer); // حذف await لتفادي الخطأ

      // إظهار رسالة نجاح
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث الصورة بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final volunteer = authProvider.currentUser as Volunteer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(volunteer),
            const SizedBox(height: 20),
            _buildProfileSection('Bio', volunteer.bio),
            _buildProfileSection('Skills', volunteer.skills.join(', ')),
            _buildProfileSection('Experience', volunteer.experience),
            _buildProfileSection('Education', volunteer.education),
            _buildProfileSection('Certifications', volunteer.certifications.join('\n')),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Volunteer volunteer) {
    ImageProvider imageProvider;

    if (_imageFile != null) {
      imageProvider = FileImage(_imageFile!);
    } else if (volunteer.profileImageUrl.isNotEmpty &&
        File(volunteer.profileImageUrl).existsSync()) {
      imageProvider = FileImage(File(volunteer.profileImageUrl));
    } else {
      imageProvider = const AssetImage('assets/default_avatar.png');
    }

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: imageProvider,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          volunteer.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          'Volunteer',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          user: Provider.of<AuthProvider>(context, listen: false).currentUser!,
          isOrganization: false,
          onSave: (updatedUser) async {
            setState(() {});
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
