import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/main.dart';
import 'package:guardianes_del_planeta/features/auth/presentation/controllers/auth_controller.dart';
import 'package:guardianes_del_planeta/features/auth/presentation/screens/auth_screen.dart';
import 'package:guardianes_del_planeta/features/auth/data/models/auth_models.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/controllers/guardian_dashboard_controller.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/screens/guardian_dashboard_screen.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/state/guardian_dashboard_state.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/controllers/ecosystem_controller.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/state/ecosystem_state.dart';
import 'package:guardianes_del_planeta/features/navigation/main_navigator.dart';

class MockAuthController extends Mock implements AuthController {}
class MockGuardianDashboardController extends Mock implements GuardianDashboardController {}
class MockEcosystemController extends Mock implements EcosystemController {}

void main() {
  late MockAuthController mockAuthController;
  late MockGuardianDashboardController mockGuardianController;
  late MockEcosystemController mockEcosystemController;

  setUp(() {
    mockAuthController = MockAuthController();
    mockGuardianController = MockGuardianDashboardController();
    mockEcosystemController = MockEcosystemController();

    when(() => mockAuthController.isLoading).thenReturn(false);
    when(() => mockAuthController.errorMessage).thenReturn(null);

    when(() => mockGuardianController.state).thenReturn(
      const GuardianDashboardState(status: GuardianDashboardStatus.empty),
    );
    when(() => mockGuardianController.loadDashboard()).thenAnswer((_) async {});

    when(() => mockEcosystemController.state).thenReturn(
      const EcosystemState(status: EcosystemLoadingStatus.empty, ecosystems: []),
    );
    when(() => mockEcosystemController.loadEcosystems(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: mockAuthController),
        ChangeNotifierProvider<GuardianDashboardController>.value(value: mockGuardianController),
        ChangeNotifierProvider<EcosystemController>.value(value: mockEcosystemController),
      ],
      child: const MaterialApp(
        home: RootScreen(),
      ),
    );
  }

  group('RootScreen Role Redirection Tests', () {
    testWidgets('renders loading indicator when authState is initial', (tester) async {
      when(() => mockAuthController.authState).thenReturn(AuthState.initial);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders AuthScreen when unauthenticated', (tester) async {
      when(() => mockAuthController.authState).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('renders GuardianDashboardScreen directly when authenticated as GUARDIAN', (tester) async {
      when(() => mockAuthController.authState).thenReturn(AuthState.authenticated);
      when(() => mockAuthController.userRole).thenReturn(UserRole.GUARDIAN);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(GuardianDashboardScreen), findsOneWidget);
      expect(find.byType(MainNavigator), findsNothing);
    });

    testWidgets('renders MainNavigator directly when authenticated as CHILD', (tester) async {
      when(() => mockAuthController.authState).thenReturn(AuthState.authenticated);
      when(() => mockAuthController.userRole).thenReturn(UserRole.CHILD);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(MainNavigator), findsOneWidget);
      expect(find.byType(GuardianDashboardScreen), findsNothing);
    });
  });
}
