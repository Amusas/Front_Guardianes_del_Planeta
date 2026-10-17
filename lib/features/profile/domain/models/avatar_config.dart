class AvatarConfig {
  final String characterId;
  final String backgroundId;
  final String accessoryId;
  final String expressionId;

  const AvatarConfig({
    required this.characterId,
    required this.backgroundId,
    required this.accessoryId,
    required this.expressionId,
  });

  /// Configuración por defecto: Joven explorador con gorra y fondo esmeralda
  factory AvatarConfig.defaultConfig() {
    return const AvatarConfig(
      characterId: 'explorador',
      backgroundId: 'esmeralda',
      accessoryId: 'gorra',
      expressionId: 'feliz',
    );
  }

  AvatarConfig copyWith({
    String? characterId,
    String? backgroundId,
    String? accessoryId,
    String? expressionId,
  }) {
    return AvatarConfig(
      characterId: characterId ?? this.characterId,
      backgroundId: backgroundId ?? this.backgroundId,
      accessoryId: accessoryId ?? this.accessoryId,
      expressionId: expressionId ?? this.expressionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'characterId': characterId,
      'backgroundId': backgroundId,
      'accessoryId': accessoryId,
      'expressionId': expressionId,
    };
  }

  factory AvatarConfig.fromJson(Map<String, dynamic> json) {
    return AvatarConfig(
      characterId: json['characterId'] as String? ?? 'explorador',
      backgroundId: json['backgroundId'] as String? ?? 'esmeralda',
      accessoryId: json['accessoryId'] as String? ?? 'gorra',
      expressionId: json['expressionId'] as String? ?? 'feliz',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarConfig &&
          runtimeType == other.runtimeType &&
          characterId == other.characterId &&
          backgroundId == other.backgroundId &&
          accessoryId == other.accessoryId &&
          expressionId == other.expressionId;

  @override
  int get hashCode =>
      characterId.hashCode ^
      backgroundId.hashCode ^
      accessoryId.hashCode ^
      expressionId.hashCode;
}

class AvatarOption {
  final String id;
  final String name;
  final String description;
  final int requiredLevel;
  final String visualKey;

  const AvatarOption({
    required this.id,
    required this.name,
    required this.description,
    this.requiredLevel = 1,
    required this.visualKey,
  });
}
