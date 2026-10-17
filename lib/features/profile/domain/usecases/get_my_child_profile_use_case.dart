import '../entities/child_profile_entity.dart';
import '../repositories/child_profile_repository.dart';

class GetMyChildProfileUseCase {
  final ChildProfileRepository _repository;

  GetMyChildProfileUseCase(this._repository);

  Future<ChildProfileEntity> execute() {
    return _repository.getMyProfile();
  }
}
