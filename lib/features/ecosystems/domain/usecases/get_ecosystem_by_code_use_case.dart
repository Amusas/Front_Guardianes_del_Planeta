import '../entities/ecosystem.dart';
import '../repositories/ecosystem_repository.dart';

class GetEcosystemByCodeUseCase {
  final EcosystemRepository _repository;

  GetEcosystemByCodeUseCase(this._repository);

  Future<Ecosystem> call(String code) {
    return _repository.getEcosystemByCode(code);
  }
}
