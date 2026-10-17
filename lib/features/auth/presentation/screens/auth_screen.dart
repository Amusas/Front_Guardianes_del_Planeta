import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/auth_controller.dart';
import '../../data/models/auth_models.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/controllers/guardian_dashboard_controller.dart';
import '../widgets/planet_earth_logo.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final controller = context.read<AuthController>();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final bool success;
    if (_isLogin) {
      success = await controller.login(username, password);
    } else {
      success = await controller.registerAndLogin(username, password);
    }

    if (success && mounted) {
      if (controller.userRole == UserRole.GUARDIAN) {
        try {
          context.read<GuardianDashboardController>().loadDashboard();
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.pastelGreenBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PlanetEarthLogo(size: 140),
                const SizedBox(height: AppDimensions.space24),
                Text(
                  'Guardianes del Planeta',
                  style: AppTypography.displayMedium.copyWith(color: AppColors.forestGreen),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  _isLogin ? '¡Bienvenido, Guardián o Explorador!' : 'Crea tu cuenta de acudiente',
                  style: AppTypography.subheading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.space32),
                
                Card(
                  elevation: 0,
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.borderRadiusCard,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.space24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (authController.errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.errorSoft.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                authController.errorMessage!,
                                style: TextStyle(color: AppColors.errorSoft),
                              ),
                            ),
                          
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre de usuario',
                              hintText: 'Usuario de acudiente o niño',
                              hintStyle: TextStyle(
                                color: AppColors.mediumGrey.withOpacity(0.55),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (val) {
                              final text = val?.trim();
                              if (text == null || text.isEmpty) return 'El usuario es obligatorio.';
                              if (!_isLogin && text.length < 3) return 'Mínimo 3 caracteres.';
                              if (!_isLogin && text.length > 50) return 'Máximo 50 caracteres.';
                              return null;
                            },
                          ),
                          const SizedBox(height: AppDimensions.space16),
                          
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Tu contraseña secreta',
                              hintStyle: TextStyle(
                                color: AppColors.mediumGrey.withOpacity(0.55),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'La contraseña es obligatoria.';
                              if (!_isLogin && val.length < 6) return 'Debe tener al menos 6 caracteres.';
                              return null;
                            },
                          ),
                          
                          if (!_isLogin) ...[
                            const SizedBox(height: AppDimensions.space16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: 'Confirmar contraseña',
                                hintText: 'Repite tu contraseña',
                                hintStyle: TextStyle(
                                  color: AppColors.mediumGrey.withOpacity(0.55),
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(Icons.lock_reset),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Confirma tu contrase\u00f1a.';
                                if (val != _passwordController.text) return 'Las contrase\u00f1as no coinciden.';
                                return null;
                              },
                            ),
                          ],
                          
                          const SizedBox(height: AppDimensions.space32),
                          
                          AppButton(
                            label: _isLogin ? 'Iniciar sesi\u00f3n' : 'Crear cuenta',
                            isLoading: authController.isLoading,
                            onPressed: _submit,
                          ),
                          
                          const SizedBox(height: AppDimensions.space16),
                          
                          TextButton(
                            onPressed: authController.isLoading ? null : _toggleMode,
                            child: Text(
                              _isLogin ? '\u00bfNo tienes cuenta? Crea una' : 'Ya tengo cuenta. Iniciar sesi\u00f3n',
                              style: TextStyle(
                                color: AppColors.forestGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
