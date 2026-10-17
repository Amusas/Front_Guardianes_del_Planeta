import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/theme/app_theme.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/entities/ecosystem.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/controllers/ecosystem_controller.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/screens/ecosystem_selector_screen.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/state/ecosystem_state.dart';

class MockEcosystemController extends Mock implements EcosystemController {}

void main() {
  late MockEcosystemController mockController;

  setUp(() {
    mockController = MockEcosystemController();
    when(() => mockController.loadEcosystems(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<EcosystemController>.value(
      value: mockController,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: EcosystemSelectorScreen(
          onExploreEcosystem: (_) {},
          onOpenProfile: () {},
          onOpenParentDashboard: () {},
        ),
      ),
    );
  }

  group('EcosystemSelectorScreen Widget Tests', () {
    testWidgets('renders loading state when status is loading', (tester) async {
      when(() => mockController.state).thenReturn(
        const EcosystemState(status: EcosystemLoadingStatus.loading),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Cargando mundos de Guardianes...'), findsOneWidget);
    });

    testWidgets('renders error state with retry button', (tester) async {
      when(() => mockController.state).thenReturn(
        const EcosystemState(
          status: EcosystemLoadingStatus.error,
          errorMessage: 'No se pudo conectar con el servidor',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('¡Ups! No pudimos conectar con los ecosistemas'), findsOneWidget);
      expect(find.text('No se pudo conectar con el servidor'), findsOneWidget);
      expect(find.text('REINTENTAR'), findsOneWidget);

      await tester.tap(find.text('REINTENTAR'));
      await tester.pump();

      verify(() => mockController.loadEcosystems(forceRefresh: true)).called(1);
    });

    testWidgets('renders empty state with refresh button', (tester) async {
      when(() => mockController.state).thenReturn(
        const EcosystemState(status: EcosystemLoadingStatus.empty, ecosystems: []),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Aún no hay ecosistemas disponibles'), findsOneWidget);
      expect(find.text('ACTUALIZAR'), findsOneWidget);

      await tester.tap(find.text('ACTUALIZAR'));
      await tester.pump();

      verify(() => mockController.loadEcosystems(forceRefresh: true)).called(1);
    });

    testWidgets('renders carousel and ecosystem data when success', (tester) async {
      final ecosystems = [
        const Ecosystem(
          id: 1,
          code: 'BOSQUE_ANDINO',
          name: 'Bosque Andino',
          description: 'El hogar del oso de anteojos y palmas.',
          isActive: true,
        ),
        const Ecosystem(
          id: 2,
          code: 'PARAMO',
          name: 'El Páramo',
          description: 'Frailejones y lagunas sagradas.',
          isActive: true,
        ),
      ];

      when(() => mockController.state).thenReturn(
        EcosystemState(
          status: EcosystemLoadingStatus.success,
          ecosystems: ecosystems,
          selectedIndex: 0,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('¿Qué mundo exploraremos hoy?'), findsOneWidget);
      expect(find.text('Bosque Andino'), findsWidgets);
      expect(find.text('EXPLORAR'), findsOneWidget);
    });

    testWidgets('initialEcosystemId selects the specified ecosystem directly', (tester) async {
      final ecosystems = [
        const Ecosystem(
          id: 1,
          code: 'BOSQUE_ANDINO',
          name: 'Bosque Andino',
          description: 'El hogar del oso de anteojos y palmas.',
          isActive: true,
        ),
        const Ecosystem(
          id: 2,
          code: 'PARAMO',
          name: 'El Páramo',
          description: 'Frailejones y lagunas sagradas.',
          isActive: true,
        ),
      ];

      when(() => mockController.state).thenReturn(
        EcosystemState(
          status: EcosystemLoadingStatus.success,
          ecosystems: ecosystems,
          selectedIndex: 1,
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<EcosystemController>.value(
          value: mockController,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: EcosystemSelectorScreen(
              initialEcosystemId: 2,
              onExploreEcosystem: (_) {},
              onOpenProfile: () {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('El Páramo'), findsWidgets);
    });
  });
}
