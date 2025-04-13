import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/organization_model.dart';
import '../../providers/auth_provider.dart';
import 'edit_profile.dart';

class OrganizationProfilePage extends StatefulWidget {
  const OrganizationProfilePage({super.key, required Organization organization});

  @override
  // ignore: library_private_types_in_public_api
  _OrganizationProfilePageState createState() => _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends State<OrganizationProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final organization = authProvider.currentUser as Organization;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
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
            _buildProfileHeader(organization),
            const SizedBox(height: 20),
            _buildProfileSection('Bio', organization.bio),
            _buildProfileSection('Field', organization.field),
            _buildProfileSection('Contact Info', 
              'Email: ${organization.email}\nPhone: ${organization.phone}\nAddress: ${organization.address}'),
            _buildProfileSection('Current Projects', organization.currentProjects.join('\n')),
            _buildProfileSection('Rating', '${organization.rating}/5'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Organization organization) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(organization.profileImageUrl),
        ),
        const SizedBox(height: 10),
        Text(
          organization.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          'Organization',
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
          isOrganization: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}