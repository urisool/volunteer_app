import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;
  
  const ProfileHeader({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.role,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(height: 10),
        Text(
          name,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          role,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}