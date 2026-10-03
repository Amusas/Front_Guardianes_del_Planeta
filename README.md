# 🌍 Guardianes del Planeta — Aplicación Móvil Educativa y Gamificada

Aplicación móvil desarrollada en **Flutter & Dart** orientada a la educación ambiental para niños de 7 a 12 años, con panel de control para padres y tutores.

---

## 🚀 Características Principales

* **Estilo Visual**: *"Playful Environmental Adventure UI"* con bordes de 20–28 px, sombras suaves y estética inmersiva inspirada en videojuegos casuales.
* **100% Iconos Vectoriales**: Sin uso de emojis; cada elemento usa iconos redondeados de Material Symbols / Icons y gráficos CustomPainter.
* **Mascota Dinámica ("El Guardián")**: Mascota con 6 expresiones animadas que acompaña al jugador en sus actividades.
* **Clean Architecture & SOLID**: Código desacoplado en capas (`core/`, `features/`, `domain/`, `presentation/`, `data/`).
* **5 Pantallas de Alta Fidelidad**:
  1. **Selector de Ecosistemas**: Carrusel snap-scroll con islas flotantes isométricas en 3D (Bosque Andino, El Páramo, Océano) y fondos dinámicos.
  2. **Ruta de Exploración**: Sendero sinuoso continuo con nodos interactivos (completado, activo con pulsación, bloqueado con candado).
  3. **Actividad Educativa Interactiva**: Escenario del Río Contaminado, opciones interactivas con estados (hover/pressed 0.96, selected, correct, incorrect), confeti y recompensa de +50 XP.
  4. **Perfil y Recompensas**: Anillo circular de XP (65%), estadísticas de progreso, cuadrícula de 2 columnas de insignias y modal de detalle.
  5. **Panel Familiar (Padres)**: Dashboard sobrio con resumen de lecciones, tiempo de uso, conceptos, gráfico semanal de actividad Lunes-Domingo y timeline cronológico.

---

## 🛠️ Ejecución y Pruebas

Para correr la aplicación en emulador o dispositivo móvil:

```bash
# Obtener paquetes y dependencias
flutter pub get

# Ejecutar pruebas automatizadas
flutter test

# Correr la aplicación
flutter run
```

---

## 📱 Selector Rápido de Pantallas
Para facilitar la revisión y prototipado visual de las 5 pantallas, la aplicación incluye una barra de navegación flotante en la esquina inferior derecha que permite alternar directamente entre cada una de las 5 experiencias o seguir el flujo de juego normal.
