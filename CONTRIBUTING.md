# Contribuir a XPanel CLI

Gracias por colaborar. XPanel CLI es una herramienta Bash compartida, pero cada producto XPanel continúa siendo independiente. Abre primero un issue para cambios grandes o nuevos contratos de comandos.

Al participar aceptas el [Código de conducta](CODE_OF_CONDUCT.md). Reporta vulnerabilidades mediante [SECURITY.md](SECURITY.md), no en público.

## Entorno y verificaciones

Trabaja en Linux o WSL con Bash y Git disponibles.

```bash
git clone https://github.com/xpanel-sh/xpanel-cli.git
cd xpanel-cli
bash tests/update-smoke.sh
bash -n install.sh bin/xpanel commands/*.sh lib/*.sh tests/*.sh
```

- Mantén el comportamiento seguro aunque la CLI se ejecute desde otro directorio.
- No introduzcas borrados, sobrescrituras o reinicios sin validaciones y confirmación adecuadas.
- Conserva las actualizaciones `fast-forward` y la protección del árbol de trabajo.
- Añade las claves de idioma necesarias en español e inglés.
- Actualiza pruebas y README cuando cambie un comando visible.
- No incluyas secretos, credenciales ni datos reales.

Describe en el pull request el producto y escenarios probados. Salvo indicación expresa en contrario, las contribuciones enviadas intencionalmente se ofrecen bajo la Apache License 2.0, conforme a su sección 5.
