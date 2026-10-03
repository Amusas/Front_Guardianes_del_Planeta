# 🌿 Sistema de Diseño — Guardianes del Planeta
## Estilo: "Playful Environmental Adventure UI"

Este documento contiene la especificación completa del Design System implementado en Flutter para la aplicación infantil y parental **"Guardianes del Planeta"**.

---

## 1. Fundamentos de Color (`AppColors`)

| Token | Hex | Muestra | Uso Principal |
|---|---|---|---|
| `forestGreen` | `#2D6A4F` | Verde Bosque | Botones principales, estados activos, progreso, Bosque Andino |
| `forestGreenDark`| `#1B4332` | Bosque Profundo| Encabezados oscuros, contrastes |
| `emerald` | `#52B788` | Verde Esmeralda| Elementos destacados, respuestas correctas |
| `pastelGreen` | `#D8F3DC` | Verde Pastel | Fondos secundarios, tarjetas suaves |
| `pastelGreenBg` | `#F2FBF5` | Fondo Claro | Fondo base de la experiencia infantil |
| `gold` | `#FFB703` | Dorado Solar | XP, recompensas, logros, insignias |
| `goldDark` | `#FB8500` | Ámbar Recompensa| Números de XP destacados, estrellas |
| `turquoise` | `#2A9D8F` | Azul Turquesa | Agua, ríos, actividades de conservación |
| `iceBlue` | `#A8DADC` | Azul Hielo | Páramo, climas fríos, montañas |
| `coral` | `#E76F51` | Coral Marino | Complementario Océano Pacífico |
| `pathSand` | `#F9DC5C` | Arena de Sendero| Camino serpenteante en mapa de ruta |
| `white` | `#FFFFFF` | Blanco Puro | Superficie de cards y contenedores |
| `darkText` | `#0F172A` | Azul Pizarra 900| Textos principales y números de alto contraste |

---

## 2. Tipografía (`AppTypography`)

| Categoría | Tamaño | Peso | Uso |
|---|---|---|---|
| **Display Large** | 32 px | ExtraBold (800) | Títulos principales |
| **Display Medium** | 28 px | ExtraBold (800) | Títulos de pantallas |
| **Heading Large** | 24 px | Bold (700) | Encabezados de sección |
| **Heading Medium**| 22 px | Bold (700) | Títulos de preguntas / tarjetas |
| **Subheading** | 18 px | SemiBold (600) | Subtítulos de ecosistemas |
| **Body Large** | 16 px | SemiBold (600) | Opciones de actividades |
| **Body Medium** | 15 px | Regular (400) | Descripciones y lecturas |
| **Caption** | 13 px | SemiBold (600) | Etiquetas, progreso, chips |
| **XP Counter** | 26 px | Black (900) | Marcador de XP y recompensas |

---

## 3. Formas y Bordes (`AppDimensions`)
- **Radio de tarjetas (`radiusCard`)**: `24 px` (Bordes muy redondeados y amigables).
- **Radio de diálogos (`radiusLarge`)**: `28 px`.
- **Radio de píldoras (`radiusPill`)**: `999 px`.
- **Espaciados consistentes**: Sistema en múltiplos de `4 / 8 / 12 / 16 / 24 / 32 / 40 px`.
- **Touch Targets**: Mínimo `48 px` de altura para accesibilidad en niños de 7 a 12 años.

---

## 4. Iconografía Vectorial (Sin Emojis)
Se emplean exclusivamente iconos vectoriales redondeados (`Material Symbols / Icons`):
- ⭐ XP: `Icons.star_rounded`
- 🏆 Logros e Insignias: `Icons.military_tech_rounded`, `Icons.emoji_events_rounded`
- 🔒 Bloqueado: `Icons.lock_rounded`
- 🧭 Explorar: `Icons.explore_rounded`
- 🌱 Naturaleza: `Icons.energy_savings_leaf_rounded`, `Icons.spa_rounded`
- 💧 Agua y Ríos: `Icons.water_drop_rounded`
- 🌲 Bosques: `Icons.forest_rounded`, `Icons.park_rounded`
- ♻ Reciclaje: `Icons.recycling_rounded`
- 💡 Pistas: `Icons.lightbulb_rounded`
- 👨‍👩‍👧 Panel Familiar: `Icons.family_restroom_rounded`

---

## 5. Mascota "El Guardián" (`MascotWidget`)
Mascota interactiva con 6 expresiones animadas mediante `CustomPainter`:
1. `happy`: Expresión amigable de bienvenida y guía.
2. `excited`: Entusiasmado al iniciar nuevas rutas.
3. `thinking`: Expresión pensativa cuando se pide una pista o se falla.
4. `surprised`: Asombrado ante nuevos descubrimientos ecológicos.
5. `celebrating`: Celebración con boca abierta y ojos brillantes al ganar +50 XP.
6. `encouraging`: Animando al jugador a seguir adelante.

---

## 6. Arquitectura de Pantallas
1. **Selector de Ecosistemas**: Carrusel horizontal Snap-Scroll con islas flotantes 3D isométricas (Bosque Andino, El Páramo, Océano), fondo dinámico y botón EXPLORAR.
2. **Ruta de Exploración**: Sendero serpenteante continuo (`WindingPathPainter`), nodos de lecciones (completados en oro, activo con pulso verde, bloqueados con candado) y elementos ambientales.
3. **Actividad Educativa Interactiva**: Escenario "Río contaminado", 3 opciones interactivas con compresión táctil (escala 0.96), validación verde/rojo, confeti celebratorio y Bottom Sheet de "El Guardián".
4. **Perfil y Recompensas**: XP Progress Ring (65%), Nivel 5 "Explorador Curioso", métricas destacadas y grid de insignias en 2 columnas con modal de detalle.
5. **Panel Familiar (Padres)**: Dashboard sobrio y confiable con métricas semanales, gráfica de barras Lunes-Domingo, progreso por ecosistema, timeline de actividad y navegación inferior.
