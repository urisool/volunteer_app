import 'package:flutter/material.dart';
import 'package:volunteer_app/models/achievement_model.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const AchievementBadge({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(achievement.badgeUrl),
        ),
        SizedBox(height: 5),
        Text(achievement.title, 
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}