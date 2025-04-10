import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_app/models/volunteer_model.dart';
import 'package:volunteer_app/providers/auth_provider.dart';

class VolunteerHomeScreen extends StatelessWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final volunteer = authProvider.currentUser as Volunteer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/volunteer/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${volunteer.name}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(volunteer.bio, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            const Text(
              'Your Skills:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children:
                  volunteer.skills
                      .map((skill) => Chip(label: Text(skill)))
                      .toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.work),
                    title: Text('Available Opportunities'),
                    subtitle: Text(
                      'Browse volunteering opportunities near you',
                    ),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Your Schedule'),
                    subtitle: Text('View your upcoming volunteering events'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Your Achievements'),
                    subtitle: Text('See your volunteering history and badges'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
