import '../../domain/entities/ecosystem.dart';
import '../../domain/repositories/ecosystem_repository.dart';
import '../datasources/ecosystem_remote_data_source.dart';
import '../mappers/ecosystem_mapper.dart';

class EcosystemRepositoryImpl implements EcosystemRepository {
  final EcosystemRemoteDataSource _remoteDataSource;

  EcosystemRepositoryImpl({required EcosystemRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Ecosystem>> getActiveEcosystems() async {
    final models = await _remoteDataSource.getActiveEcosystems();
    return EcosystemMapper.toEntityList(models);
  }

  @override
  Future<Ecosystem> getEcosystemById(int ecosystemId) async {
    final model = await _remoteDataSource.getEcosystemById(ecosystemId);
    return EcosystemMapper.toEntity(model);
  }

  @override
  Future<Ecosystem> getEcosystemByCode(String code) async {
    final model = await _remoteDataSource.getEcosystemByCode(code);
    return EcosystemMapper.toEntity(model);
  }
}
