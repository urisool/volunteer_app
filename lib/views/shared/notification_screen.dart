// views/shared/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;

    return Scaffold(
      appBar: AppBar(title: Text('الإشعارات')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: Icon(Icons.notifications),
          title: Text(notifications[i].title),
          subtitle: Text(notifications[i].body),
          trailing: Text(notifications[i].timeAgo),
          onTap: () => _handleNotificationTap(notifications[i]),
        ),
      ),
    );
  }

  void _handleNotificationTap(Notification notification) {
    // معالجة النقر على الإشعار
  }
}

class NotificationProvider {
  // ignore: prefer_typing_uninitialized_variables
  var notifications;
}