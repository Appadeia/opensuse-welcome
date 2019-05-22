import QtQuick 2.9
import QtQuick.Window 2.2
import QtWebEngine 1.8
import QtWebChannel 1.0
import Qt.labs.settings 1.0
import me.appadeia.SysInfo 1.0
import me.appadeia.Launcher 1.0

Window {
    id: root
    visible: true
    width: 800
    height: 508

    Component.onCompleted: {
        setX((Screen.width / 2 - width / 2) + 1280);
        setY(Screen.height / 2 - height / 2);
        bridgeObject.arch = systemInfo.getArch();
        bridgeObject.os = systemInfo.getOS();
        bridgeObject.de = launcher.currentDE();
    }
    Settings {
        WebChannel.id: "settings"
        id: settings
        property bool autostart: true
    }

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    title: qsTr("Welcome")

    SysInfo {
        id: systemInfo
    }

    Launcher {
        WebChannel.id: "launcher"
        id: launcher
    }

    QtObject {
        id: bridgeObject
        property string arch: ""
        property string os: ""
        property string de: ""

        WebChannel.id: "bridge"

        function changeTitle(title) {
            root.title = title;
        }
        function close() {
            root.close();
        }
        function openURL(url) {
            Qt.openUrlExternally(url)
        }

    }

    WebEngineView {
        anchors.fill: parent
        url: "web/home.html"
        webChannel: bridge
    }

    Rectangle {
        id: splash
        height: parent.height
        width: parent.width
        anchors.top: parent.top
        color: "#73ba25";
        y: 0

        Image {
            width: 340
            height: 220
            anchors.centerIn: parent
            source: "qrc:///web/images/logo.svg"
        }

        SequentialAnimation {
            running: true
            PauseAnimation {
                duration: 1500
            }

            NumberAnimation {
                target: splash
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
                from: 1
                to: 0
            }
        }
    }

    WebChannel {
        id: bridge
        registeredObjects: [bridgeObject, launcher, settings]
    }
}
