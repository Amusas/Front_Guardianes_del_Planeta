import '../entities/child_profile_entity.dart';
import '../repositories/guardian_dashboard_repository.dart';
import '../../data/models/register_child_request_model.dart';

class RegisterChildForGuardianUseCase {
  final GuardianDashboardRepository _repository;

  RegisterChildForGuardianUseCase(this._repository);

  Future<ChildProfileEntity> call(RegisterChildRequestModel request) {
    return _repository.registerChild(request);
  }
}
