import '../entities/ecosystem.dart';
import '../repositories/ecosystem_repository.dart';

class GetEcosystemByIdUseCase {
  final EcosystemRepository _repository;

  GetEcosystemByIdUseCase(this._repository);

  Future<Ecosystem> call(int id) {
    return _repository.getEcosystemById(id);
  }
}
