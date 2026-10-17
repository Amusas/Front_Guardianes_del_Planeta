import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/features/auth/presentation/screens/auth_screen.dart';
import 'package:guardianes_del_planeta/features/auth/presentation/controllers/auth_controller.dart';
import 'package:guardianes_del_planeta/core/theme/app_theme.dart';

class MockAuthController extends Mock implements AuthController {}

void main() {
  late MockAuthController mockController;

  setUp(() {
    mockController = MockAuthController();
    when(() => mockController.isLoading).thenReturn(false);
    when(() => mockController.errorMessage).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: mockController),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const AuthScreen(),
      ),
    );
  }

  group('AuthScreen Widget Tests', () {
    testWidgets('renders login screen initially', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Iniciar sesi\u00f3n'), findsWidgets);
      expect(find.text('Nombre de usuario'), findsOneWidget);
      expect(find.text('Contrase\u00f1a'), findsOneWidget);
      expect(find.text('Confirmar contrase\u00f1a'), findsNothing);
    });

    testWidgets('toggles to register screen', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('\u00bfNo tienes cuenta? Crea una'));
      await tester.pumpAndSettle();

      expect(find.text('Crear cuenta'), findsWidgets);
      expect(find.text('Confirmar contrase\u00f1a'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty on login', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Iniciar sesi\u00f3n').first);
      await tester.pump();

      expect(find.text('El usuario es obligatorio.'), findsOneWidget);
      expect(find.text('La contrase\u00f1a es obligatoria.'), findsOneWidget);
    });
  });
}
