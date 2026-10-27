# 🎵 AURA MUSIC

<div align="center">

![Aura Music Banner](https://raw.githubusercontent.com/respaldoperez348-rgb/hypr-abyss/main/assets/banner.png)

**Reproductor de música flotante, ultra-rápido y con estética Frosted Glass para Quickshell y Wayland (Hyprland / Sway).**

[![Wayland](https://img.shields.io/badge/Wayland-Hyprland%20%7C%20Sway-blue?logo=wayland&logoColor=white)](#)
[![Quickshell](https://img.shields.io/badge/UI-Quickshell%20%28Qt6%20QML%29-ff69b4)](#)
[![MPV + yt-dlp](https://img.shields.io/badge/Engine-MPV%20%2B%20yt--dlp-red?logo=youtube&logoColor=white)](#)
[![Audio](https://img.shields.io/badge/Audio-PipeWire%20%2F%20PulseAudio-purple)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## ✨ Características Principales

- 🎨 **Estética Studio Deck & Frosted Glass**: Renderizado con `Quickshell` en Qt 6 / QML con arquitectura panorámica de dos módulos, disco de vinilo animado, espectro de audio neón y desenfoque nativo.
- 🚀 **Core Backend Persistente & Ultra-Ligero**: Daemon en Python con control instantáneo por socket UNIX directo con MPV y streaming asíncrono vía `yt-dlp`.
- 🛡️ **Bypass Anti-Bot HTTP 403**: Configuración integrada con extractor Android para evitar bloqueos del servidor y desconexiones de YouTube en streams de audio.
- ⚡ **IPC Bidireccional en Tiempo Real**: Cero scripts de bash y cero timers ciegos. Eventos empujados por memoria con respuesta inferior a 50 milisegundos.
- 🔁 **Gestor de Cola y Auto-Advance**: Reproducción continua inteligente sin silencios entre pistas.
- ⭐ **Biblioteca de Favoritos con Vector Heart**: Guarda y administra tus canciones preferidas con un clic sincronizado en JSON local.
- 🎛️ **Iconografía Vectorial & Tipografía Nativa**: Integración completa con `JetBrainsMono Nerd Font` e iconos vectoriales puros sin dependencias de fuentes de emojis.

---

## 📦 Requisitos Previos

Asegúrate de contar con los siguientes paquetes en tu sistema Arch Linux u otra distribución con Wayland:

```bash
# Arch Linux
sudo pacman -S --needed quickshell mpv yt-dlp python
```

> **Nota para el Audio**: Se recomienda usar `pipewire` y `pipewire-pulse` para máxima estabilidad y baja latencia.

---

## 🚀 Instalación Rápida

1. **Clona el repositorio:**
   ```bash
   git clone https://github.com/respaldoperez348-rgb/AURA-MUSIC.git
   cd AURA-MUSIC
   ```

2. **Ejecuta el instalador automático:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

El instalador copiará los componentes y scripts en `~/.config/quickshell/` y configurará `~/.config/yt-dlp/config` con los argumentos de extracción óptimos.

---

## ⌨️ Integración con Hyprland

Añade los siguientes atajos en tu archivo `~/.config/hypr/hyprland.conf` (o en tu archivo de `binds`):

```ini
# Abrir / Cerrar Aura Music Flotante
bind = $mainMod, Y, exec, quickshell ipc call musicplayer toggle

# Detener reproducción por completo y cerrar
bind = $mainMod, R, exec, ~/.config/quickshell/scripts/music_control.sh quit; quickshell ipc call musicplayer close

# Atajos multimedia opcionales
bind = , XF86AudioPlay, exec, quickshell ipc call musicplayer togglePlay
bind = , XF86AudioNext, exec, quickshell ipc call musicplayer next
bind = , XF86AudioPrev, exec, quickshell ipc call musicplayer prev
```

---

## 🛠️ Arquitectura del Proyecto

```
AURA-MUSIC/
├── components/
│   └── MusicPlayer.qml       # Componente UI principal en QML (interfaz, listas, animaciones)
├── scripts/
│   ├── music_play.sh         # Daemon y despachador de MPV con reintentos y batch IPC
│   ├── music_control.sh      # Acciones rápidas (play, pause, seek, volume, quit)
│   ├── music_search.py       # Motor de búsqueda y generación de mixes infinitos con yt-dlp
│   ├── favorites.py          # Gestor de biblioteca y almacenamiento local
│   └── mpv_next.lua          # Hook Lua de MPV para cambio automático al terminar track
├── config/
│   └── yt-dlp/
│       └── config            # Configuración extractor Android (anti 403 Forbidden)
├── shell.qml                 # Root de Quickshell para ejecución standalone
├── Theme.qml                 # Paleta de colores y variables de estilo
├── favorites.json            # Base de datos local de favoritos
└── install.sh                # Script de instalación de un solo paso
```

---

## 💡 Solución de Problemas (Troubleshooting)

- **¿La música se detiene al cambiar de canción?**
  Asegúrate de que `~/.config/yt-dlp/config` contenga `--extractor-args "youtube:player-client=android"`. Esto evita que YouTube corte los streams con error 403 Forbidden.
- **¿Error de conexión al socket de MPV?**
  El script `music_play.sh` arranca automáticamente el daemon MPV con el socket `/tmp/kiss_music_mpv.sock` y reintentos automáticos. Puedes forzar el reinicio con `music_control.sh quit`.

---
<img width="1175" height="719" alt="swappy-20261026_211506" src="https://github.com/user-attachments/assets/74429f0d-dd67-4deb-a8bc-ed9d1b95c3b7" />





## 📄 Licencia

Este proyecto está bajo la Licencia [MIT](LICENSE).

---

<div align="center">
Hecho con ❤️ para la comunidad de Linux y Wayland por <a href="https://github.com/respaldoperez348-rgb">David Tineo</a>
</div>
