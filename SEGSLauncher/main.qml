import QtQml
import QtQuick

Item {
    Loader {
        id: mainWindowLoader
        active: true
        source: "qrc:/MainWindow.qml"
        asynchronous: true
        onLoaded: {
            item.visible = true;
        }
}
}
