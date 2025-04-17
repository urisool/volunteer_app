// views/shared/rating_screen.dart
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages

class RatingScreen extends StatefulWidget {
  final String targetId;

  const RatingScreen({super.key, required this.targetId});

  @override
  // ignore: library_private_types_in_public_api
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 0;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تقييم الفرصة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) => setState(() => _rating = rating),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'تعليقك (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('إرسال التقييم'),
              onPressed: () {
                // إرسال البيانات للخادم
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBar {
  static builder({required double initialRating, required int minRating, required Axis direction, required bool allowHalfRating, required int itemCount, required EdgeInsets itemPadding, required Icon Function(dynamic context, dynamic _) itemBuilder, required void Function(dynamic rating) onRatingUpdate}) {}
}