import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'How would you like to use the app?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              _buildRoleCard(
                context,
                icon: Icons.people,
                title: 'Volunteer',
                description: 'Find volunteering opportunities',
                onTap: () => Navigator.pushNamed(context, '/volunteer/login'),
              ),
              const SizedBox(height: 20),
              _buildRoleCard(
                context,
                icon: Icons.business,
                title: 'Organization',
                description: 'Post volunteering opportunities',
                onTap: () => Navigator.pushNamed(context, '/organization/login'),
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  // تخطي وتسجيل الدخول مباشرة (للمستخدمين الحاليين)
                  Navigator.pushNamed(context, '/volunteer/login');
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
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
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}