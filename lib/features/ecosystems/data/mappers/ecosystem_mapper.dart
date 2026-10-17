import '../models/ecosystem_response_model.dart';
import '../../domain/entities/ecosystem.dart';

class EcosystemMapper {
  EcosystemMapper._();

  static Ecosystem toEntity(EcosystemResponseModel model) {
    return Ecosystem(
      id: model.id,
      code: model.code,
      name: model.name,
      description: model.description,
      requiredLevelId: model.requiredLevelId,
      mascotKey: model.mascotKey,
      isActive: model.isActive,
    );
  }

  static List<Ecosystem> toEntityList(List<EcosystemResponseModel> models) {
    return models.map(toEntity).toList();
  }
}
