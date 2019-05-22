import QtQuick 2.9
import QtQuick.Window 2.2
import QtWebEngine 1.8
import QtWebChannel 1.0
import Qt.labs.settings 1.0
import me.appadeia.SysInfo 1.0
import me.appadeia.Launcher 1.0
import me.appadeia.Enabler 1.0

Window {
    id: root
    visible: true
    width: 800
    height: 508

    Component.onCompleted: {
        setX((Screen.width / 2 - width / 2));
        setY(Screen.height / 2 - height / 2);
        bridgeObject.arch = systemInfo.getArch();
        bridgeObject.os = systemInfo.getOS();
        bridgeObject.de = launcher.currentDE();
        bridgeObject.enabled = enabler.autostartEnabled();
    }

    Enabler {
        WebChannel.id: "enabler"
        id: enabler
    }

    // enabler.disableAutostart, enabler.enableAutostart

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
        property bool enabled: true
        property bool ready: false

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
    QtObject {
        WebChannel.id: "homeTr"
        id: homeTr

        // Header of the home screen
        property string ahoy: qsTr("Ahoy, this is openSUSE")

        // Sub headers that denote their categories
        property string basicsHeader: qsTr("Basics")
        property string supportHeader: qsTr("Support")

        // Buttons of the basics column
        property string readme: qsTr("Read me")
        property string documentation: qsTr("Documentation")
        property string getsoftware: qsTr("Get Software")

        // Launchers to DE-provided help programs
        property string gnomehelp: qsTr("GNOME Help")
        property string plasmahelp: qsTr("Plasma Help") // Note: you probably already know this, but Plasma is a name and shouldn't be translated.
        property string xfcehelp: qsTr("Xfce Help")

        // openSUSE Contribution stuff
        property string contribute: qsTr("Contribute") // contribute (to openSUSE)
        property string build: qsTr("Build openSUSE") // help build openSUSE

        // Social media blurb.
        property string smParagraph: qsTr("If this is your first time using openSUSE, we would like you to feel right at home in your new voyage. Take your time to familiarize yourself with all the buttons and let us know how you like the experience on our")
        property string smLink: qsTr("social media") // this phrase is part of the previous paragraph and is not a new sentence.

        // Footer
        property string autostart: qsTr("Show on next startup")
        property string close: qsTr("Close")
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
        opacity: bridgeObject.ready ? 0 : 1
        y: 0

        Image {
            width: 340
            height: 220
            anchors.centerIn: parent
            source: "qrc:///web/images/logo.svg"
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 300
                easing: Easing.InOutQuad
            }
        }
    }

    WebChannel {
        id: bridge
        registeredObjects: [bridgeObject, launcher, enabler, homeTr]
    }
}
