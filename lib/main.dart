import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/logging/app_logger.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_token_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/ecosystems/data/datasources/ecosystem_remote_data_source.dart';
import 'features/ecosystems/data/repositories/ecosystem_repository_impl.dart';
import 'features/ecosystems/domain/usecases/get_active_ecosystems_use_case.dart';
import 'features/ecosystems/presentation/controllers/ecosystem_controller.dart';
import 'features/exploration/data/datasources/lesson_remote_data_source.dart';
import 'features/exploration/data/repositories/lesson_repository_impl.dart';
import 'features/exploration/domain/usecases/complete_lesson_use_case.dart';
import 'features/exploration/domain/usecases/get_child_completed_lessons_use_case.dart';
import 'features/exploration/domain/usecases/get_lessons_by_ecosystem_use_case.dart';
import 'features/exploration/presentation/controllers/lesson_controller.dart';
import 'features/activity/data/datasources/activity_remote_data_source.dart';
import 'features/activity/data/repositories/activity_repository_impl.dart';
import 'features/activity/domain/usecases/get_activities_by_lesson_use_case.dart';
import 'features/activity/domain/usecases/submit_activity_attempt_use_case.dart';
import 'features/activity/presentation/controllers/activity_controller.dart';
import 'features/guardian_dashboard/data/datasources/guardian_dashboard_remote_data_source.dart';
import 'features/guardian_dashboard/data/repositories/guardian_dashboard_repository_impl.dart';
import 'features/guardian_dashboard/domain/usecases/get_guardian_children_use_case.dart';
import 'features/guardian_dashboard/domain/usecases/get_guardian_child_dashboard_use_case.dart';
import 'features/guardian_dashboard/domain/usecases/register_child_for_guardian_use_case.dart';
import 'features/auth/data/models/auth_models.dart';
import 'features/guardian_dashboard/presentation/controllers/guardian_dashboard_controller.dart';
import 'features/guardian_dashboard/presentation/screens/guardian_dashboard_screen.dart';
import 'features/profile/data/datasources/child_profile_remote_data_source.dart';
import 'features/profile/data/repositories/child_profile_repository_impl.dart';
import 'features/profile/domain/usecases/get_my_child_profile_use_case.dart';
import 'features/profile/domain/usecases/get_my_child_achievements_use_case.dart';
import 'features/profile/domain/usecases/get_all_achievements_use_case.dart';
import 'features/profile/presentation/controllers/child_profile_controller.dart';
import 'features/navigation/main_navigator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final secureStorage = SecureTokenStorage();
  final apiClient = ApiClient(tokenStorage: secureStorage);
  final authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

  // Ecosistemas dependencies
  final ecosystemRemoteDataSource = EcosystemRemoteDataSourceImpl(apiClient: apiClient);
  final ecosystemRepository = EcosystemRepositoryImpl(remoteDataSource: ecosystemRemoteDataSource);
  final getActiveEcosystemsUseCase = GetActiveEcosystemsUseCase(ecosystemRepository);

  // Lecciones / Ruta dependencies
  final lessonRemoteDataSource = LessonRemoteDataSourceImpl(apiClient: apiClient);
  final lessonRepository = LessonRepositoryImpl(remoteDataSource: lessonRemoteDataSource);
  final getLessonsByEcosystemUseCase = GetLessonsByEcosystemUseCase(lessonRepository);
  final completeLessonUseCase = CompleteLessonUseCase(lessonRepository);
  final getChildCompletedLessonsUseCase = GetChildCompletedLessonsUseCase(lessonRepository);

  // Actividades dependencies
  final activityRemoteDataSource = ActivityRemoteDataSourceImpl(apiClient: apiClient);
  final activityRepository = ActivityRepositoryImpl(remoteDataSource: activityRemoteDataSource);
  final getActivitiesByLessonUseCase = GetActivitiesByLessonUseCase(activityRepository);
  final submitActivityAttemptUseCase = SubmitActivityAttemptUseCase(activityRepository);

  // Guardian Dashboard dependencies
  final guardianRemoteDataSource = GuardianDashboardRemoteDataSourceImpl(apiClient: apiClient);
  final guardianRepository = GuardianDashboardRepositoryImpl(remoteDataSource: guardianRemoteDataSource);
  final getGuardianChildrenUseCase = GetGuardianChildrenUseCase(guardianRepository);
  final getGuardianChildDashboardUseCase = GetGuardianChildDashboardUseCase(guardianRepository);
  final registerChildForGuardianUseCase = RegisterChildForGuardianUseCase(guardianRepository);

  // Child Profile dependencies
  final childProfileRemoteDataSource = ChildProfileRemoteDataSourceImpl(apiClient: apiClient);
  final childProfileRepository = ChildProfileRepositoryImpl(remoteDataSource: childProfileRemoteDataSource);
  final getMyChildProfileUseCase = GetMyChildProfileUseCase(childProfileRepository);
  final getMyChildAchievementsUseCase = GetMyChildAchievementsUseCase(childProfileRepository);
  final getAllAchievementsUseCase = GetAllAchievementsUseCase(childProfileRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(
            repository: authRepository,
            tokenStorage: secureStorage,
          )..checkSession(),
        ),
        ChangeNotifierProvider(
          create: (_) => EcosystemController(
            getActiveEcosystemsUseCase: getActiveEcosystemsUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LessonController(
            getLessonsByEcosystemUseCase: getLessonsByEcosystemUseCase,
            completeLessonUseCase: completeLessonUseCase,
            getChildCompletedLessonsUseCase: getChildCompletedLessonsUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ActivityController(
            getActivitiesByLessonUseCase: getActivitiesByLessonUseCase,
            submitActivityAttemptUseCase: submitActivityAttemptUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GuardianDashboardController(
            getChildrenUseCase: getGuardianChildrenUseCase,
            getChildDashboardUseCase: getGuardianChildDashboardUseCase,
            registerChildUseCase: registerChildForGuardianUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ChildProfileController(
            getMyChildProfileUseCase: getMyChildProfileUseCase,
            getMyChildAchievementsUseCase: getMyChildAchievementsUseCase,
            getAllAchievementsUseCase: getAllAchievementsUseCase,
          ),
        ),
      ],
      child: const GuardianesDelPlanetaApp(),
    ),
  );
}

class GuardianesDelPlanetaApp extends StatelessWidget {
  const GuardianesDelPlanetaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardianes del Planeta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final authState = authController.authState;

    if (authState == AuthState.initial) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authState == AuthState.authenticated) {
      if (authController.userRole == UserRole.GUARDIAN) {
        return const GuardianDashboardScreen();
      } else {
        return const MainNavigator();
      }
    }

    return const AuthScreen();
  }
}
