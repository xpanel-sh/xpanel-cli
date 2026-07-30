# XPanel CLI

CLI común para los productos XPanel, escrita en Bash para Linux.

El comando siempre se llama:

```bash
xpanel
```

`xpanel-cli` es código compartido de consola. No convierte Core, Host y Pod en un único sistema ni crea una dependencia entre ellos.

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

## Instalación

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
