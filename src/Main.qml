import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
ApplicationWindow {
    id: win
    width: 760; height: 620; minimumWidth: 560; minimumHeight: 500
    visible: true; title: qsTr("Tomphone"); color: "#101114"
    Material.theme: Material.Dark; Material.accent: theme.accent; Material.roundedScale: theme.radius
    property bool settingsOpen: !backend.configured
    Shortcut { sequence: "Q"; context: Qt.ApplicationShortcut; onActivated: Qt.quit() }
    Shortcut { sequence: "Space"; context: Qt.ApplicationShortcut; onActivated: backend.inCall ? backend.hangup() : backend.call() }
    Shortcut { sequence: "Escape"; context: Qt.ApplicationShortcut; onActivated: settingsOpen = false }
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 30; spacing: 22
        RowLayout { Layout.fillWidth: true
            ColumnLayout { spacing: 3
                Label { text: qsTr("TOMPHONE"); font.pixelSize: 13; font.weight: Font.Bold; color: theme.accent; font.letterSpacing: 2 }
                Label { text: qsTr("Softphone"); font.pixelSize: 28; font.weight: Font.DemiBold }
            }
            Item { Layout.fillWidth: true }
            ToolButton { text: "⚙"; font.pixelSize: 23; onClicked: settingsOpen = !settingsOpen; Accessible.name: qsTr("Account settings") }
        }
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true; radius: theme.radius; color: "#191a1f"
            ColumnLayout {
                anchors.centerIn: parent; width: Math.min(parent.width - 48, 470); spacing: 20
                Rectangle { Layout.alignment: Qt.AlignHCenter; width: 76; height: 76; radius: 38; color: "#25262b"
                    Label { anchors.centerIn: parent; text: "☎"; color: theme.accent; font.pixelSize: 34 }
                }
                Label { Layout.alignment: Qt.AlignHCenter; text: backend.status; font.pixelSize: 24; font.weight: Font.Medium }
                Label { Layout.alignment: Qt.AlignHCenter; text: backend.details; color: "#a5a6ac"; elide: Text.ElideRight; Layout.maximumWidth: parent.width; horizontalAlignment: Text.AlignHCenter }
                TextField { id: number; Layout.fillWidth: true; visible: backend.configured; placeholderText: qsTr("Number or SIP address"); text: backend.number; onTextChanged: backend.number = text; onAccepted: backend.call() }
                RowLayout { Layout.alignment: Qt.AlignHCenter; spacing: 12
                    Button { visible: backend.inCall && backend.status === "Incoming call"; text: qsTr("Answer"); highlighted: true; onClicked: backend.answer() }
                    Button { visible: backend.configured && !backend.inCall; text: qsTr("Call"); highlighted: true; enabled: number.text.length > 0; onClicked: backend.call() }
                    Button { visible: backend.inCall; text: qsTr("Hang up"); onClicked: backend.hangup() }
                    Button { visible: backend.inCall; text: qsTr("Mute"); onClicked: backend.toggleMute() }
                }
                Button { Layout.alignment: Qt.AlignHCenter; visible: backend.configured && !backend.running; text: qsTr("Start phone"); onClicked: backend.start() }
            }
        }
        Label { Layout.alignment: Qt.AlignHCenter; text: qsTr("Space to call or hang up     ·     Q to quit"); color: "#777980"; font.pixelSize: 12 }
    }
    Popup {
        id: accountDialog; anchors.centerIn: Overlay.overlay; width: Math.min(win.width - 40, 480); padding: 26
        modal: true; focus: true; closePolicy: Popup.CloseOnEscape
        background: Rectangle { color: "#202126"; radius: theme.radius; border.color: "#34353b" }
        ColumnLayout { width: parent.width; spacing: 12
            Label { text: qsTr("SIP account"); font.pixelSize: 22; font.weight: Font.DemiBold }
            Label { text: qsTr("Your credentials are stored in a private local config file."); color: "#a5a6ac"; wrapMode: Text.WordWrap; Layout.fillWidth: true }
            TextField { id: server; Layout.fillWidth: true; placeholderText: qsTr("SIP server, e.g. sip.example.com") }
            TextField { id: user; Layout.fillWidth: true; placeholderText: qsTr("Username") }
            TextField { id: password; Layout.fillWidth: true; placeholderText: qsTr("Password"); echoMode: TextInput.Password }
            RowLayout { Layout.fillWidth: true
                Button { visible: backend.configured; text: qsTr("Forget account"); onClicked: { backend.forgetAccount(); accountDialog.close() } }
                Item { Layout.fillWidth: true }
                Button { text: qsTr("Cancel"); onClicked: accountDialog.close() }
                Button { text: qsTr("Save account"); highlighted: true; onClicked: { backend.saveAccount(server.text, user.text, password.text); accountDialog.close() } }
            }
        }
    }
    Connections { target: win; function onSettingsOpenChanged() { if (win.settingsOpen) accountDialog.open() } }
    Component.onCompleted: if (settingsOpen) accountDialog.open()
}
