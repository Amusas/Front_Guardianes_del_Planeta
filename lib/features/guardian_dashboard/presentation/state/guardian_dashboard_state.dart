import '../../domain/entities/child_profile_entity.dart';
import '../../domain/entities/guardian_child_dashboard_entity.dart';

enum GuardianDashboardStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class GuardianDashboardState {
  final GuardianDashboardStatus status;
  final List<ChildProfileEntity> children;
  final int? selectedChildId;
  final GuardianChildDashboardEntity? dashboard;
  final bool isSwitchingChild;
  final String? errorMessage;
  final bool isCreatingChild;
  final String? creationErrorMessage;
  final bool isUnauthorized;

  const GuardianDashboardState({
    this.status = GuardianDashboardStatus.initial,
    this.children = const [],
    this.selectedChildId,
    this.dashboard,
    this.isSwitchingChild = false,
    this.errorMessage,
    this.isCreatingChild = false,
    this.creationErrorMessage,
    this.isUnauthorized = false,
  });

  ChildProfileEntity? get selectedChild {
    if (selectedChildId == null) return null;
    try {
      return children.firstWhere((c) => c.id == selectedChildId);
    } catch (_) {
      return children.isNotEmpty ? children.first : null;
    }
  }

  GuardianDashboardState copyWith({
    GuardianDashboardStatus? status,
    List<ChildProfileEntity>? children,
    int? selectedChildId,
    GuardianChildDashboardEntity? dashboard,
    bool? isSwitchingChild,
    String? errorMessage,
    bool clearError = false,
    bool? isCreatingChild,
    String? creationErrorMessage,
    bool clearCreationError = false,
    bool? isUnauthorized,
  }) {
    return GuardianDashboardState(
      status: status ?? this.status,
      children: children ?? this.children,
      selectedChildId: selectedChildId ?? this.selectedChildId,
      dashboard: dashboard ?? this.dashboard,
      isSwitchingChild: isSwitchingChild ?? this.isSwitchingChild,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isCreatingChild: isCreatingChild ?? this.isCreatingChild,
      creationErrorMessage: clearCreationError ? null : (creationErrorMessage ?? this.creationErrorMessage),
      isUnauthorized: isUnauthorized ?? this.isUnauthorized,
    );
  }
}
