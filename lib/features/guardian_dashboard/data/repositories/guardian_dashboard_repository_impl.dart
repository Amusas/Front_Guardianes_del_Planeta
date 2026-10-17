import '../../domain/entities/child_profile_entity.dart';
import '../../domain/entities/guardian_child_dashboard_entity.dart';
import '../../domain/repositories/guardian_dashboard_repository.dart';
import '../datasources/guardian_dashboard_remote_data_source.dart';
import '../mappers/guardian_dashboard_mapper.dart';
import '../models/register_child_request_model.dart';

class GuardianDashboardRepositoryImpl implements GuardianDashboardRepository {
  final GuardianDashboardRemoteDataSource _remoteDataSource;

  GuardianDashboardRepositoryImpl({required GuardianDashboardRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<ChildProfileEntity>> getChildren() async {
    final models = await _remoteDataSource.getChildren();
    return models.map(GuardianDashboardMapper.toChildProfileEntity).toList();
  }

  @override
  Future<ChildProfileEntity> registerChild(RegisterChildRequestModel request) async {
    final model = await _remoteDataSource.registerChild(request);
    return GuardianDashboardMapper.toChildProfileEntity(model);
  }

  @override
  Future<GuardianChildDashboardEntity> getChildDashboard(int childId) async {
    final model = await _remoteDataSource.getChildDashboard(childId);
    return GuardianDashboardMapper.toDashboardEntity(model);
  }
}
