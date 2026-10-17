import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/entities/ecosystem.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/usecases/get_active_ecosystems_use_case.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/controllers/ecosystem_controller.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/state/ecosystem_state.dart';

class MockGetActiveEcosystemsUseCase extends Mock implements GetActiveEcosystemsUseCase {}

void main() {
  late MockGetActiveEcosystemsUseCase mockUseCase;
  late EcosystemController controller;

  setUp(() {
    mockUseCase = MockGetActiveEcosystemsUseCase();
    controller = EcosystemController(getActiveEcosystemsUseCase: mockUseCase);
  });

  group('EcosystemController Tests', () {
    test('initial state is correct', () {
      expect(controller.state.status, EcosystemLoadingStatus.initial);
      expect(controller.state.ecosystems, isEmpty);
      expect(controller.state.selectedIndex, 0);
    });

    test('loadEcosystems updates state to success with loaded ecosystems', () async {
      final sampleEcosystems = [
        const Ecosystem(id: 1, code: 'BOSQUE_ANDINO', name: 'Bosque Andino', description: 'Desc 1'),
        const Ecosystem(id: 2, code: 'PARAMO', name: 'Páramo', description: 'Desc 2'),
      ];

      when(() => mockUseCase()).thenAnswer((_) async => sampleEcosystems);

      await controller.loadEcosystems();

      expect(controller.state.status, EcosystemLoadingStatus.success);
      expect(controller.state.ecosystems.length, 2);
      expect(controller.state.selectedEcosystem?.code, 'BOSQUE_ANDINO');
      expect(controller.state.errorMessage, isNull);
    });

    test('loadEcosystems updates state to empty when list is empty', () async {
      when(() => mockUseCase()).thenAnswer((_) async => []);

      await controller.loadEcosystems();

      expect(controller.state.status, EcosystemLoadingStatus.empty);
      expect(controller.state.ecosystems, isEmpty);
    });

    test('loadEcosystems updates state to error when exception occurs', () async {
      when(() => mockUseCase()).thenThrow(Exception('Error de conexión'));

      await controller.loadEcosystems();

      expect(controller.state.status, EcosystemLoadingStatus.error);
      expect(controller.state.errorMessage, 'Error de conexión');
    });

    test('selectIndex updates selectedIndex correctly', () async {
      final sampleEcosystems = [
        const Ecosystem(id: 1, code: 'BOSQUE_ANDINO', name: 'Bosque Andino', description: 'Desc 1'),
        const Ecosystem(id: 2, code: 'PARAMO', name: 'Páramo', description: 'Desc 2'),
      ];

      when(() => mockUseCase()).thenAnswer((_) async => sampleEcosystems);
      await controller.loadEcosystems();

      controller.selectIndex(1);

      expect(controller.state.selectedIndex, 1);
      expect(controller.state.selectedEcosystem?.code, 'PARAMO');
    });
  });
}
