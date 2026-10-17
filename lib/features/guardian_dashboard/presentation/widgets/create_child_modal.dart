import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/guardian_dashboard_controller.dart';

class CreateChildModal extends StatefulWidget {
  final GuardianDashboardController controller;
  final VoidCallback? onSuccess;

  const CreateChildModal({
    super.key,
    required this.controller,
    this.onSuccess,
  });

  static Future<void> show(BuildContext context, GuardianDashboardController controller, {VoidCallback? onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CreateChildModal(controller: controller, onSuccess: onSuccess),
    );
  }

  @override
  State<CreateChildModal> createState() => _CreateChildModalState();
}

class _CreateChildModalState extends State<CreateChildModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _selectedDateOfBirth;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 8, now.month, now.day);
    final firstDate = DateTime(now.year - 18);
    final lastDate = DateTime(now.year - 3);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Selecciona la fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  Future<void> _submit() async {
    widget.controller.clearCreationError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha de nacimiento del niño'),
          backgroundColor: AppColors.errorSoft,
        ),
      );
      return;
    }

    final success = await widget.controller.registerChild(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      dateOfBirth: _selectedDateOfBirth!,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Perfil de ${_nameController.text.trim()} creado con éxito!'),
          backgroundColor: AppColors.emerald,
        ),
      );
      widget.onSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = widget.controller.state.isCreatingChild;
    final creationError = widget.controller.state.creationErrorMessage;

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 150),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nuevo Perfil Infantil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkText,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.darkGrey),
                      onPressed: isCreating ? null : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Text(
                  'Crea una cuenta para tu niño. Podrá iniciar sesión en su dispositivo con este usuario y contraseña.',
                  style: TextStyle(fontSize: 12, color: AppColors.darkGrey),
                ),
                const SizedBox(height: 16),
                if (creationError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.errorSoft.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.errorSoft.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.errorSoft),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            creationError,
                            style: const TextStyle(fontSize: 12, color: AppColors.errorSoft, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                TextFormField(
                  controller: _nameController,
                  enabled: !isCreating,
                  decoration: InputDecoration(
                    labelText: 'Nombre del niño',
                    hintText: 'Ej. Juanito',
                    hintStyle: TextStyle(
                      color: AppColors.mediumGrey.withOpacity(0.55),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.badge_rounded, color: AppColors.forestGreen),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    if (value.trim().length > 100) {
                      return 'El nombre no puede exceder los 100 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usernameController,
                  enabled: !isCreating,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario del niño',
                    hintText: 'Ej. juanito123',
                    hintStyle: TextStyle(
                      color: AppColors.mediumGrey.withOpacity(0.55),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.account_circle_rounded, color: AppColors.forestGreen),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre de usuario es obligatorio';
                    }
                    if (value.trim().length < 3 || value.trim().length > 50) {
                      return 'Debe tener entre 3 y 50 caracteres';
                    }
                    if (value.contains(' ')) {
                      return 'No puede contener espacios en blanco';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: isCreating ? null : _pickDateOfBirth,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      hintStyle: TextStyle(
                        color: AppColors.mediumGrey.withOpacity(0.55),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.cake_rounded, color: AppColors.forestGreen),
                      border: const OutlineInputBorder(),
                    ),
                    child: Text(
                      _selectedDateOfBirth != null
                          ? '${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}/${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}/${_selectedDateOfBirth!.year}'
                          : 'Toca para seleccionar',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedDateOfBirth != null ? AppColors.darkText : AppColors.mediumGrey.withOpacity(0.55),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  enabled: !isCreating,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña del niño',
                    hintText: 'Mínimo 6 caracteres',
                    hintStyle: TextStyle(
                      color: AppColors.mediumGrey.withOpacity(0.55),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.forestGreen),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es obligatoria';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  enabled: !isCreating,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    hintText: 'Repite la contraseña',
                    hintStyle: TextStyle(
                      color: AppColors.mediumGrey.withOpacity(0.55),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.forestGreen),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirma la contraseña';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isCreating ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isCreating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                        )
                      : const Text(
                          'Crear Perfil Infantil',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
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
