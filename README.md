# 🌍 Guardianes del Planeta — Aplicación Educativa Multiplataforma (Flutter)

Aplicación educativa y gamificada desarrollada en **Flutter & Dart** orientada a la educación ambiental sobre la biodiversidad de **Colombia** para niños de 7 a 12 años, con **Panel de Control en tiempo real para Acudientes**.

---

## 🚀 Funcionalidades Principales

### 1. 🔐 Autenticación de Acudientes y Gestión de Perfiles Infantiles
- **Inicio de Sesión y Registro de Acudientes**: Vistas gamificadas con insignia vectorial personalizada del Guardián del Planeta, validación de formularios y manejo de sesión segura con `FlutterSecureStorage` (JWT).
- **Vinculación y Cambio Rápido de Perfiles Infantiles**: Creación de perfiles de niños desde el panel del acudiente y selector activo de niño para sincronizar automáticamente todo el progreso, recompensas y métricas.

### 2. 🌿 Exploración de los 7 Ecosistemas de Colombia y 280 Actividades
- **Selector Interactivo de Ecosistemas (Carrusel 3D)**: Islas flotantes isométricas ilustradas con `CustomPainter` para las 7 biorregiones de Colombia:
  1. `BOSQUE_ANDINO` — Bosque Andino (Oso de Anteojos y Palma de Cera)
  2. `PARAMO` — El Páramo (Frailejones, Laguna Glaciar y Cóndor)
  3. `OCEANO` — Océanos Caribe y Pacífico (Arrecife Coralino y Tortuga Marina)
  4. `SELVA_AMAZONICA` — Selva Amazónica (Río Amazonas, Delfín Rosado y Danta)
  5. `MANGLAR` — Manglares Colombianos (Raíces Zancudas y Cangrejo Azul)
  6. `BOSQUE_SECO_TROPICAL` — Bosque Seco Tropical (Guayacán, Tití Cabeciblanco e Iguana)
  7. `LLANOS_SABANA` — Llanos Orientales y Sabana (Morichales y Chigüiro)
- **Ruta de Exploración (`ExplorationRouteScreen`)**: Sendero sinuoso continuo con 8 lecciones progresivas por ecosistema (56 lecciones en total), preservando el ecosistema seleccionado al regresar.
- **Motor Polimórfico de Actividades Interactivas (`ActivityWidgetFactory`)**: 5 actividades por lección (**280 actividades en total**) distribuidas en 5 mecánicas dinámicas:
  - **Opción Múltiple (`MultipleChoiceActivityWidget`)**
  - **Verdadero o Falso (`TrueFalseActivityWidget`)**
  - **Clasificación en Categorías (`ClassificationActivityWidget`)**
  - **Ordenamiento de Secuencias (`OrderingActivityWidget`)**
  - **Asociación / Drag & Drop Autoajustable (`DragAndDropActivityWidget`)**

### 3. 🏆 Progreso, Personalización de Avatar y Dashboard del Acudiente
- **Gamificación Infantil (`ProfileRewardsScreen`)**: Barra y anillo de experiencia (XP), subida de nivel con pantalla de celebración y confeti (`ConfettiOverlay`), racha de días consecutivos y colección de insignias ecológicas.
- **Personalizador de Avatar (`AvatarCustomizerModal`)**: Tienda y vestidor interactivo de sombreros, gafas, accesorios, trajes, fondos y compañeros ecológicos desbloqueables por nivel de Guardián.
- **Dashboard Familiar (`ParentDashboardScreen`)**: Sincronización automática al iniciar sesión del acudiente con KPIs de XP total, racha activa, lecciones superadas, porcentaje de precisión, avance por ecosistema e historial de actividad reciente.

---

## 🏛️ Estructura del Proyecto (Feature-First Clean Architecture)

El código sigue **Clean Architecture** combinada con **SOLID**, separando el núcleo transversal (`lib/core/`) de los módulos de negocio (`lib/features/`):

```text
lib/
├── main.dart                                      # Punto de entrada y configuración de proveedores
│
├── core/                                          # 🔵 NÚCLEO TRANSVERSAL REUTILIZABLE
│   ├── config/                                    # Configuración de entorno (ApiConfig con --dart-define)
│   ├── logging/                                   # Logger centralizado de aplicación
│   ├── network/                                   # Cliente HTTP Dio + Interceptor JWT y manejo de errores
│   ├── storage/                                   # Almacenamiento seguro de sesión (FlutterSecureStorage)
│   ├── theme/                                     # Sistema de diseño (AppColors, AppTypography, AppTheme)
│   └── widgets/                                   # Componentes globales (AppButton, MascotWidget, XpBar)
│
└── features/                                      # 🟢 MÓDULOS FUNCIONALES (Data / Domain / Presentation)
    ├── auth/                                      # Registro, Login, gestión de sesión JWT y estado Auth
    │   ├── data/                                  # AuthRemoteDataSource, DTOs y AuthRepositoryImpl
    │   ├── domain/                                # AuthSession, UserEntity, casos de uso Login/Register
    │   └── presentation/                          # AuthController, LoginScreen, RegisterScreen
    │
    ├── ecosystems/                                # Catálogo de los 7 ecosistemas de Colombia
    │   ├── data/                                  # EcosystemRemoteDataSource, mappers y repositorio
    │   ├── domain/                                # EcosystemEntity, EcosystemModel y casos de uso
    │   └── presentation/                          # EcosystemSelectorScreen, EnhancedIsometricIslandPainter
    │
    ├── exploration/                               # Ruta sinuosa de las 8 lecciones por ecosistema
    │   ├── data/                                  # LessonRemoteDataSource, LessonProgressDataSource
    │   ├── domain/                                # LessonEntity y casos de uso de avance
    │   └── presentation/                          # ExplorationRouteScreen, LessonNodeWidget, WindingPathPainter
    │
    ├── activity/                                  # Motor interactivo de las 280 actividades educativas
    │   ├── data/                                  # ActivityRemoteDataSource y evaluación de intentos
    │   ├── domain/                                # ActivityModel, ActivityAttemptModel y repositorios
    │   └── presentation/                          # InteractiveActivityScreen, ActivityWidgetFactory y 5 tipos
    │
    ├── profile/                                   # Perfil infantil, XP, niveles, logros y avatar
    │   ├── data/                                  # ChildProfileRemoteDataSource y persistencia local de avatar
    │   ├── domain/                                # ChildProfileSummary, AvatarCatalog, AvatarConfig
    │   └── presentation/                          # ProfileRewardsScreen, AvatarCustomizerModal, LevelUpScreen
    │
    ├── guardian_dashboard/ & parent_dashboard/    # Panel de métricas y gestión de niños para acudientes
    │   ├── data/                                  # GuardianChildRemoteDataSource y DTOs de métricas
    │   ├── domain/                                # GuardianChildDashboardEntity y casos de uso
    │   └── presentation/                          # GuardianDashboardController y ParentDashboardScreen
    │
    └── navigation/                                # Navegador principal e integración reactiva de pestañas
        └── main_navigator.dart
```

---

## ▶️ Cómo Ejecutar la Aplicación

### 1. Instalar dependencias
```bash
flutter pub get
```

### 2. Ejecutar en Web (Chrome) o Escritorio (Windows)
Asegúrate de que el Backend esté corriendo en el puerto `8080` y ejecuta:

```bash
# Ejecutar en Google Chrome
flutter run -d chrome --dart-define=API_SCHEME=http --dart-define=API_HOST=localhost --dart-define=API_PORT=8080

# Ejecutar como aplicación nativa de Windows
flutter run -d windows --dart-define=API_SCHEME=http --dart-define=API_HOST=localhost --dart-define=API_PORT=8080
```

### 3. Ejecutar en Emulador Android
En el emulador de Android, `10.0.2.2` apunta al `localhost` de tu computador:

```bash
flutter run --dart-define=API_SCHEME=http --dart-define=API_HOST=10.0.2.2 --dart-define=API_PORT=8080
```

### 4. Ejecutar en un Celular Físico (Misma Red Wi-Fi)
1. Conecta tu celular y tu PC a la **misma red Wi-Fi** y activa la **Depuración por USB** (o inalámbrica) en el teléfono.
2. Verifica la dirección IP local de tu PC ejecutando `ipconfig` en PowerShell (por ejemplo `192.168.20.23`).
3. Ejecuta el comando indicando la IP de tu PC en `API_HOST`:

```bash
flutter run --dart-define=API_SCHEME=http --dart-define=API_HOST=192.168.20.23 --dart-define=API_PORT=8080
```

---

## 🧪 Cómo Ejecutar las Pruebas y Consultar la Cobertura

El proyecto cuenta con **222 pruebas automatizadas** (pruebas unitarias de controladores, casos de uso, repositorios, fuentes de datos remotas con `Mocktail` y pruebas funcionales de Widgets para todas las pantallas) que cubren tanto caminos felices como caminos tristes.

### Ejecutar todas las pruebas
```bash
flutter test
```

### Ejecutar las pruebas generando el reporte de cobertura (`lcov.info`)
```bash
flutter test --coverage
```

El reporte detallado se genera automáticamente en:
```text
coverage/lcov.info
```

### 📊 Métricas Actuales de Cobertura Alcanzadas
| Métrica | Resultado Alcanzado | Meta del Proyecto | Estado |
| :--- | :---: | :---: | :---: |
| **Total de Pruebas Ejecutadas** | **222 pasando (0 fallos)** | Suite completa | ✅ Superado |
| **Cobertura Global de Líneas (`LF` / `LH`)** | **90.89%** (`4,728 / 5,202` líneas) | > 85.0% | ✅ Superado |
| **Cobertura por Módulo (`core` y `features`)** | **> 84% en todos los módulos** | > 80.0% | ✅ Superado |
