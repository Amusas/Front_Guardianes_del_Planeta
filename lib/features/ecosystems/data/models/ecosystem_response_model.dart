class EcosystemResponseModel {
  final int id;
  final String code;
  final String name;
  final String description;
  final int? requiredLevelId;
  final String? mascotKey;
  final bool isActive;

  const EcosystemResponseModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    this.requiredLevelId,
    this.mascotKey,
    this.isActive = true,
  });

  factory EcosystemResponseModel.fromJson(Map<String, dynamic> json) {
    return EcosystemResponseModel(
      id: json['id'] as int,
      code: (json['code'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      requiredLevelId: json['requiredLevelId'] as int?,
      mascotKey: json['mascotKey'] as String?,
      isActive: (json['isActive'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'requiredLevelId': requiredLevelId,
      'mascotKey': mascotKey,
      'isActive': isActive,
    };
  }
}
