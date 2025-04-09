import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final String content;
  
  const ProfileSection({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6?.copyWith(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Divider(height: 20),
        ],
      ),
    );
  }
}