import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/theme/app_theme.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/controllers/guardian_dashboard_controller.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/state/guardian_dashboard_state.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/widgets/create_child_modal.dart';

class MockGuardianDashboardController extends Mock implements GuardianDashboardController {}

void main() {
  late MockGuardianDashboardController mockController;

  setUp(() {
    mockController = MockGuardianDashboardController();
    when(() => mockController.state).thenReturn(const GuardianDashboardState());
    when(() => mockController.clearCreationError()).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => CreateChildModal.show(context, mockController),
            child: const Text('Abrir Modal'),
          ),
        ),
      ),
    );
  }

  group('CreateChildModal Widget Tests', () {
    testWidgets('renders all required form fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Abrir Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Nuevo Perfil Infantil'), findsOneWidget);
      expect(find.text('Nombre del niño'), findsOneWidget);
      expect(find.text('Nombre de usuario del niño'), findsOneWidget);
      expect(find.text('Fecha de nacimiento'), findsOneWidget);
      expect(find.text('Contraseña del niño'), findsOneWidget);
      expect(find.text('Confirmar contraseña'), findsOneWidget);
      expect(find.text('Crear Perfil Infantil'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Abrir Modal'));
      await tester.pumpAndSettle();

      // Tap submit with empty fields
      await tester.tap(find.text('Crear Perfil Infantil'));
      await tester.pumpAndSettle();

      expect(find.text('El nombre es obligatorio'), findsOneWidget);
      expect(find.text('El nombre de usuario es obligatorio'), findsOneWidget);
      expect(find.text('La contraseña es obligatoria'), findsOneWidget);
    });

    testWidgets('shows validation error when passwords do not match', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Abrir Modal'));
      await tester.pumpAndSettle();

      // Enter name and username
      await tester.enterText(find.widgetWithText(TextFormField, 'Nombre del niño'), 'Lucía');
      await tester.enterText(find.widgetWithText(TextFormField, 'Nombre de usuario del niño'), 'lucia123');
      await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña del niño'), 'clave123');
      await tester.enterText(find.widgetWithText(TextFormField, 'Confirmar contraseña'), 'claveDiferente');

      await tester.tap(find.text('Crear Perfil Infantil'));
      await tester.pumpAndSettle();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });

    testWidgets('disables button when creation is in progress to prevent duplicate submission', (tester) async {
      when(() => mockController.state).thenReturn(
        const GuardianDashboardState(isCreatingChild: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Abrir Modal'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // In loading state, button shows CircularProgressIndicator and onPressed is null
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton).last);
      expect(elevatedButton.onPressed, isNull);
    });
  });
}
