import 'package:flutter/material.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/ecosystem.dart';
import '../../domain/usecases/get_active_ecosystems_use_case.dart';
import '../state/ecosystem_state.dart';

class EcosystemController extends ChangeNotifier {
  final GetActiveEcosystemsUseCase _getActiveEcosystemsUseCase;

  EcosystemState _state = const EcosystemState();
  EcosystemState get state => _state;

  EcosystemController({
    required GetActiveEcosystemsUseCase getActiveEcosystemsUseCase,
  }) : _getActiveEcosystemsUseCase = getActiveEcosystemsUseCase;

  Future<void> loadEcosystems({bool forceRefresh = false}) async {
    // Evitar recargas innecesarias si ya está cargando o ya se cargó exitosamente y no se forza
    if (!forceRefresh && (_state.isLoading || (_state.isSuccess && _state.ecosystems.isNotEmpty))) {
      return;
    }

    _state = _state.copyWith(
      status: EcosystemLoadingStatus.loading,
      errorMessage: null,
    );
    notifyListeners();

    try {
      final ecosystems = await _getActiveEcosystemsUseCase();
      if (ecosystems.isEmpty) {
        AppLogger.warning('WARNING: La lista de ecosistemas retornada por el servidor está vacía.');
        _state = _state.copyWith(
          status: EcosystemLoadingStatus.empty,
          ecosystems: [],
          selectedIndex: 0,
        );
      } else {
        AppLogger.info('INFO: Se cargaron ${ecosystems.length} ecosistemas correctamente.');
        _state = _state.copyWith(
          status: EcosystemLoadingStatus.success,
          ecosystems: ecosystems,
          selectedIndex: 0,
        );
        if (_state.selectedEcosystem != null) {
          AppLogger.info('INFO: Ecosistema seleccionado: ${_state.selectedEcosystem!.name}.');
        }
      }
    } catch (e) {
      AppLogger.error('ERROR: No fue posible cargar los ecosistemas desde el servidor: $e');
      _state = _state.copyWith(
        status: EcosystemLoadingStatus.error,
        errorMessage: _cleanErrorMessage(e),
      );
    }

    notifyListeners();
  }

  void selectIndex(int index) {
    if (index >= 0 && index < _state.ecosystems.length && index != _state.selectedIndex) {
      _state = _state.copyWith(selectedIndex: index);
      final current = _state.selectedEcosystem;
      if (current != null) {
        AppLogger.info('INFO: Ecosistema seleccionado: ${current.name}.');
      }
      notifyListeners();
    }
  }

  String _cleanErrorMessage(dynamic error) {
    final str = error.toString();
    if (str.startsWith('Exception: ')) {
      return str.substring('Exception: '.length);
    }
    return 'No se pudo conectar con el servidor de ecosistemas.';
  }
}
