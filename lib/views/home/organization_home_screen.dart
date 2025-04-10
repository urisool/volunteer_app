import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class OrganizationHomeScreen extends StatelessWidget {
  const OrganizationHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final organization = authProvider.currentUser as Organization;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/organization/profile');
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
              organization.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 4),
            Text(
              organization.field,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 8),
            Text(
              organization.bio,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text('Rating: ${organization.rating.toStringAsFixed(1)}/5'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Create New Opportunity'),
                    subtitle: Text('Post a new volunteering opportunity'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Manage Volunteers'),
                    subtitle: Text('View and manage your volunteers'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment),
                    title: Text('Current Projects'),
                    subtitle: Text('Manage your ongoing projects'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.analytics),
                    title: Text('Reports'),
                    subtitle: Text('View organization analytics'),
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