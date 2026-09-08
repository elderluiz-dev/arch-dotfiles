import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

PanelWindow {
    id: window
    
    screen: Quickshell.screens[0]
    visible: true

    anchors {
        top: true
        right: true
    }
    margins {
        top: 36
        right: 16
    }

    // Aumentado proporcionalmente (Largura: 370px, Altura: 450px)
    width: 370
    height: 450
    color: "transparent"

    Process {
        id: runner
    }

    function execCmd(cmd) {
        runner.command = ["sh", "-c", cmd]
        runner.running = true
    }

    property var activePlayer: Mpris.players.values[0] || null

    // Container Principal
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.04, 0.04, 0.05, 0.96)
        radius: 14
        border.color: Qt.rgba(1.0, 1.0, 1.0, 0.2)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 16

            // Cabeçalho
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Quick Settings"
                    color: "#FFFFFF"
                    font.pixelSize: 15
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 13
                    color: closeMouse.containsMouse ? Qt.rgba(1.0, 1.0, 1.0, 0.2) : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "#AAAAAA"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: window.visible = false
                    }
                }
            }

            // Grid de Botões Rápidos (Wi-Fi / Bluetooth)
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Bluetooth
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 52
                    radius: 10
                    color: btMouse.containsMouse ? Qt.rgba(1.0, 1.0, 1.0, 0.15) : Qt.rgba(1.0, 1.0, 1.0, 0.04)
                    border.color: btMouse.containsMouse ? "#FFFFFF" : Qt.rgba(1.0, 1.0, 1.0, 0.12)

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        Text { text: "󰂯"; color: "#FFFFFF"; font.pixelSize: 18 }
                        Text { text: "Bluetooth"; color: "#FFFFFF"; font.pixelSize: 13; font.bold: true }
                    }

                    MouseArea {
                        id: btMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            execCmd("blueman-manager &")
                            window.visible = false
                        }
                    }
                }

                // Wi-Fi
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 52
                    radius: 10
                    color: wifiMouse.containsMouse ? Qt.rgba(1.0, 1.0, 1.0, 0.15) : Qt.rgba(1.0, 1.0, 1.0, 0.04)
                    border.color: wifiMouse.containsMouse ? "#FFFFFF" : Qt.rgba(1.0, 1.0, 1.0, 0.12)

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        Text { text: "󰤨"; color: "#FFFFFF"; font.pixelSize: 18 }
                        Text { text: "Wi-Fi"; color: "#FFFFFF"; font.pixelSize: 13; font.bold: true }
                    }

                    MouseArea {
                        id: wifiMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            execCmd("alacritty -e nmtui &")
                            window.visible = false
                        }
                    }
                }
            }

            // Slider de Volume Customizado
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                RowLayout {
                    Text { text: "󰕾  Volume"; color: "#DDDDDD"; font.pixelSize: 12; font.bold: true }
                    Item { Layout.fillWidth: true }
                    Text { text: Math.round(volSlider.value) + "%"; color: "#888888"; font.pixelSize: 11 }
                }

                Slider {
                    id: volSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 70
                    onMoved: {
                        let vol = (value / 100).toFixed(2)
                        execCmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ " + vol)
                    }

                    background: Rectangle {
                        x: volSlider.leftPadding
                        y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 8
                        width: volSlider.availableWidth
                        height: implicitHeight
                        radius: 4
                        color: Qt.rgba(1.0, 1.0, 1.0, 0.08)

                        Rectangle {
                            width: volSlider.visualPosition * parent.width
                            height: parent.height
                            color: "#FFFFFF"
                            radius: 4
                        }
                    }

                    handle: Rectangle {
                        x: volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width)
                        y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                        implicitWidth: 18
                        implicitHeight: 18
                        radius: 9
                        color: "#121214"
                        border.color: "#FFFFFF"
                        border.width: 2
                    }
                }
            }

            // Card do Player de Mídia Redimensionado
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 90
                radius: 10
                color: Qt.rgba(1.0, 1.0, 1.0, 0.03)
                border.color: Qt.rgba(1.0, 1.0, 1.0, 0.1)

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    // Capa do Álbum / Ícone Maior
                    Rectangle {
                        implicitWidth: 54
                        implicitHeight: 54
                        radius: 8
                        color: Qt.rgba(1.0, 1.0, 1.0, 0.06)
                        border.color: Qt.rgba(1.0, 1.0, 1.0, 0.15)
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: activePlayer && activePlayer.trackArtUrl ? activePlayer.trackArtUrl : ""
                            fillMode: Image.PreserveAspectCrop
                            visible: status === Image.Ready
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "󰎈"
                            color: "#FFFFFF"
                            font.pixelSize: 22
                            visible: !activePlayer || !activePlayer.trackArtUrl || parent.children[0].status !== Image.Ready
                        }
                    }

                    // Informações e Controles
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Text {
                            Layout.fillWidth: true
                            text: activePlayer && activePlayer.trackTitle ? activePlayer.trackTitle : "Sem mídia"
                            color: "#FFFFFF"
                            font.pixelSize: 12
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.fillWidth: true
                            text: activePlayer && activePlayer.trackArtist ? activePlayer.trackArtist : "Tocador inativo"
                            color: "#888888"
                            font.pixelSize: 11
                            elide: Text.ElideRight
                        }

                        // Controles
                        RowLayout {
                            spacing: 16

                            // Retroceder
                            Text {
                                text: "󰒮"
                                color: prevMouse.containsMouse ? "#FFFFFF" : "#AAAAAA"
                                font.pixelSize: 16

                                MouseArea {
                                    id: prevMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: if (activePlayer) activePlayer.previous()
                                }
                            }

                            // Play / Pause
                            Text {
                                text: activePlayer && activePlayer.isPlaying ? "󰏤" : "󰐊"
                                color: playMouse.containsMouse ? "#FFFFFF" : "#AAAAAA"
                                font.pixelSize: 16

                                MouseArea {
                                    id: playMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: if (activePlayer) activePlayer.togglePlaying()
                                }
                            }

                            // Avançar
                            Text {
                                text: "󰒭"
                                color: nextMouse.containsMouse ? "#FFFFFF" : "#AAAAAA"
                                font.pixelSize: 16

                                MouseArea {
                                    id: nextMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: if (activePlayer) activePlayer.next()
                                }
                            }
                        }
                    }
                }
            }

            // Botões de Ação de Energia Redimensionados
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Bloquear
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 44
                    radius: 10
                    color: lockMouse.containsMouse ? Qt.rgba(1.0, 1.0, 1.0, 0.2) : Qt.rgba(1.0, 1.0, 1.0, 0.05)
                    border.color: lockMouse.containsMouse ? "#FFFFFF" : Qt.rgba(1.0, 1.0, 1.0, 0.12)

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text { text: "󰌾"; color: "#FFFFFF"; font.pixelSize: 15 }
                        Text { text: "Bloquear"; color: "#FFFFFF"; font.pixelSize: 12; font.bold: true }
                    }

                    MouseArea {
                        id: lockMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            execCmd("hyprlock &")
                            window.visible = false
                        }
                    }
                }

                // Desligar
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 44
                    radius: 10
                    color: powerMouse.containsMouse ? Qt.rgba(1.0, 1.0, 1.0, 0.2) : Qt.rgba(1.0, 1.0, 1.0, 0.05)
                    border.color: powerMouse.containsMouse ? "#FFFFFF" : Qt.rgba(1.0, 1.0, 1.0, 0.12)

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text { text: "󰐥"; color: "#FFFFFF"; font.pixelSize: 15 }
                        Text { text: "Desligar"; color: "#FFFFFF"; font.pixelSize: 12; font.bold: true }
                    }

                    MouseArea {
                        id: powerMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: execCmd("systemctl poweroff")
                    }
                }
            }
        }
    }
}
