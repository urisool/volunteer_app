// models/achievement_model.dart
class Achievement {
  final String id;
  final String title;
  final String description;
  final DateTime earnedDate;
  final String badgeUrl; // رابط صورة الشارة
  final int points; // النقاط الممنوحة

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.earnedDate,
    required this.badgeUrl,
    required this.points,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      earnedDate: DateTime.parse(json['earnedDate']),
      badgeUrl: json['badgeUrl'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'earnedDate': earnedDate.toIso8601String(),
    'badgeUrl': badgeUrl,
    'points': points,
  };
}