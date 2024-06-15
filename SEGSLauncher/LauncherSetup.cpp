#include "LauncherSetup.h"
#include "Launcher.h"

#include <QCryptographicHash>
#include <QDebug>
#include <QSettings>
#include <QStandardPaths>
#include <QIODevice>
#include <QUrl>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>


/*
    Launcher version data is stored in a JSON file on the server
    The launcher will download the JSON file and compare the version number
    The format of the json file is as follows:
    {
        "version_data": [
        {
            "version": "1.0.0",
            "channel": "stable",
            "notes": "Release notes"
        }]
        "signature": "crypto signature"
    }
    crypto signature is a signature of the version data content
*/

LauncherSetup::LauncherSetup(QObject *parent) : QObject(parent) {
    m_net_manager = new QNetworkAccessManager(this);
    connect(m_net_manager, &QNetworkAccessManager::finished, this, &LauncherSetup::version_check_finished);
}

void LauncherSetup::prepare_launcher_setup(const QString &channel) {
    m_channel = channel;
    check_for_new_version();
}

QVariantMap LauncherSetup::read_launcher_settings() {
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
    qDebug() << "Settings location: " + settingsPath;
    //

    return launcher_settings;
}


void LauncherSetup::write_launcher_settings(QVariantMap launcher_settings) {
    qDebug() << launcher_settings;
    QString cox_dir_path = QUrl(launcher_settings["cox_dir"].toString()).toLocalFile();
    QSettings settings;
    settings.beginGroup("LauncherConfig");
    settings.setValue("InitialConfig", launcher_settings["initial_config"]);
    settings.setValue("CoxDir", cox_dir_path);
    settings.endGroup();
}

// download the launcher version file from the server
// verify the downloaded version against the current version
// if the versions are different, emit a signal to the QML
void LauncherSetup::check_for_new_version() {
    QUrl url(launcher_version_url);
    QNetworkRequest request(url);
    m_net_manager->get(request);
}

void LauncherSetup::version_check_finished(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "Error loading version data: " << reply->errorString();
        return;
    }

    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject obj = doc.object();
    QJsonArray version_data = obj["version_data"].toArray();
    // collect all versions in the channel that are newer than the current version
    QVector<QPair<QVersionNumber, QString>> new_versions;
    for (const auto &version: version_data) {
        QJsonObject ver = version.toObject();
        if (ver["channel"].toString() == m_channel) {
            QVersionNumber new_version = QVersionNumber::fromString(ver["version"].toString());
            if (new_version > Launcher::get_launcher_version())
                new_versions.push_back({new_version, ver["notes"].toString()});
        }
    }
    if (!new_versions.empty()) {
        std::sort(new_versions.begin(), new_versions.end(),
                  [](const QPair<QVersionNumber, QString> &a, const QPair<QVersionNumber, QString> &b) {
                      return a.first > b.first;
                  });
        m_latest_version = new_versions[0].first;
        m_changelogs.clear();
        for (const auto &ver: new_versions)
            m_changelogs.push_back(ver.second);
        emit newVersionAvailable(m_latest_version);
    }
}

LauncherSetup::~LauncherSetup() {
    delete m_net_manager;
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
