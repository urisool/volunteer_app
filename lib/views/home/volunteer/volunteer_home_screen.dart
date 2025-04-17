// views/home/volunteer/volunteer_home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volunteer_app/providers/opportunity_provider.dart';
import '../../../providers/volunteer_provider.dart';
import '../../../widgets/home/opportunity_card.dart';

class VolunteerHomeScreen extends StatelessWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final volunteer = context.watch<VolunteerProvider>().currentVolunteer;

    return Scaffold(
      appBar: AppBar(
        title: Text('مرحباً ${volunteer?.name ?? "مستخدم"}'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkillsSection(context),
              SizedBox(height: 20),
              _buildOpportunitiesSection(context),
              SizedBox(height: 20),
              _buildScheduleSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('مهاراتك:', style: Theme.of(context).textTheme.titleLarge),
        Wrap(
          spacing: 8,
          children: context.watch<VolunteerProvider>().skills.map((skill) => 
            Chip(label: Text(skill.name)),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildOpportunitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الفرص المتاحة', style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              child: Text('عرض الكل'),
              onPressed: () => Navigator.pushNamed(context, '/opportunities'),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3, // عرض أول 3 فرص
            itemBuilder: (ctx, i) => OpportunityCard(
              opportunity: context.watch<OpportunityProvider>().opportunities[i],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('جدولك القادم', style: Theme.of(context).textTheme.titleLarge),
        ...context.watch<VolunteerProvider>().upcomingEvents.take(3).map((event) => 
          ListTile(
            leading: Icon(Icons.event),
            title: Text(event.title),
            subtitle: Text(event.date.toString()),
          ),
        ),
      ],
    );
  }
}