import '../../domain/entities/ecosystem.dart';

enum EcosystemLoadingStatus {
  initial,
  loading,
  success,
  empty,
  error,
}

class EcosystemState {
  final EcosystemLoadingStatus status;
  final List<Ecosystem> ecosystems;
  final int selectedIndex;
  final String? errorMessage;

  const EcosystemState({
    this.status = EcosystemLoadingStatus.initial,
    this.ecosystems = const [],
    this.selectedIndex = 0,
    this.errorMessage,
  });

  Ecosystem? get selectedEcosystem {
    if (ecosystems.isEmpty || selectedIndex < 0 || selectedIndex >= ecosystems.length) {
      return null;
    }
    return ecosystems[selectedIndex];
  }

  bool get isLoading => status == EcosystemLoadingStatus.loading;
  bool get isSuccess => status == EcosystemLoadingStatus.success;
  bool get isEmpty => status == EcosystemLoadingStatus.empty;
  bool get isError => status == EcosystemLoadingStatus.error;

  EcosystemState copyWith({
    EcosystemLoadingStatus? status,
    List<Ecosystem>? ecosystems,
    int? selectedIndex,
    String? errorMessage,
  }) {
    return EcosystemState(
      status: status ?? this.status,
      ecosystems: ecosystems ?? this.ecosystems,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
