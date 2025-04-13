import 'package:flutter/material.dart';
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
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(volunteer.profileImageUrl),
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
        ),
      ),
    ).then((_) => setState(() {}));
  }
}