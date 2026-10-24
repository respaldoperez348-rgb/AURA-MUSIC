import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Theme.qml
 * Gestor dinámico de colores y sincronización con Pywal (~/.cache/wal/colors.json)
 * Proporciona una paleta Cyberpunk / Hacker con estética frosted glass semitransparente.
 */
QtObject {
    id: root

    // ==========================================
    // Paleta Cyberpunk por defecto (Fallbacks)
    // ==========================================
    property color backgroundSolid: "#0d1117"
    property real backgroundAlpha: 0.75
    property color background: Qt.rgba(backgroundSolid.r, backgroundSolid.g, backgroundSolid.b, backgroundAlpha)
    
    // Superficies internas para tarjetas / chips
    property color surface: Qt.rgba(1.0, 1.0, 1.0, 0.04)
    property color surfaceHover: Qt.rgba(1.0, 1.0, 1.0, 0.09)
    property color surfaceActive: Qt.rgba(1.0, 1.0, 1.0, 0.14)

    // Colores de acento y neón
    property color accent: "#00ffcc"       // Cyber Cyan (color4)
    property color accentAlt: "#bd93f9"    // Neon Purple (color5)
    property color cpuColor: "#50fa7b"     // Neon Green (color2)
    property color ramColor: "#00ffcc"     // Cyan (color6)
    property color mediaColor: "#ff79c6"   // Cyber Pink (color5)
    property color warning: "#ffb86c"      // Neon Amber
    property color danger: "#ff5555"       // Cyber Red

    // Resplandor y bordes
    property color accentGlow: Qt.rgba(accent.r, accent.g, accent.b, 0.25)
    property color border: Qt.rgba(accent.r, accent.g, accent.b, 0.30)
    property color borderHover: Qt.rgba(accent.r, accent.g, accent.b, 0.75)
    property color borderSubtle: Qt.rgba(1.0, 1.0, 1.0, 0.08)

    // Tipografía
    property color text: "#f0f6fc"
    property color textDim: "#6e7681"
    // Tipografía con fallbacks elegantes para pantallas con escalado 1.5x
    property string fontFamily: "JetBrainsMono Nerd Font, JetBrains Mono, Adwaita Sans, FreeSans, sans-serif"
    property string fontMono: "JetBrainsMono Nerd Font, JetBrains Mono, Adwaita Mono, FreeMono, monospace"

    // Animaciones
    property int animDurationFast: 180
    property int animDurationNormal: 320
    property int animDurationSlow: 450
    property var animEasing: Easing.OutQuad

    // Dimensiones y métricas de la cápsula (Diseño ultradelgado y compacto)
    property int capsuleRadius: 16
    property int capsuleHeightCompact: 30
    property int capsuleHeightExpanded: 34
    property int capsulePaddingH: 10
    property int capsulePaddingV: 3

    // ==========================================
    // Lector dinámico de Pywal
    // ==========================================
    property bool pywalLoaded: false
    property string pywalPath: Quickshell.env("HOME") + "/.cache/wal/colors.json"

    function parsePywal(content) {
        if (!content || content.trim().length === 0) return;
        try {
            var data = JSON.parse(content);
            if (data.special) {
                if (data.special.background) {
                    root.backgroundSolid = data.special.background;
                }
                if (data.special.foreground) {
                    root.text = data.special.foreground;
                }
            }
            if (data.colors) {
                if (data.colors.color4) root.accent = data.colors.color4;
                if (data.colors.color5) root.accentAlt = data.colors.color5;
                if (data.colors.color8) root.textDim = data.colors.color8;
                if (data.colors.color2) root.cpuColor = data.colors.color2;
                if (data.colors.color6) root.ramColor = data.colors.color6;
                if (data.colors.color5) root.mediaColor = data.colors.color5;
            }
            root.pywalLoaded = true;
            console.log("[Quickshell Theme] Pywal colors synced successfully from:", root.pywalPath);
        } catch (err) {
            console.log("[Quickshell Theme] Note: Could not parse colors.json:", err);
        }
    }

    // Observador de archivo con recarga en caliente
    property var walFileView: FileView {
        id: walWatcher
        path: root.pywalPath
        watchChanges: true

        onFileChanged: reload()

        onLoaded: {
            root.parsePywal(walWatcher.text());
        }

        onLoadFailed: {
            // Si el archivo no existe aún, se usan los colores por defecto
            root.pywalLoaded = false;
        }
    }

    // Reintento inicial por si pywal se genera después de arrancar
    property var initTimer: Timer {
        interval: 3000
        repeat: true
        running: !root.pywalLoaded
        onTriggered: {
            walWatcher.reload();
            if (root.pywalLoaded) running = false;
        }
    }

    Component.onCompleted: {
        walWatcher.reload();
    }
}
