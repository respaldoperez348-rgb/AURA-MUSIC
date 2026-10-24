import QtQuick
import Quickshell
import Quickshell.Wayland
import "components"

ShellRoot {
    id: root

    Theme {
        id: globalTheme
    }

    property bool musicPlayerOpen: true

    IpcHandler {
        target: "musicplayer"

        function toggle(): void {
            root.musicPlayerOpen = !root.musicPlayerOpen;
        }
        function open(): void {
            root.musicPlayerOpen = true;
        }
        function close(): void {
            root.musicPlayerOpen = false;
        }
        function autoNext(): void {
            if (musicPlayerContainer) musicPlayerContainer.autoNext();
        }
        function next(): void {
            if (musicPlayerContainer) musicPlayerContainer.playNextSong(true);
        }
        function prev(): void {
            if (musicPlayerContainer) musicPlayerContainer.playPreviousSong(true);
        }
        function togglePlay(): void {
            if (musicPlayerContainer) musicPlayerContainer.togglePlay();
        }
    }

    PanelWindow {
        id: musicPlayerPanel
        screen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        visible: root.musicPlayerOpen

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.musicPlayerOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        color: "transparent"

        mask: Region {
            item: musicPlayerContainer.card
        }

        BackgroundEffect.blurRegion: Region {
            item: musicPlayerContainer.card
        }

        MusicPlayer {
            id: musicPlayerContainer
            theme: globalTheme
            isOpen: root.musicPlayerOpen
            anchors.fill: parent
            onCloseRequested: root.musicPlayerOpen = false
        }
    }
}
