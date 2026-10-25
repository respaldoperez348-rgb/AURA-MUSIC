#!/bin/bash
# ==============================================================================
# Aura Music - Script de Instalación Automatizada (Nueva Arquitectura Studio Deck)
# ==============================================================================
set -e

BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}"
echo "    ___                          __  __           _      "
echo "   /   | __  ___________ _      / / / /_  _______(_)____ "
echo "  / /| |/ / / / ___/ __ \`/_____/ /_/ / / / / ___/ / ___/ "
echo " / ___ / /_/ / /  / /_/ /_____/ __  / /_/ (__  ) / /__   "
echo "/_/  |_\__,_/_/   \__,_/     /_/ /_/\__,_/____/_/\___/   "
echo -e "${RESET}"
echo -e "${BOLD}Instalador Automatizado de Aura Music Studio Deck para Hyprland / Wayland${RESET}\n"

# 1. Comprobación de Dependencias
echo -e "${CYAN}[1/4]${RESET} Verificando dependencias del sistema..."
DEPS=("quickshell" "mpv" "yt-dlp" "python3")
MISSING=()

for dep in "${DEPS[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
        MISSING+=("$dep")
    else
        echo -e "  ${GREEN}✓${RESET} $dep encontrado"
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}Faltan algunas dependencias requeridas:${RESET} ${MISSING[*]}"
    if command -v pacman &>/dev/null; then
        read -p "¿Deseas instalarlas ahora con pacman? (s/N): " -r
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            sudo pacman -S --needed "${MISSING[@]}"
        else
            echo -e "${RED}Instala las dependencias faltantes para continuar.${RESET}"
            exit 1
        fi
    else
        echo -e "${RED}Por favor, instala: ${MISSING[*]}${RESET}"
        exit 1
    fi
fi

# 2. Configurar carpetas destino
QS_DIR="$HOME/.config/quickshell"
YTDLP_DIR="$HOME/.config/yt-dlp"

echo -e "\n${CYAN}[2/4]${RESET} Desplegando archivos en $QS_DIR..."
mkdir -p "$QS_DIR/core"
mkdir -p "$QS_DIR/components"
mkdir -p "$YTDLP_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copiar Core Daemon, Componentes y UI
cp -rf "$SCRIPT_DIR/core/"* "$QS_DIR/core/"
cp -rf "$SCRIPT_DIR/components/"*.qml "$QS_DIR/components/"
cp -f "$SCRIPT_DIR/Theme.qml" "$QS_DIR/Theme.qml" 2>/dev/null || true
cp -f "$SCRIPT_DIR/shell.qml" "$QS_DIR/shell.qml" 2>/dev/null || true

# Copiar configuración de yt-dlp (evita HTTP 403 de YouTube)
if [ -f "$SCRIPT_DIR/config/yt-dlp/config" ]; then
    if [ -f "$YTDLP_DIR/config" ]; then
        if ! grep -q "player-client=android" "$YTDLP_DIR/config"; then
            echo '--extractor-args "youtube:player-client=android"' >> "$YTDLP_DIR/config"
            echo -e "  ${GREEN}✓${RESET} Se añadió cliente Android a ~/.config/yt-dlp/config existente"
        fi
    else
        cp -v "$SCRIPT_DIR/config/yt-dlp/config" "$YTDLP_DIR/config"
        echo -e "  ${GREEN}✓${RESET} Se creó ~/.config/yt-dlp/config"
    fi
fi

# Copiar favoritos por defecto si no existen
if [ ! -f "$QS_DIR/favorites.json" ] && [ -f "$SCRIPT_DIR/favorites.json" ]; then
    cp -v "$SCRIPT_DIR/favorites.json" "$QS_DIR/favorites.json"
fi

# 3. Permisos
echo -e "\n${CYAN}[3/4]${RESET} Ajustando permisos de ejecución..."
chmod +x "$QS_DIR/core/"*.py 2>/dev/null || true
echo -e "  ${GREEN}✓${RESET} Permisos otorgados."

# 4. Información de integración
echo -e "\n${CYAN}[4/4]${RESET} ${GREEN}${BOLD}¡Instalación completada con éxito!${RESET}\n"
echo -e "${BOLD}Integración sugerida para Hyprland (~/.config/hypr/hyprland.conf o binds.conf):${RESET}"
echo -e "${YELLOW}bind = \$mainMod, Y, exec, quickshell ipc call musicplayer toggle${RESET}\n"
echo -e "${BOLD}Para probar de forma independiente:${RESET}"
echo -e "${CYAN}quickshell -p $SCRIPT_DIR/shell.qml${RESET}\n"
