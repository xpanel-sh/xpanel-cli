<h1 align="center">XPanel CLI</h1>

<p align="center">
  Una consola común, pequeña y predecible para administrar productos XPanel<br>
  sin convertirlos en un sistema monolítico.
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache--2.0-blue" alt="Licencia Apache-2.0"></a>
  <img src="https://img.shields.io/badge/shell-Bash-4EAA25" alt="Bash">
  <img src="https://img.shields.io/badge/platform-Linux-FCC624" alt="Linux">
  <img src="https://img.shields.io/badge/status-desarrollo_activo-f59e0b" alt="Estado: desarrollo activo">
</p>

<p align="center">
  <a href="#inicio-rápido">Inicio rápido</a> ·
  <a href="#comandos-base">Comandos</a> ·
  <a href="#actualizaciones">Actualizaciones</a> ·
  <a href="CONTRIBUTING.md">Contribuir</a> ·
  <a href="SECURITY.md">Seguridad</a>
</p>

---

> [!WARNING]
> XPanel CLI está en desarrollo activo. Sus comandos destructivos permanecen deshabilitados mientras no exista un flujo de recuperación suficientemente seguro.

La CLI está escrita en Bash para Linux. El comando global siempre se llama:

```bash
xpanel
```

`xpanel-cli` es código compartido de consola. No convierte Core, Host y Pod en un único sistema ni crea una dependencia entre ellos.

## Principios

- **Un comando:** todos los productos utilizan `xpanel`.
- **Contexto local:** cada ejecución actúa únicamente sobre la raíz seleccionada.
- **Productos independientes:** Host y Pod funcionan sin Core.
- **Actualizaciones seguras:** Git debe estar limpio y solo se aceptan avances `fast-forward`.
- **Extensible:** cada producto aporta sus propios scripts de operación.

---

## Productos soportados

| Sistema detectado | Qué controla |
| --- | --- |
| `xpanel-core` | Infraestructura, planes y MicroVMs del proveedor |
| `xpanel-host` | Hosting instalado en VPS, VDS, dedicado o MicroVM |
| `xpanel-pod` | Contenedores instalados en VPS, VDS, dedicado o MicroVM |

`xpanel-vps` queda fuera del alcance actual hasta que se defina su modelo definitivo.

---

## Independencia

Cada instalación combina un producto con la CLI:

```text
xpanel-core + xpanel-cli
xpanel-host + xpanel-cli
xpanel-pod  + xpanel-cli
```

La CLI ejecuta comandos dentro del contexto local. No necesita que Core esté instalado para controlar Host o Pod.

---

## Comandos base

```bash
xpanel help
xpanel version
xpanel status
xpanel git
xpanel update
xpanel uninstall
```

Cada producto puede aportar scripts adicionales, por ejemplo `scripts/xpanel-serve.sh` o `scripts/xpanel-update.sh`.

---

## Detección del sistema

La CLI detecta el contexto en este orden:

1. variable de entorno `XPANEL_SYSTEM`;
2. archivo `xpanel` en la raíz del producto;
3. archivos conocidos como `artisan`, `go.mod` o scripts propios.

Ejemplo de marcador:

```bash
SYSTEM="xpanel-host"
REPO="github.com/xpanel-sh/xpanel-host"
VERSION="0.1.0-dev"
XPANEL_FILE_LANGUAGE="es"
```

El archivo marcador es la fuente principal y evita confundir productos que usan la misma tecnología.

---

## Inicio rápido

Durante desarrollo:

```bash
bash xpanel-cli/bin/xpanel status --root=xpanel-host
```

En una instalación real:

```bash
git clone https://github.com/xpanel-sh/xpanel-cli /opt/xpanel-cli
bash /opt/xpanel-cli/install.sh
```

El instalador crea el comando global:

```text
/usr/local/bin/xpanel
```

Normalmente el `install.sh` de Core, Host o Pod realiza este paso automáticamente. `get.xpanel.sh` también termina usando los instaladores oficiales de cada repositorio.

---

## Actualizaciones

`xpanel update` actualiza primero el repositorio de la propia CLI, reinstala su enlace global, actualiza el repositorio del producto activo y después ejecuta el proceso específico del producto cuando existe. Utiliza la rama remota configurada en cada clon; no presupone que siempre se llame `main`.

```text
CLI detecta xpanel-host
        ↓
Actualiza y reinstala xpanel-cli
        ↓
Actualiza el repositorio de Host
        ↓
Ejecuta scripts/xpanel-update.sh de Host
```

La CLI no debe actualizar todos los productos del ecosistema desde una sola instalación.

Por seguridad la operación se detiene si la CLI o el producto tienen cambios locales rastreados por Git. En producción se recomienda ejecutarla desde la raíz del producto y con privilegios administrativos:

```bash
cd /opt/xpanel-host
sudo xpanel update
```

Desde otra ubicación puede indicarse el producto explícitamente:

```bash
sudo xpanel update --root=/opt/xpanel-host
```

---

## Idioma

```bash
xpanel language es
xpanel language en
```

También puede definirse durante la instalación:

```bash
XPANEL_LANG=es bash install.sh
XPANEL_LANG=en bash install.sh
```

Idiomas iniciales: `es` y `en`.

---

## Relación con xpanel.sh

`admin.xpanel.sh` publica los productos, repositorios, versiones y canales disponibles. `get.xpanel.sh` utiliza esa información para seleccionar un instalador. Después de instalar, `xpanel-cli` trabaja localmente y no requiere una conexión permanente con el servicio central.

---

## Proyecto y comunidad

- Cambios: [CHANGELOG.md](CHANGELOG.md)
- Contribuciones: [CONTRIBUTING.md](CONTRIBUTING.md)
- Código de conducta: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- Soporte: [SUPPORT.md](SUPPORT.md)
- Reportes privados de seguridad: [SECURITY.md](SECURITY.md)

## Licencia

XPanel CLI se distribuye bajo la [Apache License 2.0](LICENSE). Los nombres y marcas de XPanel no se conceden mediante esta licencia.
