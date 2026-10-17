import '../../data/models/auth_models.dart';

abstract class AuthRepository {
  Future<UserResponseDto> registerGuardian(String username, String password);
  Future<AuthResponseDto> login(String username, String password);
}
