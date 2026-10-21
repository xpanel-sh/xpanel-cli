# Registro de cambios

Los cambios importantes de XPanel CLI se documentarán aquí. El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y las versiones estables seguirán [Versionado Semántico](https://semver.org/lang/es/).

## [Sin publicar]

- No hay cambios funcionales en la CLI en la tanda `0.2.0-beta.1` de VPS y Host. El comando `xpanel update --force` mantiene su comportamiento actual; no se le asigna una versión nueva sin modificarlo.

## [0.1.0-alpha.2] - Hito de desarrollo retrospectivo

Los hitos `alpha.1` y `alpha.2` organizan los cambios existentes; no afirman que haya etiquetas publicadas.

- `xpanel update --force` respalda los cambios rastreados como parche binario antes de restaurarlos; nunca elimina archivos no rastreados y también admite el alias explícito `--discard-local-changes`.
- El actualizador ejecuta cada producto desde su propio directorio para que los procesos sin acceso a `/root` nunca hereden ese directorio de trabajo.
- El comando global detecta automáticamente Host, VM o Pod bajo `/opt` aunque se ejecute desde otro directorio.
- Las operaciones privilegiadas se elevan internamente, por lo que el usuario ejecuta `xpanel update` sin anteponer `sudo`.
- Los ejecutables se versionan con su modo correcto para que la instalación no deje cambios locales que bloqueen actualizaciones.
- El comando global resuelve su destino real antes de cargar `lib/`, incluso cuando se ejecuta mediante `/usr/local/bin/xpanel`.

## [0.1.0-alpha.1] - Hito de desarrollo retrospectivo

### Añadido

- Detección del producto y de su raíz desde distintos contextos de ejecución.
- Comandos base y mensajes en español e inglés.
- Actualizador protegido por árbol limpio y avance `fast-forward`.
- Actualización propia de la CLI y prueba de humo del flujo de actualización.

### Seguridad

- Los comandos destructivos permanecen deshabilitados hasta contar con recuperación segura.

[Sin publicar]: https://github.com/xpanel-sh/xpanel-cli/commits/main
