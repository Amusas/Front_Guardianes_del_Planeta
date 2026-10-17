import 'package:flutter/foundation.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/child_profile_entity.dart';
import '../../domain/entities/child_achievement_entity.dart';
import '../../domain/models/badge_model.dart';
import '../../domain/usecases/get_my_child_profile_use_case.dart';
import '../../domain/usecases/get_my_child_achievements_use_case.dart';
import '../../domain/usecases/get_all_achievements_use_case.dart';
import '../../domain/models/avatar_config.dart';
import '../../data/datasources/avatar_local_storage.dart';
import '../registry/achievement_visual_registry.dart';

class ChildProfileController extends ChangeNotifier {
  final GetMyChildProfileUseCase _getMyChildProfileUseCase;
  final GetMyChildAchievementsUseCase? _getMyChildAchievementsUseCase;
  final GetAllAchievementsUseCase? _getAllAchievementsUseCase;
  final AvatarLocalStorage _avatarStorage;

  ChildProfileEntity? _profile;
  ChildProfileEntity? get profile => _profile;

  AvatarConfig _avatarConfig = AvatarConfig.defaultConfig();
  AvatarConfig get avatarConfig => _avatarConfig;

  List<ChildAchievementEntity> _achievements = [];
  List<ChildAchievementEntity> get achievements => List.unmodifiable(_achievements);

  List<BadgeModel> _badges = [];
  List<BadgeModel> get badges => List.unmodifiable(_badges);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _hasLoadedOnce = false;
  bool get hasLoadedOnce => _hasLoadedOnce;

  ChildProfileController({
    required GetMyChildProfileUseCase getMyChildProfileUseCase,
    GetMyChildAchievementsUseCase? getMyChildAchievementsUseCase,
    GetAllAchievementsUseCase? getAllAchievementsUseCase,
    AvatarLocalStorage? avatarStorage,
  })  : _getMyChildProfileUseCase = getMyChildProfileUseCase,
        _getMyChildAchievementsUseCase = getMyChildAchievementsUseCase,
        _getAllAchievementsUseCase = getAllAchievementsUseCase,
        _avatarStorage = avatarStorage ?? AvatarLocalStorage();

  int get totalXp => _profile?.totalXp ?? 0;
  int get levelNumber => _profile?.levelNumber ?? 1;
  String get levelName => _profile?.levelName ?? 'Semilla Guardiana';
  int get currentLevelRequiredXp => _profile?.currentLevelRequiredXp ?? 0;
  int get nextLevelRequiredXp => _profile?.nextLevelRequiredXp ?? 500;
  double get levelProgressRatio => _profile?.levelProgressRatio ?? 0.0;
  String get childName => _profile?.name ?? 'Explorador';
  int get streakCount => _profile?.streakCount ?? 0;
  int get unlockedAchievementsCount => _badges.where((b) => b.isUnlocked).length;
  int get totalAchievementsCount => _badges.length;

  Future<void> loadProfile({bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_hasLoadedOnce && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      AppLogger.info('Cargando perfil del niño...');
      final profileResult = await _getMyChildProfileUseCase.execute();
      _profile = profileResult;

      // Cargar avatar personalizado persistido para el niño
      try {
        _avatarConfig = await _avatarStorage.loadAvatar(profileResult.id);
      } catch (e) {
        AppLogger.warning('No se pudo cargar el avatar guardado: $e');
      }

      // 1. Cargar todos los logros del sistema
      List<ChildAchievementEntity> allAchievements = [];
      if (_getAllAchievementsUseCase != null) {
        try {
          allAchievements = await _getAllAchievementsUseCase!.execute();
          AppLogger.info('Logros del sistema obtenidos: ${allAchievements.length}');
        } catch (e) {
          AppLogger.warning('No se pudieron obtener todos los logros: $e');
        }
      }

      // 2. Cargar logros desbloqueados por el niño
      List<ChildAchievementEntity> myUnlocked = [];
      if (_getMyChildAchievementsUseCase != null) {
        try {
          myUnlocked = await _getMyChildAchievementsUseCase!.execute();
          AppLogger.info('Logros desbloqueados del niño: ${myUnlocked.length}');
        } catch (e) {
          AppLogger.warning('No se pudieron cargar los logros desbloqueados: $e');
        }
      }

      // Si la lista de logros del sistema está vacía (ej. offline o error de red),
      // proveemos el catálogo base estándar del juego.
      if (allAchievements.isEmpty) {
        allAchievements = _fallbackSystemAchievements();
      }

      final unlockedIds = myUnlocked.map((a) => a.id).toSet();
      final unlockedCodes = myUnlocked.map((a) => a.code.toUpperCase()).toSet();
      final unlockedDateMap = {for (var a in myUnlocked) a.code.toUpperCase(): a.unlockedAt};

      _achievements = allAchievements.map((ach) {
        final isUnlocked = unlockedIds.contains(ach.id) || unlockedCodes.contains(ach.code.toUpperCase());
        final unlockedAt = unlockedDateMap[ach.code.toUpperCase()] ?? ach.unlockedAt;
        return ach.copyWith(isUnlocked: isUnlocked, unlockedAt: unlockedAt);
      }).toList();

      _badges = _achievements.map(AchievementVisualRegistry.toBadgeModel).toList();

      _hasLoadedOnce = true;
      _isLoading = false;
      AppLogger.info('Perfil y logros infantiles cargados exitosamente. Logros desbloqueados: $unlockedAchievementsCount/${_badges.length}');
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      AppLogger.error('Error cargando perfil del niño', e);
      notifyListeners();
    }
  }

  void addExperienceLocally(int xpGained) {
    if (_profile != null && xpGained > 0) {
      _profile = ChildProfileEntity(
        id: _profile!.id,
        userId: _profile!.userId,
        name: _profile!.name,
        dateOfBirth: _profile!.dateOfBirth,
        age: _profile!.age,
        totalXp: _profile!.totalXp + xpGained,
        levelId: _profile!.levelId,
        streakCount: _profile!.streakCount,
        createdAt: _profile!.createdAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> updateAvatar(AvatarConfig newConfig) async {
    _avatarConfig = newConfig;
    notifyListeners();
    if (_profile != null) {
      await _avatarStorage.saveAvatar(_profile!.id, newConfig);
    }
  }

  static List<ChildAchievementEntity> _fallbackSystemAchievements() {
    return const [
      ChildAchievementEntity(
        id: 1,
        code: 'FIRST_STEP',
        title: 'Primer Paso',
        description: 'Completar la primera actividad educativa.',
        conditionType: 'FIRST_ACTIVITY',
        conditionValue: 1,
        visualKey: 'BADGE_FIRST_STEP',
      ),
      ChildAchievementEntity(
        id: 2,
        code: 'FIRST_LESSON',
        title: 'Primera Lección',
        description: 'Completar con éxito tu primera lección ambiental.',
        conditionType: 'FIRST_LESSON',
        conditionValue: 1,
        visualKey: 'BADGE_FIRST_LESSON',
      ),
      ChildAchievementEntity(
        id: 3,
        code: 'WATER_PROTECTOR',
        title: 'Protector del Agua',
        description: 'Alcanzar 5 lecciones completadas.',
        conditionType: 'LESSON_COUNT',
        conditionValue: 5,
        visualKey: 'BADGE_WATER_PROTECTOR',
      ),
      ChildAchievementEntity(
        id: 4,
        code: 'SEVEN_DAY_STREAK',
        title: 'Racha Imparable',
        description: 'Mantener una racha activa de 7 días consecutivos.',
        conditionType: 'STREAK_REACHED',
        conditionValue: 7,
        visualKey: 'BADGE_SEVEN_STREAK',
      ),
      ChildAchievementEntity(
        id: 5,
        code: 'ECOSYSTEM_EXPLORER',
        title: 'Explorador de Ecosistemas',
        description: 'Completar al menos 3 ecosistemas.',
        conditionType: 'ECOSYSTEM_COUNT',
        conditionValue: 3,
        visualKey: 'BADGE_ECOSYSTEM_EXPLORER',
      ),
      ChildAchievementEntity(
        id: 6,
        code: 'XP_MASTER',
        title: 'Maestro del Conocimiento',
        description: 'Alcanzar 1000 puntos de XP.',
        conditionType: 'XP_REACHED',
        conditionValue: 1000,
        visualKey: 'BADGE_XP_MASTER',
      ),
      ChildAchievementEntity(
        id: 7,
        code: 'LEVEL_UP_3',
        title: 'Guardián de Mares',
        description: 'Alcanzar el Nivel 3 en tu aventura.',
        conditionType: 'LEVEL_REACHED',
        conditionValue: 3,
        visualKey: 'BADGE_LEVEL_3',
      ),
    ];
  }
}
