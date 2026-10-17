import '../entities/child_profile_entity.dart';
import '../entities/guardian_child_dashboard_entity.dart';
import '../../data/models/register_child_request_model.dart';

abstract class GuardianDashboardRepository {
  Future<List<ChildProfileEntity>> getChildren();
  Future<ChildProfileEntity> registerChild(RegisterChildRequestModel request);
  Future<GuardianChildDashboardEntity> getChildDashboard(int childId);
}
