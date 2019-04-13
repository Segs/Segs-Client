import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.0

import segs.launchersetup 1.0

ApplicationWindow {
    id: setup
    visible: true
    modality: Qt.ApplicationModal
    width: 683
    height: 573
    color: "#00000000"
    title: qsTr("SEGSLauncher - Setup")
    flags: Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window

    // Set ID for backend functions

    LauncherSetup { id: backend_launcher_setup }

    FontLoader { id: cuppaJo; source: "qrc:/Resources/Fonts/cuppajoe.ttf" }
    FontLoader { id: dejaVu; source: "qrc:/Resources/Fonts/dejavusans.ttf" }

    // Initialise variables

    property string cox_dir: ""




Item {
    id: main
    Label {
        id: label_welcome
        x: 8
        y: 8
        width: 624
        height: 57
        text: qsTr("Welcome to SEGS... Looks like you're new here,\nlet's take you through some initial setup")
        font.family: dejaVu.name
        font.pointSize: 15
    }

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 683
        height: 573
        color: "#ffffff"
        z: -1

        GroupBox {
            id: groupBox_select_dir
            x: 8
            y: 101
            width: 667
            height: 123
            font.family: dejaVu.name
            font.pointSize: 12
            title: qsTr("First, we need to know where your City of Heroes directory is:")

            TextField {
                id: textField_cox_dir
                anchors.right: parent.right
                anchors.rightMargin: 37
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 17
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                font.family: dejaVu.name
                placeholderText: "Select a directory"
            }

            ToolButton {
                id: select_file_cox_dir
                x: 612
                y: 17
                width: 31
                height: 40
                text: qsTr("...")
                onClicked: { file_dialog_cox_dir.visible = true }
            }
        }

        BusyIndicator {
            id: busyIndicator
            x: 312
            y: 257
            visible: false
        }

        Button {
            id: button
            x: 575
            y: 525
            text: qsTr("Finish")
            font.pointSize: 12
            font.family: cuppaJo.name
            onClicked: {
                set_launcher_settings()
            }
        }
    }

}

FileDialog {
    id: file_dialog_cox_dir
    title: "Please choose your CoX directory"
    folder: shortcuts.home
    selectFolder: true
    selectMultiple: false
    onAccepted: {
        console.log("DEBUG: File chosen: " + file_dialog_cox_dir.folder);
        textField_cox_dir.text = file_dialog_cox_dir.folder;
        cox_dir = file_dialog_cox_dir.folder;


    }
    onRejected: { console.log("DEBUG: File dialog closed") }

}

//////////////////////////////////
// JS functions for C++ backend //
//////////////////////////////////

function set_launcher_settings(){

    var launcher_settings_array = {initial_config: true, cox_dir: cox_dir};
    backend_launcher_setup.write_launcher_settings(launcher_settings_array);
    root.start_up();
    setup.close();

}
}


