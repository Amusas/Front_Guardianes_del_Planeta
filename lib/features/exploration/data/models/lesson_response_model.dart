class LessonResponseModel {
  final int id;
  final int ecosystemId;
  final String title;
  final String content;
  final int orderIndex;
  final int xpReward;
  final bool isActive;

  const LessonResponseModel({
    required this.id,
    required this.ecosystemId,
    required this.title,
    required this.content,
    required this.orderIndex,
    required this.xpReward,
    required this.isActive,
  });

  factory LessonResponseModel.fromJson(Map<String, dynamic> json) {
    return LessonResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ecosystemId: (json['ecosystemId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 50,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ecosystemId': ecosystemId,
      'title': title,
      'content': content,
      'orderIndex': orderIndex,
      'xpReward': xpReward,
      'isActive': isActive,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonResponseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ecosystemId == other.ecosystemId &&
          orderIndex == other.orderIndex;

  @override
  int get hashCode => id.hashCode ^ ecosystemId.hashCode ^ orderIndex.hashCode;
}
