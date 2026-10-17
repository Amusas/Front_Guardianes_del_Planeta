class ChildProfileEntity {
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

  const ChildProfileEntity({
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
}
