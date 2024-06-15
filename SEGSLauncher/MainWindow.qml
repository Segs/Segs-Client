import QtQml 2.15
import QtQuick 2.10
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtMultimedia 5.15

import segs.launchersetup 1.0
import segs.launcher 1.0
import segs.worker 1.0


Window {

    id: root
    objectName: "mainWindow"
    visible: true
    width: 1400
    height: 715
    color: "#00000000"
    title: qsTr("SEGSLauncher")
    flags: Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window

    MediaManager { id: media_manager }

    // Set ID's for backend functions
    LauncherSetup { id: backend_launcher_setup }
    Launcher { id: backend_launcher }

    // Load custom fonts

    FontLoader { id: cuppaJo; source: "qrc:/Resources/Fonts/cuppajoe.ttf" }
    FontLoader { id: cantarell_regular; source: "qrc:/Resources/Fonts/Cantarell-Regular.ttf" }

    // Color variables
    property color hoverColor: "#999999"
    property color pressColor: "#999999"
    property color textColor: "#666666"
    property color backgroundColor: "#0f7aff"
    property color textColorBlue: "#0f7aff"
    property color gettingStatusColor: "blue"
    property color onlineColor: "green"
    property color offlineColor: "#999999"

    // Other variables
    property bool comboBox_server_select_italic: false
    property string server_info_text: ""

    // set the launcher setup channel
    Component.onCompleted: {
        backend_launcher_setup.prepare_launcher_setup(backend_launcher.update_channel)
    }

    // Code to enable frameless window to become draggable
    MouseArea {
        id: dragMouseRegion
        anchors.fill: parent

        property variant clickPos: "1,1" // Ignore Qt error, cannot use 'String' must use 'Variant'
        anchors.leftMargin: 0
        anchors.topMargin: 11
        z: 7
        anchors.rightMargin: 0
        anchors.bottomMargin: 489

        onPressed: {
            clickPos  = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            root.x += delta.x
            root.y += delta.y
        }
    }

    Rectangle {
        id: background
        x: 278
        y: 215
        width: 1100
        height: 494
        color: "#ffffff"
        visible: true
        z: 1

        AnimatedImage {
            id: loader
            x: 480
            y: 216
            visible: false
            width: 100
            height: 100
            z: 20
            smooth: true
            antialiasing: true
            clip: false
            opacity: 1
            fillMode: Image.Stretch
            playing: true
            paused: false
            source: "Resources/Icons/loader.gif"
        }


        Rectangle {
            id: button_close
            x: 1056
            y: 14
            width: 28
            height: 28
            color: backgroundColor
            radius: 2
            z: 19
            opacity: 1

            Label {
                id: label_button_close
                x: 0
                y: -1
                width: 25
                height: 32
                color: "#ffffff"
                text: qsTr("X")
                z: 1
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.italic: true
                font.bold: true
                font.family: cantarell_regular.name
                font.pointSize: 10
            }

            states: [
                State {
                    name: "Hovering"
                    PropertyChanges {
                        target: button_close
                        color: hoverColor
                    }
                    PropertyChanges {
                        target: label_button_close
                        color: textColor
                    }
                }

            ]
            transitions:
                Transition {
                from: ""; to: "Hovering"
                ColorAnimation { duration: 400 }
            }


            MouseArea {
                hoverEnabled: true
                anchors.fill: button_close
                onEntered: { button_close.state='Hovering'}
                onExited: { button_close.state=''}
                onClicked: { Qt.quit();}
                onReleased: {
                    if (containsMouse)
                        button_close.state="Hovering";
                    else
                        button_close.state="";
                }
            }
        }


        Loader {
            id: setupScreenLoader
            width: 0
            height: 0
            visible: true
            active: false
            source: "qrc:/Setup.qml"
            onLoaded: {
                item.visible = true;
            }
        }

        Rectangle {
            id: button_play
            x: 896
            y: 405
            width: 188
            height: 59
            color: "#00000000"
            opacity: 1
            rotation: 0
            visible: true
            clip: false
            z: 4

            Image {
                id: button_play_image
                anchors.rightMargin: 0
                anchors.bottomMargin: -1
                anchors.leftMargin: 0
                anchors.topMargin: 1
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "Resources/Images/button_play.png"
            }

            Text {
                id: button_play_text
                x: 57
                y: 8
                width: 123
                height: 43
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: "LAUNCH"
                z: 1
                font.bold: true
                font.pointSize: 21
                font.family: cuppaJo.name
            }

            DropShadow {
                //color: "#808080"
                anchors.fill: button_play
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 10
                source: button_play_image
            }

            MouseArea {
                x: -8
                y: -6
                anchors.leftMargin: 14
                hoverEnabled: true
                anchors.fill: button_play
                onEntered: { button_play.state="Hovering" }
                onExited: { button_play.state=""}
                onClicked: {
                    media_manager.launch_audio.play()
                    backend_launcher.launch_cox();
                    root.showMinimized()
                }
                onReleased: {
                    if (containsMouse)
                        button_play.state="Hovering";
                    else
                        button_play.state="";
                }
            }


            states: [
                State {
                    name: "Hovering"
                }
            ]
            transitions: [
                Transition {
                    from: ""; to: "Hovering"
                    PropertyAnimation {
                        target: button_play
                        properties: "scale"
                        from: 1.0
                        to: 1.1
                        duration: 200
                    }
                },
                Transition {
                    from: "Hovering"; to: "*"

                    PropertyAnimation {
                        target: button_play
                        properties: "scale"
                        from: 1.1
                        to: 1.0
                        duration: 200
                    }

                }
            ]
        }



        Rectangle {
            id: button_settings
            x: 721
            y: 419
            width: 207
            height: 42
            color: "#00000000"
            opacity: 1
            rotation: 0
            visible: true
            clip: false
            z: 4


            Text {
                id: button_settings_text
                x: 48
                y: 0
                width: 122
                height: 39
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: "SETTINGS"
                z: 1
                font.bold: true
                font.pointSize: 19
                font.family: cuppaJo.name
            }

            Image {
                id: button_settings_img
                source: "Resources/Images/button_settings.png"
                anchors.fill: parent
            }

            DropShadow {
                anchors.fill: button_settings
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 10
                //color: "grey"
                source: button_settings_img
            }

            MouseArea {
                anchors.rightMargin: 17
                hoverEnabled: true
                anchors.fill: button_settings
                onEntered: { button_settings.state="Hovering" }
                onExited: { button_settings.state=""}
                onClicked: {
                    swipeView_servinfo_settings.currentIndex = 1
                }
                onReleased: {
                    if (containsMouse)
                        button_settings.state="Hovering";
                    else
                        button_settings.state="";
                }
            }

            states: [
                State {
                    name: "Hovering"
                }
            ]
            transitions: [
                Transition {
                    from: ""; to: "Hovering"
                    PropertyAnimation {
                        target: button_settings
                        properties: "scale"
                        from: 1.0
                        to: 1.1
                        duration: 200
                    }

                },
                Transition {
                    from: "Hovering"; to: "*"
                    PropertyAnimation {
                        target: button_settings
                        properties: "scale"
                        from: 1.1
                        to: 1.0
                        duration: 200
                    }

                }
            ]
        }

        // ---- Server Type SwipeView Start ----



        SwipeView {
            id: swipeView_server_select
            x: 728
            y: 288
            width: 351
            height: 111
            z: 16
            clip: true
            anchors.rightMargin: 0
            anchors.bottomMargin: 95
            anchors.leftMargin: 620
            anchors.topMargin: 221
            currentIndex: 0
            interactive: false
            visible: true
            anchors.fill: parent

            // --- Page 1 - Online Server START ---

            Item {
                id: page_community_server

                Label {
                    id: label_select_server
                    x: 95
                    y: 22
                    width: 188
                    height: 22
                    color: textColorBlue
                    text: qsTr("SELECT SERVER")
                    font.italic: false
                    font.bold: true
                    font.pointSize: 14
                    font.family: cuppaJo.name
                    horizontalAlignment: Text.AlignLeft
                }

                ComboBox {
                    id: comboBox_server_select
                    x: 95
                    y: 50
                    width: 367
                    height: 55
                    hoverEnabled: true
                    model: ListModel {

                        id: server_list_model

                    }
                    background: Rectangle {
                        color: "#f1f1f1"
                        border.color: "black"
                        border.width: 1

                    }
                    textRole: "displayText"
                    delegate: ItemDelegate {
                        id: comboBox_server_select_delegate
                        width: comboBox_server_select.width
                        height: 50

                        MouseArea {
                            z: 1
                            width: comboBox_server_select_delegate.width
                            height: comboBox_server_select_delegate.height
                            hoverEnabled: true
                            onPressed: {
                                mouse.accepted = false
                            }

                            Rectangle {
                                color: "yellow"
                                opacity: 0.65
                                visible: parent.containsMouse
                                anchors.fill: parent
                            }
                        }
                        contentItem: Row {
                            z: 2
                            Text {
                                id: comboBox_server_select_delegate_type_text
                                text: model.displayTextType
                                topPadding: 17
                                leftPadding: 23
                                clip: false
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                font.family: cantarell_regular.name
                                font.pointSize: 8
                                font.italic: comboBox_server_select_italic
                                font.bold: true
                                textFormat: Qt.RichText
                                color: "#666666"
                                elide: Text.ElideMiddle
                            }
                        }
                        Row {
                            z: 2
                            padding: 5

                            Image {
                                width: 18
                                height: 18
                                source: model.comboBox_server_select_svg
                                verticalAlignment: Image.AlignVCenter
                                horizontalAlignment: Image.AlignLeft

                            }
                            Text {
                                id: comboBox_server_select_delegate_text
                                text: model.displayText
                                leftPadding: 10
                                clip: false
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                font.family: cantarell_regular.name
                                font.pointSize: 12
                                font.italic: comboBox_server_select_italic
                                textFormat: Qt.RichText
                                color: "#666666"
                                elide: Text.ElideMiddle
                            }
                        }
                    }
                    contentItem: Row {
                        id: comboBox_server_select_content
                        leftPadding: 10
                        topPadding: 18

                        Image {
                            id: comboBox_server_select_content_img
                            width: 18
                            height: 18
                            source: "Resources/Icons/refresh-cw.svg"
                            verticalAlignment: Image.AlignVCenter
                            horizontalAlignment: Image.AlignLeft
                        }

                        Text {
                            text: comboBox_server_select.currentText
                            leftPadding: 10
                            clip: false
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            font.family: cantarell_regular.name
                            font.pointSize: 12
                            color: "#666666"                     }
                    }

                    onCurrentIndexChanged: {
                        set_server();
                        refresh_status_text();
                        get_server_information(server_list_model.get(currentIndex).server_name)
                    }
                    onModelChanged: {
                        set_server();
                    }
                }

                Label {
                    id: label_online
                    x: 133
                    y: 111
                    width: 329
                    height: 25
                    color: gettingStatusColor
                    text: ""
                    rightPadding: 10
                    verticalAlignment: Text.AlignTop
                    font.family: cantarell_regular.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 10
                }

                Label {
                    id: label_add_server
                    x: 274
                    y: 22
                    width: 188
                    height: 22
                    color: textColorBlue
                    text: qsTr("ADD NEW SERVER")
                    rightPadding: 5
                    verticalAlignment: Text.AlignVCenter
                    font.italic: false
                    font.bold: false
                    font.family: cuppaJo.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 10

                    MouseArea {
                        width: label_add_server.width
                        height: label_add_server.height
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            swipeView_server_select.setCurrentIndex(1)
                        }
                    }
                }
            }
            // --- Page 1 - Online Server END ---

            // --- Page 2 - Local Server START ---

            Item {
                id: page_local_server
                Rectangle {
                    id: button_local_save
                    x: 357
                    y: 143
                    width: 106
                    height: 27
                    color: "#999999"
                    opacity: 1
                    rotation: 0
                    visible: true
                    clip: false
                    z: 4

                    Text {
                        id: button_local_save_text
                        x: 0
                        y: 0
                        width: 106
                        height: 27
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        text: "SAVE"
                        z: 1
                        font.bold: true
                        font.pointSize: 14
                        font.family: cuppaJo.name
                    }

                    MouseArea {
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        hoverEnabled: true
                        anchors.fill: button_local_save
                        onEntered: { button_local_save.state="Hovering" }
                        onExited: { button_local_save.state=""}
                        onClicked: {
                            add_to_server_list(textField_server_name.text, textField_server_ip.text)
                            growl.visible = true
                            swipeView_server_select.currentIndex = 0
                        }
                        onReleased: {
                            if (containsMouse)
                                button_local_save.state="Hovering"
                            else
                                button_local_save.state=""
                        }
                    }

                    states: [
                        State {
                            name: "Hovering"
                        }
                    ]
                    transitions: [
                        Transition {
                            from: ""; to: "Hovering"
                            PropertyAnimation {
                                target: button_local_save
                                properties: "scale"
                                from: 1.0
                                to: 1.1
                                duration: 200
                            }

                        },
                        Transition {
                            from: "Hovering"; to: "*"
                            PropertyAnimation {
                                target: button_local_save
                                properties: "scale"
                                from: 1.1
                                to: 1.0
                                duration: 200
                            }

                        }
                    ]
                }
                Rectangle {
                    id: button_local_back
                    x: 240
                    y: 143
                    width: 106
                    height: 27
                    color: "#999999"
                    opacity: 1
                    rotation: 0
                    visible: true
                    clip: false
                    z: 4

                    Text {
                        id: button_local_back_text
                        x: 0
                        y: 0
                        width: 106
                        height: 27
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        text: "BACK"
                        z: 1
                        font.bold: true
                        font.pointSize: 14
                        font.family: cuppaJo.name
                    }

                    MouseArea {
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        hoverEnabled: true
                        anchors.fill: button_local_back
                        onEntered: { button_local_back.state="Hovering" }
                        onExited: { button_local_back.state=""}
                        onClicked: {
                            swipeView_server_select.currentIndex = 0
                        }
                        onReleased: {
                            if (containsMouse)
                                button_local_save.state="Hovering"
                            else
                                button_local_save.state=""
                        }
                    }

                    states: [
                        State {
                            name: "Hovering"
                        }
                    ]
                    transitions: [
                        Transition {
                            from: ""; to: "Hovering"
                            PropertyAnimation {
                                target: button_local_back
                                properties: "scale"
                                from: 1.0
                                to: 1.1
                                duration: 200
                            }

                        },
                        Transition {
                            from: "Hovering"; to: "*"
                            PropertyAnimation {
                                target: button_local_back
                                properties: "scale"
                                from: 1.1
                                to: 1.0
                                duration: 200
                            }

                        }
                    ]
                }

                TextField {
                    id: textField_server_ip
                    x: 154
                    y: 72
                    text: qsTr("")
                    z: 5
                    placeholderText: "Server IP"
                }

                TextField {
                    id: textField_server_name
                    x: 154
                    y: 26
                    text: qsTr("")
                    z: 6
                    placeholderText: "Server Name"
                }


            }

            // --- Page 2 - Local Server END ---

        }

        // ---- Server Type SwipeView End ----


        Image {
            id: segs_logo
            x: 689
            y: -107
            width: 371
            height: 332
            z: 15
            source: "Resources/Images/segs-logo.png"

            NumberAnimation {
                id: segs_logo_animator
                target: segs_logo
                property: "y"
                from: -442
                to: -107
                duration: 1000
                easing.type: Easing.OutBounce
                running: true
            }
        }


        Rectangle {
            id: growl
            visible: false
            x: 674
            y: 8
            width: 376
            height: 38
            color: "#e40909"
            radius: 5
            z: 18

            Text {
                text: "Server name already exists"
                font.pointSize: 10
                font.family: cantarell_regular.name
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
            }

            PropertyAnimation {
                running: true
                target: growl
                property: 'visible'
                to: false
                duration: 3000 // turns to false after 5000 ms
            }
        }

        // SwipeView Server Info and Settings START


        SwipeView {
            id: swipeView_servinfo_settings
            anchors.right: parent.right
            anchors.rightMargin: 417
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            anchors.top: parent.top
            anchors.topMargin: 0
            z: 17
            clip: true
            interactive: false
            currentIndex: 0
            visible: true

            // Page 1 Start

            Item {
                id: page_server_info
                z: 2

                Rectangle {
                    id: release_notes_header
                    x: 37
                    y: 9
                    width: 570
                    height: 36
                    color: "#f1f1f1"
                    z: 19
                    opacity: 0.8

                    Label {
                        id: label_release_notes
                        width: 392
                        color: textColorBlue
                        text: qsTr("SERVER INFO & RELEASE NOTES")
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 3
                        anchors.topMargin: 0
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.top: parent.top
                        z: 18
                        wrapMode: Text.WordWrap
                        styleColor: "#000000"
                        font.family: cuppaJo.name
                        horizontalAlignment: Text.AlignLeft
                        font.pointSize: 12
                        font.bold: true
                    }

                    Label {
                        id: label_version_info
                        color: "#666666"
                        text: ""
                        rightPadding: 10
                        anchors.rightMargin: 3
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                        anchors.leftMargin: 395
                        anchors.fill: parent
                        z: 19
                        verticalAlignment: Text.AlignVCenter
                        font.family: cuppaJo.name
                        horizontalAlignment: Text.AlignRight
                        font.pointSize: 12
                        font.bold: true
                    }
                }

                ScrollView {
                    id: scrollView_release_notes
                    x: 38
                    y: 60
                    width: 571
                    z: 20
                    clip: true

                    anchors.right: parent.right
                    anchors.rightMargin: 61
                    anchors.left: parent.left
                    anchors.leftMargin: 37
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    anchors.top: parent.top
                    anchors.topMargin: 121
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AlwaysOn
                        parent: scrollView_release_notes
                        x: scrollView_release_notes.mirrored ? 0 : scrollView_release_notes.width - width
                        y: scrollView_release_notes.topPadding
                        height: scrollView_release_notes.availableHeight
                        background: Rectangle {
                            color: "#0f7aff"
                        }
                    }

                    Text {
                        id: textArea_release_notes
                        x: 0
                        y: 0
                        width: 570
                        height: 335
                        text: ""
                        z: 3
                        wrapMode: Text.WordWrap
                        textFormat: Text.AutoText
                        opacity: 1
                        font.pointSize: 10
                        font.family: cantarell_regular.name
                        color: "black"
                        padding: 5
                    }

                    background: Rectangle {
                        width: textArea_release_notes.width
                        height: textArea_release_notes.height
                        color: "#F1F1F1"
                        opacity: 0.8
                    }

                    ScaleAnimator {
                        target: scrollView_release_notes
                        from: 0.1
                        to: 1
                        duration: 500
                        running: true
                    }
                }


                Rectangle {
                    id: server_info_background
                    x: 37
                    y: 51
                    width: 570
                    height: 64
                    color: "#f1f1f1"
                    z: 19
                    opacity: 0.8

                    Text {
                        id: textArea_server_info
                        color: "black"
                        text: server_info_text
                        anchors.fill: parent
                        z: 3
                        padding: 5
                        opacity: 1
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        font.pointSize: 10
                        font.family: cantarell_regular.name
                        onLinkActivated: Qt.openUrlExternally(link)

                        MouseArea {
                            id: mouse_area_si
                            anchors.fill: parent
                            acceptedButtons: Qt.NoButton
                            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                        }

                    }
                }
            }

            // Page 1 End
            // Page 2 Start
            Item {
                id: page_settings

                Rectangle {
                    id: rectangle
                    x: 22
                    y: 20
                    width: 625
                    height: 424
                    color: "#f1f1f1"
                    opacity: 0.8
                }

                Button {
                    id: button_settings_save
                    x: 534
                    y: 377
                    text: qsTr("SAVE")
                    font.pointSize: 14
                    font.family: cuppaJo.name
                    onClicked: {
                        swipeView_servinfo_settings.currentIndex = 0
                        set_launcher_game_settings()
                    }
                }

                Label {
                    id: label_screen_res
                    color: "#0f7aff"
                    text: qsTr("SCREEN RESOLUTION")
                    font.bold: true
                    font.pointSize: 14
                    anchors.right: parent.right
                    anchors.rightMargin: 490
                    anchors.left: parent.left
                    anchors.leftMargin: 33
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 360
                    anchors.top: parent.top
                    anchors.topMargin: 77
                    font.family: cuppaJo.name
                }

                TextField {
                    id: textField_screen_x
                    text: qsTr("")
                    font.family: cantarell_regular.name
                    anchors.right: parent.right
                    anchors.rightMargin: 579
                    anchors.left: parent.left
                    anchors.leftMargin: 33
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 321
                    anchors.top: parent.top
                    anchors.topMargin: 103
                    placeholderText: ""
                    background: Rectangle {
                        color: "#f1f1f1"
                    }
                }

                TextField {
                    id: textField_screen_y
                    width: 56
                    font.family: cantarell_regular.name
                    anchors.right: parent.right
                    anchors.rightMargin: 504
                    anchors.left: parent.left
                    anchors.leftMargin: 110
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 322
                    anchors.top: parent.top
                    anchors.topMargin: 104
                    placeholderText: ""
                    background: Rectangle {
                        color: "#f1f1f1"
                    }
                }

                Label {
                    id: label_screen_res1
                    height: 28
                    color: "#0f7aff"
                    text: qsTr("X")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 327
                    anchors.top: parent.top
                    anchors.topMargin: 109
                    anchors.right: parent.right
                    anchors.rightMargin: 564
                    anchors.left: parent.left
                    anchors.leftMargin: 95
                    font.pointSize: 14
                    font.family: cuppaJo.name
                    font.bold: true
                }

                Label {
                    id: label_full_screen
                    color: "#0f7aff"
                    text: qsTr("FULL SCREEN")
                    font.bold: true
                    font.pointSize: 14
                    anchors.right: parent.right
                    anchors.rightMargin: 538
                    anchors.left: parent.left
                    anchors.leftMargin: 33
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 278
                    anchors.top: parent.top
                    anchors.topMargin: 162
                    font.family: cuppaJo.name
                }

                CheckBox {
                    id: checkBox_fullscreen
                    anchors.right: parent.right
                    anchors.rightMargin: 461
                    anchors.left: parent.left
                    anchors.leftMargin: 161
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 270
                    anchors.top: parent.top
                    anchors.topMargin: 154
                }
            }
        }

        Image {
            id: background_rectangle
            x: 0
            y: 0
            width: 1100
            height: 494
            fillMode: Image.Stretch
            source: "Resources/Images/background_rectangle.png"
        }

        Image {
            id: hero_image
            x: -453
            y: -283
            width: 942
            height: 683
            fillMode: Image.PreserveAspectFit
            source: "Resources/Images/bluestreak.png"
        }



        // SwipeView Server Info and Settings START

    }

    // When main window loaded, call these functions.
    Component.onCompleted: {
        media_manager.startup_audio.play()
        start_up()

    }

    //////////////////////////////////
    // JS functions for C++ backend //
    //////////////////////////////////

    // Application start up functions
    function start_up()
    {
        set_loader(true);
        get_launcher_settings();
        set_loader(false);
    }

    // Shows loading spinner
    function set_loader(status)
    {
        if (status === true)
        {
            loader.visible = true;
            background.enabled = false;
        }
        else if (status === false)
        {
            loader.visible = false;
            background.enabled = true;
        }
    }

    // Retrieves saved launcher settings
    // TODO: Rename to better reflect what this does
    function get_launcher_settings()
    {
        var launcher_settings_obj = backend_launcher_setup.read_launcher_settings();
        if (launcher_settings_obj["initial_config"] === true)
        {
            mainWindowLoader.active = true;
            textField_screen_x.text = launcher_settings_obj["screenX"];
            textField_screen_y.text = launcher_settings_obj["screenY"];
            checkBox_fullscreen.checked = launcher_settings_obj["fullscreen"];
            fetch_server_list();
        }
        else
        {
            console.log("DEBUG: Initial config not complete... show setup");
            loader.visible = false;
            setupScreenLoader.active = true;
        }
    }

    function set_launcher_game_settings()
    {
        var check_state;
        if (checkBox_fullscreen.checked)
            check_state = 1
        else
            check_state = 0
        var launcher_game_settings_obj = {screenX: textField_screen_x.text, screenY: textField_screen_y.text,
            fullscreen: check_state}
        backend_launcher.set_launcher_game_settings(launcher_game_settings_obj);

    }

    // Get last used server. If stored server name matches a server name on the server list
    // set ComboBox to that entry.
    function get_last_used_server()
    {
        var server_settings_obj = backend_launcher.get_last_used_server();
        for (var i= 0; i < server_list_model.count; i++)
        {
            if(server_list_model.get(i).server_name === server_settings_obj["server_name"])
            {
                comboBox_server_select.currentIndex = i;
            }
            else
                comboBox_server_select.currentIndex = 0;
        }
        fetch_release_info();
    }

    // Function called first to allow back end to retrieve JSON from Github.
    function fetch_server_list()
    {

        backend_launcher.fetchServerListFinished.connect(populate_server_list);
        backend_launcher.fetch_community_servers();
    }

    // Get list of community and local servers from QSettings - populate ComboBox
    function populate_server_list()
    {
        var server_obj = backend_launcher.get_server_list();
        var temp;
        var type;
        for (var i = 0, l = Object.keys(server_obj.Servers).length; i < l; i++)
        {
            if (server_obj.Servers[i].server_type === "C")
            {
                temp = server_obj.Servers[i].server_name + " (" +
                        server_obj.Servers[i].server_ip + ") ";
                type = "Community";
            }
            else if (server_obj.Servers[i].server_type === "L")
            {
                temp = server_obj.Servers[i].server_name + " (" +
                        server_obj.Servers[i].server_ip + ") ";
                type = "Custom";
            }
            server_list_model.append({"displayText": temp, "displayTextType": type, "server_type": server_obj.Servers[i].server_type,
                                         "server_name": server_obj.Servers[i].server_name,
                                         "server_ip": server_obj.Servers[i].server_ip, "comboBox_server_select_svg": "Resources/Icons/refresh-cw.svg"});
        }
        backend_launcher.serverStatusReady.connect(get_server_status);
        backend_launcher.start_server_status_worker();
        get_last_used_server();
    }

    // Gets status of Online server
    function get_server_status()
    {
        var server_status_obj = backend_launcher.is_server_online();
        for (var i = 0, l = server_list_model.count; i < l; i++)
        {
            if(server_status_obj["server_name"] === server_list_model.get(i).server_name)
            {
                if(server_status_obj["server_status"] === true)
                {
                    if(server_list_model.get(i).server_type === "C")
                    {
                        server_list_model.set(i, {"server_status": true, "server_uptime": server_status_obj["server_uptime"],
                                                  "comboBox_server_select_svg": "Resources/Icons/globe_green.svg"});
                    }
                    else if(server_list_model.get(i).server_type === "L")
                    {
                        server_list_model.set(i, {"server_status": true, "server_uptime": server_status_obj["server_uptime"],
                                                  "comboBox_server_select_svg": "Resources/Icons/server_green.svg"});
                    }
                }
                else
                {
                    if(server_list_model.get(i).server_type === "C")
                    {
                        server_list_model.set(i, {"server_status": false, "comboBox_server_select_svg": "Resources/Icons/globe_red.svg"});
                    }
                    else if(server_list_model.get(i).server_type === "L")
                    {
                        server_list_model.set(i, {"server_status": false, "comboBox_server_select_svg": "Resources/Icons/server_red.svg"});
                    }
                }
            }
            refresh_status_text();
        }
    }

    // Add custom server
    function add_to_server_list(server_name, server_ip)
    {
        // Save to settings
        var server_obj = {server_name: server_name, server_ip: server_ip};
        backend_launcher.add_local_server(server_obj);

        // Add to server select combobox
        var temp = server_name + " (" +
                server_ip + ") ";
        server_list_model.append({"displayText": temp, "displayTextType": "Custom", "server_type": "L",
                                     "server_name": server_name,
                                     "server_ip": server_ip, "comboBox_server_select_svg": "Resources/Icons/refresh-cw.svg"});
        var count = server_list_model.count;
        comboBox_server_select.currentIndex = count - 1;
        backend_launcher.start_server_status_worker();

    }

    // On selection, saves selected server to launcher settings
    function set_server()
    {
        var server_settings_array = {server_name: server_list_model.get(comboBox_server_select.currentIndex).server_name,
            server_ip: server_list_model.get(comboBox_server_select.currentIndex).server_ip};
        backend_launcher.set_server(server_settings_array);
    }

    // Refresh server uptime / status text
    function refresh_status_text()
    {
        if (server_list_model.get(comboBox_server_select.currentIndex).server_status !== undefined)
        {
            if (server_list_model.get(comboBox_server_select.currentIndex).server_status === true)
            {
                label_online.text = "Online for " + server_list_model.get(comboBox_server_select.currentIndex).server_uptime + " days";
                label_online.color = onlineColor;
            }
            else
            {
                label_online.text = "Offline / Unknown Status";
                label_online.color = offlineColor;
            }
        }
        comboBox_server_select_content_img.source = server_list_model.get(comboBox_server_select.currentIndex).comboBox_server_select_svg;

    }
    // Launches SEGSAdmin
    function launch_segsadmin()
    {
        backend_launcher.launch_segsadmin();
    }

    // Function called first to allow back end to retrieve JSON from Github.
    function fetch_release_info()
    {
        backend_launcher.fetchReleasesFinished.connect(get_release_info);
        backend_launcher.fetch_release_notes();

    }

    // Get JSON object once fetch_release_info() finished.
    function get_release_info()
    {
        var release_obj = backend_launcher.get_version_info();
        textArea_release_notes.text = release_obj.release_notes;
        label_version_info.text = release_obj.version_string;
    }

    // Get server information from settings (Community only)
    function get_server_information(server)
    {
        var server_info_obj = backend_launcher.get_server_information();
        for (var i = 0, l = Object.keys(server_info_obj.Servers).length; i < l; i++)
        {
            if(server === server_info_obj.Servers[i].server_name)
            {
                server_info_text = "<b>" + server_info_obj.Servers[i].server_description + "</b>"
                        + "<br><b>Register an account at: </b>" + "<a href=" +
                        server_info_obj.Servers[i].server_web_url + ">" +
                        server_info_obj.Servers[i].server_web_url + "</a>";
                return;
            }
            else
            {
                server_info_text = "No server information available";
            }
        }
    }
}


// Qt Designer



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
