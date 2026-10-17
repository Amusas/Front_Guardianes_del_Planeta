import '../entities/ecosystem.dart';
import '../repositories/ecosystem_repository.dart';

class GetActiveEcosystemsUseCase {
  final EcosystemRepository _repository;

  GetActiveEcosystemsUseCase(this._repository);

  Future<List<Ecosystem>> call() {
    return _repository.getActiveEcosystems();
  }
}
