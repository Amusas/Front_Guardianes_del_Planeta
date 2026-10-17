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

  static const Map<int, String> levelNames = {
    1: 'Semilla Guardiana',
    2: 'Explorador del Agua',
    3: 'Guardián de los Mares',
    4: 'Protector de la Selva',
    5: 'Defensor del Planeta',
    6: 'Maestro Guardián',
  };

  int get levelNumber {
    if (levelId != null && levelId! > 0) return levelId!;
    if (totalXp >= 2500) return 6;
    if (totalXp >= 2000) return 5;
    if (totalXp >= 1500) return 4;
    if (totalXp >= 1000) return 3;
    if (totalXp >= 500) return 2;
    return 1;
  }

  String get levelName => levelNames[levelNumber] ?? 'Guardián del Planeta';

  int get currentLevelRequiredXp => (levelNumber - 1) * 500;

  int get nextLevelRequiredXp => levelNumber < 6 ? levelNumber * 500 : 2500;

  double get levelProgressRatio {
    if (levelNumber >= 6) return 1.0;
    final xpInLevel = totalXp - currentLevelRequiredXp;
    final span = nextLevelRequiredXp - currentLevelRequiredXp;
    if (span <= 0) return 1.0;
    return (xpInLevel / span).clamp(0.0, 1.0);
  }
}
