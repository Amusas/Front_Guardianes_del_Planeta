class Ecosystem {
  final int id;
  final String code;
  final String name;
  final String description;
  final int? requiredLevelId;
  final String? mascotKey;
  final bool isActive;

  const Ecosystem({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    this.requiredLevelId,
    this.mascotKey,
    this.isActive = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ecosystem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => id.hashCode ^ code.hashCode;
}
