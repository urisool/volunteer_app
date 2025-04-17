import 'package:flutter/material.dart';
import 'package:volunteer_app/models/opportunity_model.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback? onTap;

  const OpportunityCard({super.key, required this.opportunity, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.volunteer_activism),
        title: Text(opportunity.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(opportunity.location),
            Text('${opportunity.date.day}/${opportunity.date.month}/${opportunity.date.year}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}