// views/opportunity/opportunity_detail.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_app/models/opportunity_model.dart';
import 'package:volunteer_app/providers/volunteer_provider.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(opportunity.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(opportunity.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('المتطلبات:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...opportunity.requiredSkills!.map((skill) => Text('- $skill')),
            Spacer(),
            Consumer<VolunteerProvider>(
              builder: (ctx, provider, _) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () => provider.joinOpportunity(opportunity),
                child: Text('انضم الآن'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}