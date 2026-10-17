import '../entities/child_profile_entity.dart';
import '../repositories/guardian_dashboard_repository.dart';

class GetGuardianChildrenUseCase {
  final GuardianDashboardRepository _repository;

  GetGuardianChildrenUseCase(this._repository);

  Future<List<ChildProfileEntity>> call() {
    return _repository.getChildren();
  }
}
