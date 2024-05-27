#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QQmlContext>
#include <QDebug>
#include "Launcher.h"
#include "LauncherSetup.h"
#include "Worker.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QGuiApplication::setWindowIcon(QIcon(":/Resources/Icons/app-icon.svg"));

    qmlRegisterType<LauncherSetup>("segs.launchersetup", 1, 0, "LauncherSetup");
    qmlRegisterType<Launcher>("segs.launcher", 1, 0, "Launcher");
    qmlRegisterType<Worker>("segs.worker", 1, 0, "Worker");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QCoreApplication::setOrganizationName("SEGS");
    QCoreApplication::setOrganizationDomain("segs.io");
    QCoreApplication::setApplicationName("SEGSLauncher");


    return QGuiApplication::exec();
}
