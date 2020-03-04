#include "LauncherSetup.h"
#include <QCryptographicHash>
#include <QDebug>
#include <QFile>
#include <QSettings>
#include <QStandardPaths>
#include <QIODevice>
#include <QProcess>
#include <QUrl>

LauncherSetup::LauncherSetup(QObject *parent) : QObject(parent)
{

}

QVariantMap LauncherSetup::read_launcher_settings()
{
    QVariantMap launcher_settings;
    QSettings settings;
    settings.beginGroup("LauncherConfig");
    launcher_settings.insert("initial_config", (settings.value("InitialConfig", "").toBool()));
    launcher_settings.insert("cox_dir", (settings.value("CoXDir", "").toString()));
    launcher_settings.insert("server_type", (settings.value("ServerTypeRadioButton", "").toString()));
    settings.endGroup();

    QSettings segs_settings(QString("HKEY_CURRENT_USER\\Software\\Cryptic\\%1").arg("SEGS"), QSettings::NativeFormat);
    int screenX = segs_settings.value("screenX", "").toInt();
    int screenY = segs_settings.value("screenY", "").toInt();
    bool fullscreen = segs_settings.value("fullScreen", "").toBool();
    launcher_settings.insert("screenX", screenX);
    launcher_settings.insert("screenY", screenY);
    launcher_settings.insert("fullscreen", fullscreen);

    // TODO: For Debug only remove later
    QString settingsPath = settings.fileName();
    qDebug()<<"Settings location: " + settingsPath;
    //

    return launcher_settings;
}


void LauncherSetup::write_launcher_settings(QVariantMap launcher_settings)
{
   qDebug()<<launcher_settings;
   QString cox_dir_path = QUrl(launcher_settings["cox_dir"].toString()).toLocalFile();
   QSettings settings;
   settings.beginGroup("LauncherConfig");
   settings.setValue("InitialConfig", launcher_settings["initial_config"]);
   settings.setValue("CoxDir", cox_dir_path);
   settings.endGroup();
}
/**
void LauncherSetup::verify_client_version(QString cox_dir)
{
        QString coxexe = cox_dir.append("/CoX.exe");
        QCryptographicHash hash(QCryptographicHash::Sha1);
        QFile file(cox_dir);

        if (file.open(QIODevice::ReadOnly))
        {
            qDebug()<<"Generating SHA-1 Hash of CoX.exe";
            ui->piggtool_output->appendPlainText("Checking CoX client is correct version");
            hash.addData(file.readAll());
        }
        else
        {
            qDebug()<<"Cannot find or open CoX.exe";
            ui->piggtool_output->appendPlainText("Cannot find or open CoX.exe, did you pick the correct directory?");
        }

        // Retrieve the SHA1 signature of the file
        QByteArray clienthash = hash.result();

        // If new version of CoX client in use, use below qDebug to print hash to console and replace in boolean check below
        // qDebug()<<(clienthash);

        // Compare SHA1 hashes
        if (clienthash == "\xFF""E0_\x1A\x84\x92\xB4\xCE\x84\xF7?\xFAk2JH\x8FM%")
        {
            ui->piggtool_output->appendPlainText("Correct client version found");
            emit readyToCopy();
        }
        else
        {
            ui->piggtool_output->appendPlainText("Wrong client version found... Stopping");
        }

}
**/
