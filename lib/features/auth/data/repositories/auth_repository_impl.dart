import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  @override
  Future<UserResponseDto> registerGuardian(String username, String password) {
    final request = UserRegisterRequest(
      username: username,
      password: password,
      role: UserRole.GUARDIAN,
    );
    return _remoteDataSource.registerGuardian(request);
  }

  @override
  Future<AuthResponseDto> login(String username, String password) {
    final request = UserLoginRequest(username: username, password: password);
    return _remoteDataSource.login(request);
  }
}
