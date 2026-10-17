import '../../domain/entities/ecosystem.dart';

abstract class EcosystemRepository {
  Future<List<Ecosystem>> getActiveEcosystems();
  Future<Ecosystem> getEcosystemById(int ecosystemId);
  Future<Ecosystem> getEcosystemByCode(String code);
}
