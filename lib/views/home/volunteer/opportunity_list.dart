// views/opportunity/opportunity_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_app/providers/opportunity_provider.dart';
import 'package:volunteer_app/widgets/home/opportunity_card.dart';

class OpportunityListScreen extends StatelessWidget {
  const OpportunityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفرص التطوعية'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => Navigator.pushNamed(context, '/filter'),
          ),
        ],
      ),
      body: Consumer<OpportunityProvider>(
        builder: (ctx, provider, _) => ListView.builder(
          itemCount: provider.opportunities.length,
          itemBuilder: (ctx, i) => OpportunityCard(
            opportunity: provider.opportunities[i],
            onTap: () => Navigator.pushNamed(
              context,
              '/opportunity_detail',
              arguments: provider.opportunities[i],
            ),
          ),
        ),
      ),
    );
  }
}