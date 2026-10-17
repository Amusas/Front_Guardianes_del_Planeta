class Lesson {
  final int id;
  final int ecosystemId;
  final String title;
  final String content;
  final int orderIndex;
  final int xpReward;
  final bool isActive;

  const Lesson({
    required this.id,
    required this.ecosystemId,
    required this.title,
    required this.content,
    required this.orderIndex,
    required this.xpReward,
    required this.isActive,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lesson &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ecosystemId == other.ecosystemId &&
          orderIndex == other.orderIndex;

  @override
  int get hashCode => id.hashCode ^ ecosystemId.hashCode ^ orderIndex.hashCode;
}
