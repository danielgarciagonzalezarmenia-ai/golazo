# GOLAZO — Aprende fútbol jugando

App iOS 100% offline para aprender fútbol jugando. Desarrollada con Flutter.

## Pantallas
- **Camino**: mapa de aprendizaje con nodos desbloqueables por nivel
- **Lección**: 10 tipos de ejercicios (opción múltiple, verdadero/falso, posición en campo, ordenar jugada, unir parejas, completar frase, escenario táctico, formación, decisión del árbitro, rápido o muerto)
- **Vestuario**: inventario de potenciadores y cosméticos (camisetas, balones, estadios, títulos)
- **Ligas/Logros**: medallas y estadísticas
- **Perfil/Ajustes**: apodo, racha, XP, sonido, háptica, modo oscuro

## Sistema
- Racha diaria con protección (escudo)
- 5 vidas (balones) que se regeneran cada 30 min
- XP y niveles (6 niveles: Potrero → Leyenda)
- Cofres diarios por racha con premios de rareza común a legendaria
- Notificaciones locales con la voz de Chispa
- Todo se guarda localmente en el dispositivo

## Requisitos
- iOS 13+
- iPhone
- Apple ID gratuito (para instalar con Sideloadly)

## Instalación en iPhone

1. Descargar **Sideloadly** (https://sideloadly.io) e instalar **Apple Devices** o iTunes de apple.com (el de Microsoft Store no vale).
2. Conectar el iPhone por USB, desbloquear y pulsar **Confiar**.
3. **Ajustes > Privacidad y seguridad > Modo desarrollador** → activar → reiniciar el iPhone.
4. Arrastrar el `.ipa` a Sideloadly, escribir el **Apple ID** (gratuito, no hace falta cuenta de desarrollador) y **Start**; introducir el código 2FA.
5. **Ajustes > General > VPN y gestión de dispositivos > Desarrollador de la app > Confiar**.
6. Abrir la app y conceder permisos.

### Límites de la firma gratuita
- Caduca a los **7 días**
- Máximo **3 apps** por Apple ID
- Renovar volviendo a pasar el `.ipa` por Sideloadly (conserva datos) o usar **SideStore**
- **TrollStore no sirve** en iOS 26/27

## Compilación
El `.ipa` se compila sin firmar en GitHub Actions (macOS) mediante el workflow `.github/workflows/ios-build.yml`. La firma se realiza localmente con Sideloadly y Apple ID gratuito.

## Desarrollado con
- Flutter 3.41.9
- Dart 3.11.5
- Sin cuentas, sin servidores, sin analítica, sin anuncios. 100% local.
