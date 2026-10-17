import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/entities/ecosystem.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/repositories/ecosystem_repository.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/usecases/get_active_ecosystems_use_case.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/usecases/get_ecosystem_by_id_use_case.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/usecases/get_ecosystem_by_code_use_case.dart';

class MockEcosystemRepository extends Mock implements EcosystemRepository {}

void main() {
  late MockEcosystemRepository mockRepository;
  late GetActiveEcosystemsUseCase getActiveEcosystemsUseCase;
  late GetEcosystemByIdUseCase getEcosystemByIdUseCase;
  late GetEcosystemByCodeUseCase getEcosystemByCodeUseCase;

  setUp(() {
    mockRepository = MockEcosystemRepository();
    getActiveEcosystemsUseCase = GetActiveEcosystemsUseCase(mockRepository);
    getEcosystemByIdUseCase = GetEcosystemByIdUseCase(mockRepository);
    getEcosystemByCodeUseCase = GetEcosystemByCodeUseCase(mockRepository);
  });

  group('Ecosystem Use Cases Tests', () {
    test('GetActiveEcosystemsUseCase calls repository.getActiveEcosystems', () async {
      final list = [
        const Ecosystem(id: 1, code: 'BOSQUE_ANDINO', name: 'Bosque Andino', description: 'Desc'),
      ];
      when(() => mockRepository.getActiveEcosystems()).thenAnswer((_) async => list);

      final result = await getActiveEcosystemsUseCase();

      expect(result, list);
      verify(() => mockRepository.getActiveEcosystems()).called(1);
    });

    test('GetEcosystemByIdUseCase calls repository.getEcosystemById', () async {
      const eco = Ecosystem(id: 2, code: 'PARAMO', name: 'Páramo', description: 'Desc');
      when(() => mockRepository.getEcosystemById(2)).thenAnswer((_) async => eco);

      final result = await getEcosystemByIdUseCase(2);

      expect(result, eco);
      verify(() => mockRepository.getEcosystemById(2)).called(1);
    });

    test('GetEcosystemByCodeUseCase calls repository.getEcosystemByCode', () async {
      const eco = Ecosystem(id: 3, code: 'OCEANO', name: 'Océano', description: 'Desc');
      when(() => mockRepository.getEcosystemByCode('OCEANO')).thenAnswer((_) async => eco);

      final result = await getEcosystemByCodeUseCase('OCEANO');

      expect(result, eco);
      verify(() => mockRepository.getEcosystemByCode('OCEANO')).called(1);
    });
  });
}
