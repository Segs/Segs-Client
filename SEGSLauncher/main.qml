import QtQml 2.8
import QtQuick 2.1

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
