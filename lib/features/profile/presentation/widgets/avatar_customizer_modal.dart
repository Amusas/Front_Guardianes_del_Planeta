import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/avatar_config.dart';
import '../../domain/models/avatar_catalog.dart';
import 'child_avatar_widget.dart';

enum AvatarCategory { character, background, accessory, expression }

/// Modal interactivo para que el niño personalice su avatar guardián.
class AvatarCustomizerModal extends StatefulWidget {
  final AvatarConfig initialConfig;
  final int childLevel;
  final String childName;
  final ValueChanged<AvatarConfig> onSave;

  const AvatarCustomizerModal({
    super.key,
    required this.initialConfig,
    required this.childLevel,
    required this.childName,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required AvatarConfig initialConfig,
    required int childLevel,
    required String childName,
    required ValueChanged<AvatarConfig> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AvatarCustomizerModal(
        initialConfig: initialConfig,
        childLevel: childLevel,
        childName: childName,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AvatarCustomizerModal> createState() => _AvatarCustomizerModalState();
}

class _AvatarCustomizerModalState extends State<AvatarCustomizerModal> {
  late AvatarConfig _currentConfig;
  AvatarCategory _selectedCategory = AvatarCategory.character;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.initialConfig;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxModalHeight = mediaQuery.size.height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxModalHeight),
      decoration: const BoxDecoration(
        color: AppColors.pastelGreenBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle superior
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.mediumGrey,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
          ),

          // Header con título y botón cerrar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.pastelGreenBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.palette_rounded, color: AppColors.forestGreen, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Personaliza tu Avatar', style: AppTypography.headingMedium),
                        Text(
                          'Crea tu estilo guardián único',
                          style: AppTypography.caption.copyWith(color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.darkGrey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.pastelGreen),

          // Contenido principal scrolleable
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.space20),
              child: Column(
                children: [
                  // 1. Vista previa interactiva grande del Avatar
                  _buildAvatarPreview(),

                  const SizedBox(height: AppDimensions.space20),

                  // 2. Selector de categoría (Personaje, Fondo, Accesorio, Expresión)
                  _buildCategorySelector(),

                  const SizedBox(height: AppDimensions.space16),

                  // 3. Grid de opciones según la categoría seleccionada
                  _buildOptionsGrid(),
                ],
              ),
            ),
          ),

          // Barra inferior con botón Guardar
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.pastelGreen, width: 1.5),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Anillo de brillo decorativo
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.pastelGreenBg,
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
              ),

              // Avatar dinámico en vivo
              ChildAvatarWidget(
                config: _currentConfig,
                size: 114,
                borderWidth: 4,
              ),

              // Badge de nivel superpuesto
              Positioned(
                bottom: 0,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                    border: Border.all(color: AppColors.white, width: 2),
                    boxShadow: AppShadows.small,
                  ),
                  child: Text(
                    'Nv. ${widget.childLevel}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.childName,
            style: AppTypography.subheading.copyWith(
              color: AppColors.forestGreenDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            _getSummaryText(),
            style: AppTypography.caption.copyWith(color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }

  String _getSummaryText() {
    final char = AvatarCatalog.characters.firstWhere((c) => c.id == _currentConfig.characterId, orElse: () => AvatarCatalog.characters.first);
    final acc = AvatarCatalog.accessories.firstWhere((a) => a.id == _currentConfig.accessoryId, orElse: () => AvatarCatalog.accessories.first);
    return '${char.name} • ${acc.name}';
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _categoryChip(AvatarCategory.character, '🐾 Guardián', Icons.pets_rounded),
          const SizedBox(width: 8),
          _categoryChip(AvatarCategory.background, '🎨 Color', Icons.color_lens_rounded),
          const SizedBox(width: 8),
          _categoryChip(AvatarCategory.accessory, '👑 Accesorio', Icons.military_tech_rounded),
          const SizedBox(width: 8),
          _categoryChip(AvatarCategory.expression, '✨ Expresión', Icons.sentiment_satisfied_alt_rounded),
        ],
      ),
    );
  }

  Widget _categoryChip(AvatarCategory category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = category),
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.forestGreen : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          border: Border.all(
            color: isSelected ? AppColors.forestGreen : AppColors.lightGrey,
            width: 1.5,
          ),
          boxShadow: isSelected ? AppShadows.small : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? AppColors.white : AppColors.forestGreenDark),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.white : AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid() {
    switch (_selectedCategory) {
      case AvatarCategory.character:
        return _buildItemsList(
          items: AvatarCatalog.characters,
          selectedId: _currentConfig.characterId,
          onSelect: (id) => setState(() => _currentConfig = _currentConfig.copyWith(characterId: id)),
          previewBuilder: (opt) => ChildAvatarWidget(
            config: _currentConfig.copyWith(characterId: opt.id),
            size: 48,
            showBorder: false,
            showShadow: false,
          ),
        );

      case AvatarCategory.background:
        return _buildItemsList(
          items: AvatarCatalog.backgrounds,
          selectedId: _currentConfig.backgroundId,
          onSelect: (id) => setState(() => _currentConfig = _currentConfig.copyWith(backgroundId: id)),
          previewBuilder: (opt) => Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: ChildAvatarWidget.getGradientColors(opt.id),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.white, width: 2),
            ),
          ),
        );

      case AvatarCategory.accessory:
        return _buildItemsList(
          items: AvatarCatalog.accessories,
          selectedId: _currentConfig.accessoryId,
          onSelect: (id) => setState(() => _currentConfig = _currentConfig.copyWith(accessoryId: id)),
          previewBuilder: (opt) => ChildAvatarWidget(
            config: _currentConfig.copyWith(accessoryId: opt.id),
            size: 48,
            showBorder: false,
            showShadow: false,
          ),
        );

      case AvatarCategory.expression:
        return _buildItemsList(
          items: AvatarCatalog.expressions,
          selectedId: _currentConfig.expressionId,
          onSelect: (id) => setState(() => _currentConfig = _currentConfig.copyWith(expressionId: id)),
          previewBuilder: (opt) => ChildAvatarWidget(
            config: _currentConfig.copyWith(expressionId: opt.id),
            size: 48,
            showBorder: false,
            showShadow: false,
          ),
        );
    }
  }

  Widget _buildItemsList({
    required List<AvatarOption> items,
    required String selectedId,
    required ValueChanged<String> onSelect,
    required Widget Function(AvatarOption) previewBuilder,
  }) {
    return Column(
      children: items.map((opt) {
        final isSelected = opt.id == selectedId;
        final isLocked = widget.childLevel < opt.requiredLevel;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.forestGreen.withOpacity(0.08) : AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: isSelected
                  ? AppColors.forestGreen
                  : isLocked
                      ? AppColors.lightGrey
                      : AppColors.pastelGreen,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: AppShadows.small,
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  previewBuilder(opt),
                  if (isLocked)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_rounded, color: Colors.white, size: 22),
                    ),
                ],
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      opt.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: isLocked ? AppColors.darkGrey : AppColors.darkText,
                      ),
                    ),
                  ),
                  if (isLocked)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.goldLight,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                      child: Text(
                        'Nv. ${opt.requiredLevel}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Text(
                isLocked ? 'Se desbloquea al alcanzar el nivel ${opt.requiredLevel}' : opt.description,
                style: TextStyle(
                  fontSize: 12,
                  color: isLocked ? AppColors.darkGrey : AppColors.forestGreenDark,
                ),
              ),
              trailing: isSelected
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.emerald,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                    )
                  : null,
              onTap: isLocked
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('¡Sube al nivel ${opt.requiredLevel} para desbloquear "${opt.name}"!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: AppColors.forestGreenDark,
                        ),
                      );
                    }
                  : () => onSelect(opt.id),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppDimensions.space20, 12, AppDimensions.space20, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, -3),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkGrey,
                  side: const BorderSide(color: AppColors.lightGrey, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCELAR', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 2,
                ),
                icon: const Icon(Icons.check_circle_rounded, size: 20),
                label: const Text(
                  'GUARDAR AVATAR',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
                onPressed: () {
                  widget.onSave(_currentConfig);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.stars_rounded, color: AppColors.gold),
                          SizedBox(width: 10),
                          Text('¡Avatar guardado con éxito!'),
                        ],
                      ),
                      backgroundColor: AppColors.forestGreenDark,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
