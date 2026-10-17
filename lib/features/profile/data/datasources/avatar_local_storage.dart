import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/models/avatar_config.dart';

class AvatarLocalStorage {
  final FlutterSecureStorage _storage;

  AvatarLocalStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  String _getKey(int childId) => 'child_avatar_$childId';

  Future<void> saveAvatar(int childId, AvatarConfig config) async {
    try {
      final key = _getKey(childId);
      final jsonString = jsonEncode(config.toJson());
      await _storage.write(key: key, value: jsonString);
      AppLogger.info('Avatar guardado exitosamente para el niño $childId');
    } catch (e) {
      AppLogger.error('Error al guardar avatar para el niño $childId', e);
    }
  }

  Future<AvatarConfig> loadAvatar(int childId) async {
    try {
      final key = _getKey(childId);
      final raw = await _storage.read(key: key);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return AvatarConfig.fromJson(decoded);
      }
    } catch (e) {
      AppLogger.warning('Error al leer avatar de almacenamiento, usando predeterminado: $e');
    }
    return AvatarConfig.defaultConfig();
  }
}
