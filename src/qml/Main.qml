import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    width: 480
    height: 320
    visible: true
    title: "Qt VNC Demo"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "Clicked " + counter.count + " times"
            font.pixelSize: 20
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Click me"
            onClicked: counter.count++
        }
    }

    QtObject {
        id: counter
        property int count: 0
    }
}
