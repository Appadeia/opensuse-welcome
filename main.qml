import QtQuick 2.9
import QtQuick.Window 2.2
import QtWebEngine 1.8
import QtWebChannel 1.0
import me.appadeia.SysInfo 1.0

Window {
    id: root
    visible: true
    width: 800
    height: 508

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
        bridgeObject.arch = systemInfo.getArch();
        bridgeObject.os = systemInfo.getOS();
    }

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    title: qsTr("Welcome")

    SysInfo {
        id: systemInfo
    }

    QtObject {
        id: bridgeObject
        property string arch: ""
        property string os: ""

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
        url: "web/app.html"
        webChannel: bridge
    }

    WebChannel {
        id: bridge
        registeredObjects: [bridgeObject]
    }
}
