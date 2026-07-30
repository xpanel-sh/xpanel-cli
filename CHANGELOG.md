# Registro de cambios

Los cambios importantes de XPanel CLI se documentarán aquí. El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y las versiones estables seguirán [Versionado Semántico](https://semver.org/lang/es/).

## [Sin publicar]

- El comando global detecta automáticamente Host, Core o Pod bajo `/opt` aunque se ejecute desde otro directorio.
- Las operaciones privilegiadas se elevan internamente, por lo que el usuario ejecuta `xpanel update` sin anteponer `sudo`.
- Los ejecutables se versionan con su modo correcto para que la instalación no deje cambios locales que bloqueen actualizaciones.
- El comando global resuelve su destino real antes de cargar `lib/`, incluso cuando se ejecuta mediante `/usr/local/bin/xpanel`.

### Añadido

- Detección del producto y de su raíz desde distintos contextos de ejecución.
- Comandos base y mensajes en español e inglés.
- Actualizador protegido por árbol limpio y avance `fast-forward`.
- Actualización propia de la CLI y prueba de humo del flujo de actualización.

### Seguridad

- Los comandos destructivos permanecen deshabilitados hasta contar con recuperación segura.

[Sin publicar]: https://github.com/xpanel-sh/xpanel-cli/commits/main
