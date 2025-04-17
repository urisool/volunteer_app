// models/opportunity_model.dart

// models/opportunity_model.dart

class Opportunity {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String organizationId;

  Opportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.organizationId,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      organizationId: json['organizationId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'organizationId': organizationId,
    };
  }

  // إذا عندك مهارات مطلوبة أو شيء إضافي حابة تضيفيه لاحقاً، نحطه هنا
  List<String>? get requiredSkills => null;
}
