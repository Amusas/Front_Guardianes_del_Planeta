import '../entities/guardian_child_dashboard_entity.dart';
import '../repositories/guardian_dashboard_repository.dart';

class GetGuardianChildDashboardUseCase {
  final GuardianDashboardRepository _repository;

  GetGuardianChildDashboardUseCase(this._repository);

  Future<GuardianChildDashboardEntity> call(int childId) {
    return _repository.getChildDashboard(childId);
  }
}
