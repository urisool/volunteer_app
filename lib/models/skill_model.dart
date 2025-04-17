// models/skill_model.dart
class Skill {
  final String id;
  final String name;
  final String category; // مثل "التعليم", "الصحة"
  final int proficiencyLevel; // من 1 إلى 5

  Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiencyLevel,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      proficiencyLevel: json['proficiencyLevel'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'proficiencyLevel': proficiencyLevel,
  };

  Skill copyWith({required int proficiencyLevel}) {
  return Skill(
    id: id,
    name: name,
    category: category,
    proficiencyLevel: proficiencyLevel,
  );
}
}