#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QQmlContext>
#include <QDebug>
#include <QSurfaceFormat>
#include <QQuickWindow>
#include "Launcher.h"
#include "LauncherSetup.h"
#include "Worker.h"

int main(int argc, char *argv[])
{
    // Ensure alpha channel for translucent windows under Qt 6
    QSurfaceFormat fmt = QSurfaceFormat::defaultFormat();
    fmt.setAlphaBufferSize(8);
    QSurfaceFormat::setDefaultFormat(fmt);
    QQuickWindow::setDefaultAlphaBuffer(true);

    QGuiApplication app(argc, argv);
    QGuiApplication::setWindowIcon(QIcon(":/Resources/Icons/app-icon.svg"));

    qmlRegisterType<LauncherSetup>("segs.launchersetup", 1, 0, "LauncherSetup");
    qmlRegisterType<Launcher>("segs.launcher", 1, 0, "Launcher");
    qmlRegisterType<Worker>("segs.worker", 1, 0, "Worker");

    QQmlApplicationEngine engine;
    // Load the main application window directly to avoid Loader/window indirection.
    engine.load(QUrl(QStringLiteral("qrc:/MainWindow.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QCoreApplication::setOrganizationName("SEGS");
    QCoreApplication::setOrganizationDomain("segs.io");
    QCoreApplication::setApplicationName("SEGSLauncher");


    return QGuiApplication::exec();
}
