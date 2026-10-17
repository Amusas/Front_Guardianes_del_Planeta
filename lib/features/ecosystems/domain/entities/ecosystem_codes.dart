class EcosystemCodes {
  EcosystemCodes._();

  static const String bosqueAndino = 'BOSQUE_ANDINO';
  static const String paramo = 'PARAMO';
  static const String oceano = 'OCEANO';
  static const String selvaAmazonica = 'SELVA_AMAZONICA';
  static const String manglar = 'MANGLAR';
  static const String bosqueSecoTropical = 'BOSQUE_SECO_TROPICAL';
  static const String llanosSabana = 'LLANOS_SABANA';

  static const List<String> allCodes = [
    bosqueAndino,
    paramo,
    oceano,
    selvaAmazonica,
    manglar,
    bosqueSecoTropical,
    llanosSabana,
  ];

  static String getDisplayName(String code) {
    switch (code.toUpperCase()) {
      case bosqueAndino:
        return 'Bosque Andino';
      case paramo:
        return 'Páramo';
      case oceano:
        return 'Océano';
      case selvaAmazonica:
        return 'Selva Amazónica';
      case manglar:
        return 'Manglar';
      case bosqueSecoTropical:
        return 'Bosque Seco Tropical';
      case llanosSabana:
        return 'Llanos y Sabana';
      default:
        return code;
    }
  }
}
