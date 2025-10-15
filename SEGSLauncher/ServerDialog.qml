import QtQml
import QtQuick
import QtQuick.Window
import QtQuick.Controls

import segs.launcher 1.0

Dialog {

    // Load custom fonts

    FontLoader { id: cuppaJo; source: "qrc:/Resources/Fonts/cuppajoe.ttf" }
    FontLoader { id: dejaVu; source: "qrc:/Resources/Fonts/dejavusans.ttf" }

    property alias serverNameText: textField_server_name.text
    property alias serverIPText: textField_server_ip.text

    PropertyAnimation {
        target: server_dialog;
        property: "opacity";
        duration: 400;
        from: 0;
        to: 1;
        easing.type: Easing.InOutQuad;
        running: true
    }

    id: server_dialog
    visible: true;
    title: "Add / Edit Server"
    contentItem: Rectangle {
        width: 220
        color: "#ffffff"
        implicitWidth: 400
        implicitHeight: 250

        Button {
            id: button_save
            x: 108
            y: 202
            width: 100
            height: 40
            text: qsTr("Save")
            contentItem: Text {
                text: button_save.text
                font.pointSize: 10
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.family: cuppaJo.name

            }

            background: Rectangle {
                id: button_save_background
                width: button_save.width
                height: button_save.height
                color: "#0f7aff"
            }
            onClicked: {
                server_dialog.close()
                add_local_server()
            }
        }

        Label {

            id: label_server_name
            x: 8
            y: 44
            color: "#0f7aff"
            text: qsTr("Server Name")
            font.family: cuppaJo.name
        }

        TextField {
            id: textField_server_name
            x: 8
            y: 63
            text: qsTr("")
            font.family: cuppaJo.name
            placeholderText: "Server Name"
        }

        Label {
            id: label_server_ip
            x: 8
            y: 118
            color: "#0f7aff"
            text: qsTr("Server IP")
            font.family: cuppaJo.name
        }

        TextField {
            id: textField_server_ip
            x: 8
            y: 137
            text: qsTr("")
            font.family: cuppaJo.name
            placeholderText: "Server IP"

        }
    }

    // JS functions for C++ backend

    function add_local_server()
    {
        var local_server_array = {server_name: textField_server_name.text, server_ip: textField_server_ip.text};
        backend_launcher.add_local_server(local_server_array);

        add_to_server_list(local_server_array.server_name, local_server_array.server_ip); // TODO - Fix for EDIT, so it doesn't add new record
    }
}


/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
