import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;

  const ProfileHeader({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundImage: NetworkImage(imageUrl)),
        SizedBox(height: 10),
        Text(name, style: Theme.of(context).textTheme.headlineSmall),
        Text(
          role,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
