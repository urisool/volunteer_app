import 'package:flutter/material.dart';
import 'package:volunteer_app/models/opportunity_model.dart';

class ScheduleItem extends StatelessWidget {
  final Opportunity event;

  const ScheduleItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.event)),
      title: Text(event.title),
      subtitle: Text('${event.date.hour}:${event.date.minute} - ${event.location}'),
      trailing: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {/* Handle cancel */},
      ),
    );
  }
}