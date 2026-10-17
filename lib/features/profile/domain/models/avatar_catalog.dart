import 'avatar_config.dart';

class AvatarCatalog {
  static const List<AvatarOption> characters = [
    AvatarOption(
      id: 'explorador',
      name: 'Explorador Guardián',
      description: 'El clásico protector aventurero de la naturaleza.',
      requiredLevel: 1,
      visualKey: 'CHAR_EXPLORER',
    ),
    AvatarOption(
      id: 'oso',
      name: 'Oso de Anteojos',
      description: 'Espíritu noble del bosque andino y los páramos.',
      requiredLevel: 1,
      visualKey: 'CHAR_BEAR',
    ),
    AvatarOption(
      id: 'jaguar',
      name: 'Jaguar Dorado',
      description: 'Defensor ágil de las selvas amazónicas.',
      requiredLevel: 2,
      visualKey: 'CHAR_JAGUAR',
    ),
    AvatarOption(
      id: 'delfin',
      name: 'Delfín Rosado',
      description: 'Guardián alegre de los ríos y corrientes hídricas.',
      requiredLevel: 3,
      visualKey: 'CHAR_DOLPHIN',
    ),
    AvatarOption(
      id: 'condor',
      name: 'Cóndor Andino',
      description: 'Vigía majestuoso que surca los cielos de las cumbres.',
      requiredLevel: 4,
      visualKey: 'CHAR_CONDOR',
    ),
    AvatarOption(
      id: 'tortuga',
      name: 'Tortuga Marina',
      description: 'Protectora sabia de los arrecifes y mares.',
      requiredLevel: 5,
      visualKey: 'CHAR_TURTLE',
    ),
  ];

  static const List<AvatarOption> backgrounds = [
    AvatarOption(
      id: 'esmeralda',
      name: 'Verde Esmeralda',
      description: 'Inspirado en los valles y bosques de Colombia.',
      requiredLevel: 1,
      visualKey: 'BG_EMERALD',
    ),
    AvatarOption(
      id: 'oceano',
      name: 'Azul Océano',
      description: 'Corrientes marinas del Caribe y Pacífico.',
      requiredLevel: 1,
      visualKey: 'BG_OCEAN',
    ),
    AvatarOption(
      id: 'solar',
      name: 'Dorado Solar',
      description: 'La energía radiante del sol protector.',
      requiredLevel: 2,
      visualKey: 'BG_SOLAR',
    ),
    AvatarOption(
      id: 'orquidea',
      name: 'Orquídea Silvestre',
      description: 'Homenaje a la flor nacional y los senderos florales.',
      requiredLevel: 3,
      visualKey: 'BG_ORCHID',
    ),
    AvatarOption(
      id: 'atardecer',
      name: 'Atardecer Páramo',
      description: 'Cálidos colores sobre los frailejones al atardecer.',
      requiredLevel: 4,
      visualKey: 'BG_SUNSET',
    ),
    AvatarOption(
      id: 'menta',
      name: 'Brisa de Selva',
      description: 'Frescura cristalina de cascadas y humedales.',
      requiredLevel: 5,
      visualKey: 'BG_MINT',
    ),
  ];

  static const List<AvatarOption> accessories = [
    AvatarOption(
      id: 'none',
      name: 'Sin Accesorio',
      description: 'Tu guardián al natural.',
      requiredLevel: 1,
      visualKey: 'ACC_NONE',
    ),
    AvatarOption(
      id: 'gorra',
      name: 'Gorra de Explorador',
      description: 'Accesorio oficial para expediciones en el campo.',
      requiredLevel: 1,
      visualKey: 'ITEM_EXPLORER_CAP',
    ),
    AvatarOption(
      id: 'corona_hojas',
      name: 'Corona de Hojas',
      description: 'Corona tejida con ramas sagradas de la selva.',
      requiredLevel: 2,
      visualKey: 'ACC_LEAF_CROWN',
    ),
    AvatarOption(
      id: 'gafas',
      name: 'Gafas de Aventura',
      description: 'Ideales para observar aves y rastrear huellas.',
      requiredLevel: 3,
      visualKey: 'ACC_GOGGLES',
    ),
    AvatarOption(
      id: 'bufanda',
      name: 'Bufanda Andina',
      description: 'Tejido artesanal para protegerte del frío del páramo.',
      requiredLevel: 4,
      visualKey: 'ACC_SCARF',
    ),
    AvatarOption(
      id: 'corona_solar',
      name: 'Corona Solar',
      description: 'Distinción radiante de gran defensor del planeta.',
      requiredLevel: 5,
      visualKey: 'ITEM_SUN_CROWN',
    ),
  ];

  static const List<AvatarOption> expressions = [
    AvatarOption(
      id: 'sonriente',
      name: 'Sonriente',
      description: 'Tranquilo, atento y listo para aprender.',
      requiredLevel: 1,
      visualKey: 'EXP_SMILING',
    ),
    AvatarOption(
      id: 'feliz',
      name: 'Súper Alegre',
      description: 'Guiño y emoción por salvar la naturaleza.',
      requiredLevel: 1,
      visualKey: 'EXP_HAPPY',
    ),
    AvatarOption(
      id: 'audaz',
      name: 'Audaz',
      description: 'Mirada decidida de valiente protector.',
      requiredLevel: 2,
      visualKey: 'EXP_BRAVE',
    ),
  ];
}
