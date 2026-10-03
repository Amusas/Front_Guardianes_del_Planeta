import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../core/widgets/confetti_overlay.dart';
import '../widgets/educational_illustration.dart';
import '../widgets/interactive_option_card.dart';
import '../../domain/models/activity_question_model.dart';

class InteractiveActivityScreen extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onActivityComplete;

  const InteractiveActivityScreen({
    super.key,
    required this.onClose,
    required this.onActivityComplete,
  });

  @override
  State<InteractiveActivityScreen> createState() => _InteractiveActivityScreenState();
}

class _InteractiveActivityScreenState extends State<InteractiveActivityScreen> {
  final ActivityQuestionModel _question = const ActivityQuestionModel(
    id: 'q3',
    questionNumber: 3,
    totalQuestions: 5,
    scenarioTitle: 'Río Contaminado',
    questionTitle: '¿Qué deberíamos utilizar para limpiar el río y proteger a los peces?',
    hint: 'Piensa en una herramienta que pueda recoger residuos plásticos flotantes directamente del agua sin dañar a los peces.',
    options: [
      ActivityOptionModel(
        id: 'opt_a',
        text: 'Red de limpieza para recoger residuos flotantes',
        icon: Icons.filter_alt_rounded,
        isCorrect: true,
        feedback: '¡Excelente elección! La red permite extraer plásticos sin dañar a los seres acuáticos.',
      ),
      ActivityOptionModel(
        id: 'opt_b',
        text: 'Contenedor de reciclaje dentro del agua',
        icon: Icons.delete_sweep_rounded,
        isCorrect: false,
        feedback: 'El contenedor va en la orilla, dentro del río estorbaría a los peces.',
      ),
      ActivityOptionModel(
        id: 'opt_c',
        text: 'Lupa para observar los microorganismos',
        icon: Icons.search_rounded,
        isCorrect: false,
        feedback: 'La lupa ayuda a investigar, pero necesitamos retirar la basura primero.',
      ),
    ],
  );

  String? _selectedOptionId;
  bool? _isCorrect;
  bool _showConfetti = false;
  bool _showHintModal = false;

  void _selectOption(ActivityOptionModel option) {
    if (_isCorrect == true) return; // Ya resuelto correctamente

    setState(() {
      _selectedOptionId = option.id;
      _isCorrect = option.isCorrect;
      if (option.isCorrect) {
        _showConfetti = true;
      }
    });
  }

  OptionState _getOptionState(ActivityOptionModel option) {
    if (_selectedOptionId == null) return OptionState.normal;
    if (_selectedOptionId == option.id) {
      if (_isCorrect == true) return OptionState.correct;
      if (_isCorrect == false) return OptionState.incorrect;
      return OptionState.selected;
    }
    return OptionState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final double progressRatio = _question.questionNumber / _question.totalQuestions;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // 1. Header con progreso y botón de cerrar/pausa
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space12,
                  ),
                  child: Row(
                    children: [
                      // Botón cerrar / pausa
                      InkWell(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        onTap: widget.onClose,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.small,
                          ),
                          child: const Icon(Icons.close_rounded, color: AppColors.darkGrey, size: 24),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space16),

                      // Barra de progreso verde brillante
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pregunta ${_question.questionNumber} de ${_question.totalQuestions}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.forestGreenDark,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(Icons.energy_savings_leaf_rounded, color: AppColors.emerald, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      '+50 XP',
                                      style: TextStyle(
                                        color: AppColors.forestGreenDark,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progressRatio,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.emeraldLight, AppColors.emerald],
                                    ),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.emerald.withOpacity(0.4),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Contenido Scrollable con Ilustración Central y Pregunta
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ilustración educativa del escenario
                        EducationalIllustration(isCleaned: _isCorrect == true),

                        const SizedBox(height: AppDimensions.space16),

                        // Pregunta educativa
                        Text(
                          _question.questionTitle,
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.darkText,
                            fontSize: 19,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.space16),

                        // Opciones interactivas A, B, C
                        for (int i = 0; i < _question.options.length; i++) ...[
                          InteractiveOptionCard(
                            option: _question.options[i],
                            letter: String.fromCharCode(65 + i), // A, B, C
                            state: _getOptionState(_question.options[i]),
                            onTap: () => _selectOption(_question.options[i]),
                          ),
                        ],

                        const SizedBox(height: 120), // Espacio para el bottom sheet flotante
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Mascota / Bottom Sheet redondeado en la parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: _isCorrect == true ? const Color(0xFFE8F5E9) : AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLarge),
                  topRight: Radius.circular(AppDimensions.radiusLarge),
                ),
                boxShadow: AppShadows.card,
                border: Border.all(
                  color: _isCorrect == true ? AppColors.emerald : AppColors.pastelGreen,
                  width: 2,
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mascota Guardián con animación reactiva
                    MascotWidget(
                      size: 78,
                      expression: _isCorrect == true
                          ? MascotExpression.celebrating
                          : _isCorrect == false
                              ? MascotExpression.thinking
                              : MascotExpression.happy,
                    ),

                    const SizedBox(width: AppDimensions.space12),

                    // Globo de diálogo y botón PISTA o CONTINUAR
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: _isCorrect == true
                                  ? AppColors.pastelGreen
                                  : AppColors.pastelGreenBg,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                              border: Border.all(
                                color: _isCorrect == true ? AppColors.emerald : AppColors.pastelGreen,
                              ),
                            ),
                            child: Text(
                              _isCorrect == true
                                  ? '¡Gran trabajo, Guardián! Has protegido el río (+50 XP ganados)'
                                  : _isCorrect == false
                                      ? '¡Casi! Inténtalo de nuevo, los peces confían en ti.'
                                      : '¡Limpia el agua para que los peces puedan nadar!',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.forestGreenDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          const SizedBox(height: AppDimensions.space8),

                          Row(
                            children: [
                              // Botón PISTA
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.forestGreen,
                                  side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                icon: const Icon(Icons.lightbulb_rounded, color: AppColors.goldDark, size: 18),
                                label: const Text(
                                  'PISTA',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showHintModal = true;
                                  });
                                },
                              ),

                              const Spacer(),

                              // Botón CONTINUAR si acertó
                              if (_isCorrect == true)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.emerald,
                                    foregroundColor: AppColors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                                    ),
                                  ),
                                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                                  label: const Text(
                                    'CONTINUAR',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                                  ),
                                  onPressed: widget.onActivityComplete,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Modal de Pista
          if (_showHintModal)
            Container(
              color: Colors.black45,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(AppDimensions.space32),
                  padding: const EdgeInsets.all(AppDimensions.space24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lightbulb_rounded, color: AppColors.gold, size: 48),
                      const SizedBox(height: 12),
                      const Text(
                        'Pista del Guardián',
                        style: AppTypography.headingMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _question.hint,
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: '¡ENTENDIDO!',
                        variant: AppButtonVariant.primary,
                        height: 48,
                        onPressed: () {
                          setState(() {
                            _showHintModal = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 5. Overlay de Confeti y Partículas celebratorias (+50 XP animado)
          if (_showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: Stack(
                  children: [
                    ConfettiOverlay(
                      onComplete: () {
                        setState(() {
                          _showConfetti = false;
                        });
                      },
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                          boxShadow: AppShadows.goldGlow,
                          border: Border.all(color: AppColors.white, width: 3),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, color: AppColors.white, size: 36),
                            SizedBox(width: 8),
                            Text(
                              '+50 XP',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
