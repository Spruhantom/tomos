import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

ApplicationWindow {
    id: win
    width: 1040
    height: 760
    minimumWidth: 780
    minimumHeight: 680
    visible: true
    title: qsTr("Tomphone")
    color: theme.background

    Material.theme: theme.dark ? Material.Dark : Material.Light
    Material.accent: theme.accent
    Material.primary: theme.surface
    Material.background: theme.background
    Material.foreground: theme.foreground
    Material.roundedScale: theme.radius

    property bool settingsOpen: !backend.configured
    property var keypad: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
    property bool ready: backend.status === "Ready" || backend.status === "Registered"

    function addDigit(digit) {
        backend.number = backend.number + digit
        dialField.forceActiveFocus()
    }

    Shortcut {
        sequence: "Q"
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }
    Shortcut {
        sequence: "Space"
        context: Qt.ApplicationShortcut
        onActivated: backend.inCall ? backend.hangup() : backend.call()
    }
    Shortcut {
        sequence: "Escape"
        context: Qt.ApplicationShortcut
        onActivated: settingsOpen = false
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 250
            color: theme.surface

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 0

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    Rectangle {
                        width: 42
                        height: 42
                        radius: Math.min(13, theme.radius)
                        color: theme.accent
                        Label {
                            anchors.centerIn: parent
                            text: "☎"
                            color: theme.background
                            font.pixelSize: 23
                        }
                    }
                    ColumnLayout {
                        spacing: 1
                        Label { text: qsTr("tomphone"); font.pixelSize: 19; font.weight: Font.Bold }
                        Label { text: qsTr("DESKTOP PHONE"); font.pixelSize: 9; font.letterSpacing: 1.5; color: theme.mutedForeground }
                    }
                }

                Item { Layout.fillHeight: true; Layout.minimumHeight: 30 }

                Label {
                    text: qsTr("YOUR PHONE")
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    font.letterSpacing: 1.4
                    color: theme.mutedForeground
                    Layout.bottomMargin: 12
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 84
                    radius: theme.radius
                    color: theme.background
                    border.width: 1
                    border.color: theme.border
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 12
                        spacing: 11
                        Rectangle {
                            width: 9
                            height: 9
                            radius: 5
                            color: win.ready ? "#42c98a" : theme.mutedForeground
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            Label { text: backend.configured ? qsTr("SIP account") : qsTr("No account"); font.pixelSize: 13; font.weight: Font.DemiBold }
                            Label {
                                text: backend.configured ? backend.status : qsTr("Set up to get started")
                                color: theme.mutedForeground
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                        ToolButton {
                            text: "···"
                            font.pixelSize: 19
                            Accessible.name: qsTr("Account settings")
                            onClicked: { settingsOpen = true; accountDialog.open() }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 112
                    color: "transparent"
                    ColumnLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 7
                        Label { text: qsTr("PRIVATE BY DESIGN"); font.pixelSize: 9; font.weight: Font.Bold; font.letterSpacing: 1.1; color: theme.mutedForeground }
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Your account stays on this device. Calls are handled by Baresip.")
                            wrapMode: Text.WordWrap
                            color: theme.mutedForeground
                            font.pixelSize: 11
                            lineHeight: 1.25
                        }
                    }
                }
            }
        }

        Rectangle { Layout.fillHeight: true; Layout.preferredWidth: 1; color: theme.border }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - 72, 410)
                spacing: 22

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 5
                    Label {
                        text: backend.inCall ? qsTr("On a call") : qsTr("Make a call")
                        font.pixelSize: 29
                        font.weight: Font.DemiBold
                    }
                    Label {
                        Layout.fillWidth: true
                        text: backend.details.length ? backend.details : qsTr("Enter a number or SIP address to get connected.")
                        color: theme.mutedForeground
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }
                }

                TextField {
                    id: dialField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 62
                    placeholderText: qsTr("Phone number or SIP address")
                    text: backend.number
                    color: theme.foreground
                    placeholderTextColor: theme.mutedForeground
                    selectionColor: theme.selection
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    onTextChanged: backend.number = text
                    onAccepted: backend.call()
                    background: Rectangle {
                        color: theme.surface
                        radius: theme.radius
                        border.width: dialField.activeFocus ? 2 : 1
                        border.color: dialField.activeFocus ? theme.accent : theme.border
                    }
                }

                GridLayout {
                    Layout.alignment: Qt.AlignHCenter
                    columns: 3
                    rowSpacing: 8
                    columnSpacing: 14
                    Repeater {
                        model: win.keypad
                        delegate: Button {
                            required property string modelData
                            Layout.preferredWidth: 104
                            Layout.preferredHeight: 54
                            flat: true
                            text: modelData
                            font.pixelSize: 21
                            font.weight: Font.Medium
                            onClicked: win.addDigit(modelData)
                            background: Rectangle {
                                color: parent.down ? theme.raisedSurface : "transparent"
                                radius: theme.radius
                                border.width: parent.hovered ? 1 : 0
                                border.color: theme.border
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 14
                    Button {
                        visible: backend.configured && backend.inCall && backend.status !== "Incoming call"
                        Layout.preferredWidth: 58
                        Layout.preferredHeight: 58
                        text: backend.muted ? "◉̸" : "◉"
                        Accessible.name: backend.muted ? qsTr("Unmute microphone") : qsTr("Mute microphone")
                        onClicked: backend.toggleMute()
                        background: Rectangle { color: theme.surface; radius: theme.radius; border.width: 1; border.color: theme.border }
                    }
                    Button {
                        Layout.preferredWidth: 196
                        Layout.preferredHeight: 58
                        visible: backend.configured
                        enabled: backend.inCall || dialField.text.length > 0
                        highlighted: !backend.inCall
                        text: backend.status === "Incoming call" ? qsTr("Decline") : (backend.inCall ? qsTr("Hang up") : qsTr("Call"))
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        onClicked: backend.inCall ? backend.hangup() : backend.call()
                    }
                    Button {
                        visible: backend.configured && backend.status === "Incoming call"
                        Layout.preferredWidth: 112
                        Layout.preferredHeight: 58
                        highlighted: true
                        text: qsTr("Answer")
                        onClicked: backend.answer()
                    }
                    ToolButton {
                        visible: dialField.text.length > 0 && !backend.inCall
                        Layout.preferredWidth: 44
                        Layout.preferredHeight: 58
                        text: "⌫"
                        font.pixelSize: 22
                        Accessible.name: qsTr("Delete last digit")
                        onClicked: backend.number = backend.number.slice(0, -1)
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Space to call  ·  Q to quit")
                    color: theme.mutedForeground
                    font.pixelSize: 11
                }
            }
        }
    }

    Popup {
        id: accountDialog
        anchors.centerIn: Overlay.overlay
        width: Math.min(win.width - 40, 460)
        padding: 26
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        background: Rectangle { color: theme.surface; radius: theme.radius; border.color: theme.border }

        ColumnLayout {
            width: parent.width
            spacing: 13
            Label { text: qsTr("SIP account"); font.pixelSize: 23; font.weight: Font.DemiBold }
            Label {
                text: qsTr("Add your account details to register this phone. Credentials are stored in a private local config file.")
                color: theme.mutedForeground
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            TextField { id: server; Layout.fillWidth: true; placeholderText: qsTr("SIP server, e.g. sip.example.com"); color: theme.foreground; placeholderTextColor: theme.mutedForeground; selectionColor: theme.selection; background: Rectangle { color: theme.background; radius: theme.radius; border.color: theme.border } }
            TextField { id: user; Layout.fillWidth: true; placeholderText: qsTr("Username"); color: theme.foreground; placeholderTextColor: theme.mutedForeground; selectionColor: theme.selection; background: Rectangle { color: theme.background; radius: theme.radius; border.color: theme.border } }
            TextField { id: password; Layout.fillWidth: true; placeholderText: qsTr("Password"); echoMode: TextInput.Password; color: theme.foreground; placeholderTextColor: theme.mutedForeground; selectionColor: theme.selection; background: Rectangle { color: theme.background; radius: theme.radius; border.color: theme.border } }
            RowLayout {
                Layout.fillWidth: true
                Button { visible: backend.configured; text: qsTr("Forget account"); onClicked: { backend.forgetAccount(); accountDialog.close() } }
                Item { Layout.fillWidth: true }
                Button { text: qsTr("Cancel"); onClicked: accountDialog.close() }
                Button { text: qsTr("Save account"); highlighted: true; onClicked: { backend.saveAccount(server.text, user.text, password.text); accountDialog.close() } }
            }
        }
    }

    Component.onCompleted: if (!backend.configured) accountDialog.open()
}
