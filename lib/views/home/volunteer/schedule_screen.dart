// views/home/volunteer/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/volunteer_provider.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = context.watch<VolunteerProvider>().upcomingEvents;

    return Scaffold(
      appBar: AppBar(title: Text('جدولك الزمني')),
      body: events.isEmpty
          ? Center(child: Text('لا توجد أحداث قادمة'))
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (ctx, i) => ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(events[i].title),
                subtitle: Text('${events[i].location} - ${events[i].date}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => context.read<VolunteerProvider>().cancelEvent(events[i]),
                ),
              ),
            ),
    );
  }
}