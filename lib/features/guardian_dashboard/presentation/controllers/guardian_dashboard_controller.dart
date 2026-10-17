import 'package:flutter/material.dart';
import '../../../../core/logging/app_logger.dart';
import '../../data/models/register_child_request_model.dart';
import '../../domain/entities/child_profile_entity.dart';
import '../../domain/usecases/get_guardian_child_dashboard_use_case.dart';
import '../../domain/usecases/get_guardian_children_use_case.dart';
import '../../domain/usecases/register_child_for_guardian_use_case.dart';
import '../state/guardian_dashboard_state.dart';

class GuardianDashboardController extends ChangeNotifier {
  final GetGuardianChildrenUseCase _getChildrenUseCase;
  final GetGuardianChildDashboardUseCase _getChildDashboardUseCase;
  final RegisterChildForGuardianUseCase _registerChildUseCase;

  GuardianDashboardState _state = const GuardianDashboardState();
  GuardianDashboardState get state => _state;

  GuardianDashboardController({
    required GetGuardianChildrenUseCase getChildrenUseCase,
    required GetGuardianChildDashboardUseCase getChildDashboardUseCase,
    required RegisterChildForGuardianUseCase registerChildUseCase,
  })  : _getChildrenUseCase = getChildrenUseCase,
        _getChildDashboardUseCase = getChildDashboardUseCase,
        _registerChildUseCase = registerChildUseCase;

  void reset() {
    _state = const GuardianDashboardState();
    notifyListeners();
  }

  Future<void> loadDashboard({int? preferredChildId}) async {
    if (_state.status == GuardianDashboardStatus.loading && preferredChildId == null) {
      return;
    }

    _state = _state.copyWith(
      status: GuardianDashboardStatus.loading,
      clearError: true,
      isUnauthorized: false,
    );
    notifyListeners();

    try {
      AppLogger.debug('Controller: Iniciando carga de perfiles infantiles para el acudiente.');
      final children = await _getChildrenUseCase();

      if (children.isEmpty) {
        AppLogger.info('Controller: El acudiente no tiene perfiles infantiles asociados aún.');
        _state = _state.copyWith(
          status: GuardianDashboardStatus.empty,
          children: const [],
          selectedChildId: null,
          dashboard: null,
        );
        notifyListeners();
        return;
      }

      int targetChildId = preferredChildId ?? _state.selectedChildId ?? children.first.id;
      final childExists = children.any((c) => c.id == targetChildId);
      if (!childExists) {
        targetChildId = children.first.id;
      }

      AppLogger.debug('Controller: Cargando métricas para el niño ID $targetChildId');
      final dashboard = await _getChildDashboardUseCase(targetChildId);

      _state = _state.copyWith(
        status: GuardianDashboardStatus.loaded,
        children: children,
        selectedChildId: targetChildId,
        dashboard: dashboard,
      );
      AppLogger.info('Controller: Dashboard cargado satisfactoriamente para el niño ${dashboard.name}.');
    } catch (e, stack) {
      final isAuthError = e.toString().contains('401') || e.toString().contains('sesión');
      AppLogger.error('Controller: Error cargando el dashboard del acudiente', e, stack);
      _state = _state.copyWith(
        status: GuardianDashboardStatus.error,
        errorMessage: _cleanExceptionMessage(e),
        isUnauthorized: isAuthError,
      );
    }
    notifyListeners();
  }

  Future<void> selectChild(int childId) async {
    if (_state.selectedChildId == childId && _state.dashboard != null) {
      return;
    }

    _state = _state.copyWith(
      selectedChildId: childId,
      isSwitchingChild: true,
      clearError: true,
    );
    notifyListeners();

    try {
      AppLogger.debug('Controller: Cambiando a niño ID $childId');
      final dashboard = await _getChildDashboardUseCase(childId);
      _state = _state.copyWith(
        dashboard: dashboard,
        isSwitchingChild: false,
      );
      AppLogger.info('Controller: Métricas cambiadas al niño ${dashboard.name} con éxito.');
    } catch (e, stack) {
      AppLogger.error('Controller: Error al cambiar de niño a ID $childId', e, stack);
      _state = _state.copyWith(
        isSwitchingChild: false,
        errorMessage: _cleanExceptionMessage(e),
      );
    }
    notifyListeners();
  }

  Future<bool> registerChild({
    required String username,
    required String password,
    required String name,
    required DateTime dateOfBirth,
  }) async {
    _state = _state.copyWith(
      isCreatingChild: true,
      clearCreationError: true,
    );
    notifyListeners();

    try {
      AppLogger.debug('Controller: Enviando solicitud de registro de niño: $username');
      final request = RegisterChildRequestModel(
        username: username,
        password: password,
        name: name,
        dateOfBirth: dateOfBirth,
      );

      final newProfile = await _registerChildUseCase(request);
      AppLogger.info('Controller: Niño creado y asociado: ${newProfile.name} (ID: ${newProfile.id})');

      // Recargar la lista y seleccionar al nuevo niño
      await loadDashboard(preferredChildId: newProfile.id);

      _state = _state.copyWith(
        isCreatingChild: false,
        clearCreationError: true,
      );
      notifyListeners();
      return true;
    } catch (e, stack) {
      AppLogger.error('Controller: Fallo en registro de cuenta infantil', e, stack);
      _state = _state.copyWith(
        isCreatingChild: false,
        creationErrorMessage: _cleanExceptionMessage(e),
      );
      notifyListeners();
      return false;
    }
  }

  void clearCreationError() {
    _state = _state.copyWith(clearCreationError: true);
    notifyListeners();
  }

  String _cleanExceptionMessage(dynamic e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) {
      return msg.substring('Exception: '.length);
    }
    return msg;
  }
}
