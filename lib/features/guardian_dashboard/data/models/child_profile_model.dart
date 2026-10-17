class ChildProfileModel {
  final int id;
  final int? userId;
  final String name;
  final DateTime? dateOfBirth;
  final int? age;
  final int totalXp;
  final int? levelId;
  final int streakCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChildProfileModel({
    required this.id,
    this.userId,
    required this.name,
    this.dateOfBirth,
    this.age,
    required this.totalXp,
    this.levelId,
    required this.streakCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ChildProfileModel.fromJson(Map<String, dynamic> json) {
    return ChildProfileModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String? ?? 'Explorador',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth'].toString()) : null,
      age: (json['age'] as num?)?.toInt(),
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      levelId: (json['levelId'] as num?)?.toInt(),
      streakCount: (json['streakCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'dateOfBirth': dateOfBirth?.toIso8601String().split('T').first,
      'age': age,
      'totalXp': totalXp,
      'levelId': levelId,
      'streakCount': streakCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
