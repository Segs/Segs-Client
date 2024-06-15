#include "Launcher.h"

#include "Worker.h"

#include <QProcess>
#include <QVariantMap>
#include <QDebug>
#include <QUrl>
#include <QSettings>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QTimer>
#include <QDir>


const QVersionNumber Launcher::m_version = QVersionNumber(0,0,1);

Launcher::Launcher(QObject *parent) : QObject(parent)
{
    m_update_channel = "stable";
    // Worker thread for getting server status (RPC call)
    Worker *worker = new Worker;
    worker->moveToThread(&worker_thread);
    connect(&worker_thread, &QThread::finished, worker, &QObject::deleteLater);
    connect(this, &Launcher::getServerStatus, worker, &Worker::server_status_dispatcher);
    connect(worker, &Worker::serverStatusWorkerReady, this, &Launcher::handle_server_status_worker);
    worker_thread.start();
}

Launcher::~Launcher()
{
    worker_thread.quit();
    worker_thread.wait();
}

void Launcher::launch_cox()
{
    QSettings settings;
    settings.beginGroup("LauncherConfig");
    QString cox_dir = settings.value("CoxDir", "").toString();
    settings.endGroup();
    QStringList arguments = {
        "-project",
        "SEGS"
    };
    QString program = cox_dir + "/CoX.exe";

    m_start_cox = new QProcess(this);
    m_start_cox->setWorkingDirectory(cox_dir);
    m_start_cox->start(program, arguments);
}

void Launcher::launch_segsadmin()
{
    QString program = "SEGSAdmin.exe";

    m_start_segsadmin = new QProcess(this);
    m_start_segsadmin->setWorkingDirectory(QDir::currentPath());
    m_start_segsadmin->start(program,QStringList());

    qDebug()<<"launch_segsadmin";
}

// API Call: Get list of community servers from segs-community and locally saved servers
void Launcher::fetch_community_servers()
{
    m_community_servers_manager = new QNetworkAccessManager;
    QUrl url("https://raw.githubusercontent.com/segs-community/cox-servers/master/ServerLists/segs_community_servers.json");
    QNetworkRequest request;
    request.setUrl(url);
    m_servers_network_reply = m_community_servers_manager->get(request);
    connect(m_community_servers_manager,&QNetworkAccessManager::finished,this,&Launcher::handle_servers_reply);

}

// Add or update community servers to application
void Launcher::handle_servers_reply()
{
    {
        if(m_servers_network_reply->error() == QNetworkReply::NoError)
        {
            QByteArray reply = m_servers_network_reply->readAll();
            QJsonDocument jsonResponse = QJsonDocument::fromJson(reply);
            QJsonObject json_obj = jsonResponse.object();
            QJsonArray json_array = json_obj["Servers"].toArray();

            QSettings settings;
            settings.beginGroup("ServerConfig");
            settings.beginGroup("CommunityServers");

            for (const QJsonValue value : json_array)
            {
                QJsonObject json_obj = value["ServerDetails"].toObject();
                settings.beginGroup(json_obj["Name"].toString());
                settings.setValue("ServerName", json_obj["Name"].toString());
                settings.setValue("ServerIP", json_obj["IP"].toString());
                settings.setValue("ServerDescription", json_obj["Description"].toString());
                settings.setValue("ServerWebURL", json_obj["WebURL"].toString());
                settings.setValue("ServerType", "C");
                settings.endGroup();

            }
            settings.endGroup();
            settings.endGroup();
            emit fetchServerListFinished();

        }
        else
        {
            qDebug()<<m_servers_network_reply->error();
            qDebug()<<"handle_servers_reply: Network Error";
        }
    }
}

// Set current server settings to registry
void Launcher::set_server(QVariantMap server_details)
{
    QSettings settings;
    settings.beginGroup("ServerConfig");
    settings.setValue("LastServerName", server_details["server_name"]);
    settings.setValue("LastServerIP", server_details["server_ip"]);
    settings.endGroup();

    QSettings segs_settings(QString(R"(HKEY_CURRENT_USER\Software\Cryptic\%1)").arg("SEGS"),
                            QSettings::NativeFormat);
    segs_settings.setValue("Auth", server_details["server_ip"]);
}

// Get last used server
QVariantMap Launcher::get_last_used_server()
{
    QVariantMap last_used_server;
    QSettings settings;

    settings.beginGroup("ServerConfig");
    last_used_server.insert("server_name", (settings.value("LastServerName", "").toString()));
    last_used_server.insert("server_ip", (settings.value("LastServerIP", "").toString()));
    settings.endGroup();

    return last_used_server;
}

// Read server settings from QSettings
QJsonObject Launcher::get_server_list()
{
    QJsonArray temp_server_settings;
    QJsonObject server_list;
    QSettings settings;

    // Get community servers
    settings.beginGroup("ServerConfig");
    settings.beginGroup("CommunityServers");

    for(const QString &group : settings.childGroups())
    {
        QJsonObject server;
        settings.beginGroup(group);
        server.insert("server_name", (settings.value("ServerName", "").toString()));
        server.insert("server_ip", (settings.value("ServerIP", "").toString()));
        server.insert("server_type", (settings.value("ServerType", "").toString()));
        settings.endGroup();

        temp_server_settings.push_back(server);
    }

    settings.endGroup();

    // Get local servers
    settings.beginGroup("LocalServers");

    for(const QString &group : settings.childGroups())
    {
        QJsonObject server;
        settings.beginGroup(group);
        server.insert("server_name", (settings.value("ServerName", "").toString()));
        server.insert("server_ip", (settings.value("ServerIP", "").toString()));
        server.insert("server_type", (settings.value("ServerType", "").toString()));
        settings.endGroup();

        temp_server_settings.push_back(server);
    }

    settings.endGroup();
    settings.endGroup();

    server_list.insert(QString("Servers"), QJsonValue(temp_server_settings));

    return server_list;
}

// Read server information from QSettings (Community only)
QJsonObject Launcher::get_server_information()
{
    QJsonArray temp_server_info;
    QJsonObject server_info;
    QSettings settings;

    settings.beginGroup("ServerConfig");
    settings.beginGroup("CommunityServers");

    for(const QString &group : settings.childGroups())
    {
        QJsonObject server;
        settings.beginGroup(group);
        server.insert("server_name", (settings.value("ServerName", "").toString()));
        server.insert("server_description", (settings.value("ServerDescription", "").toString()));
        server.insert("server_web_url", (settings.value("ServerWebURL", "").toString()));
        settings.endGroup();
        temp_server_info.push_back(server);
    }

    settings.endGroup();
    settings.endGroup();

    server_info.insert(QString("Servers"), QJsonValue(temp_server_info));
   // qDebug() << "Server Info OBJ: " << server_info;

    return server_info;

}

// Get Release notes
void Launcher::fetch_release_notes()
{
    m_release_notes_manager = new QNetworkAccessManager;
    QUrl url("https://api.github.com/repos/segs/segs/releases");
    QNetworkRequest request;
    request.setUrl(url);
    m_releases_network_reply = m_release_notes_manager->get(request);
    connect(m_release_notes_manager,&QNetworkAccessManager::finished,this,&Launcher::handle_releases_reply);
}

void Launcher::handle_releases_reply()
{

    {
        if(m_releases_network_reply->error() == QNetworkReply::NoError)
        {
            QByteArray reply = m_releases_network_reply->readAll();
            QJsonDocument jsonResponse = QJsonDocument::fromJson(reply);
            QJsonArray releases_array = jsonResponse.array();
            //QString version_number = VersionInfo::getAuthVersionNumber();
            QString version_number = "0.6.1";
            version_number.prepend("v");
            qDebug()<<version_number;

            for (const QJsonValue value : releases_array)
            {
                QJsonObject json_obj = value.toObject();

                if (json_obj["tag_name"] == version_number)
                {
                    m_release_info.insert("release_notes", json_obj["body"].toString());
                }
            }

            // Grab version string at same time
            m_release_info.insert("version_string", version_number +
                                  QString(" Outbreak"));

            emit fetchReleasesFinished();
        }
        else
        {
            qDebug()<<m_releases_network_reply->error();
            qDebug()<<"handle_releases_reply: Network Error";
        }
    }

}

// Returns release information to QML
QVariantMap Launcher::get_version_info()
{
    return m_release_info;
}

// Signals worker thread to start, function initiated from QML
void Launcher::start_server_status_worker()
{
    emit getServerStatus();
}

// Started once worker thread signals done
void Launcher::handle_server_status_worker(bool status, QString server, QString uptime)
{
    if(status == true)
    {
        m_server_name = server;
        m_server_status = true;
        m_server_uptime = uptime;
    }
    else
    {
        m_server_name = server;
        m_server_status = false;
    }

    // Signal to tell QML this is now ready to call and retrieve
    emit serverStatusReady();
}


// Called from QML to get server status once serverStatusReady signal is recieved
QVariantMap Launcher::is_server_online()
{
    QVariantMap server_status;
    server_status.insert("server_name", m_server_name);
    server_status.insert("server_status", m_server_status);
    server_status.insert("server_uptime", m_server_uptime);
    return server_status;
}

// Add a local server to QSettings
void Launcher::add_local_server(QVariantMap server)
{
    qDebug()<<"Adding to Local Server: "<<server["server_name"].toString()<<" + "<<server["server_ip"].toString();
    QSettings settings;
    settings.beginGroup("ServerConfig");
    settings.beginGroup("LocalServers");
    settings.beginGroup(server["server_name"].toString());
    settings.setValue("ServerName", server["server_name"]);
    settings.setValue("ServerIP", server["server_ip"]);
    settings.setValue("ServerType", "L");
    settings.endGroup();
    settings.endGroup();
    settings.endGroup();
}

// Write launcher / game settings to QSettings
void Launcher::set_launcher_game_settings(QVariantMap settings)
{
    QSettings segs_settings(QString(R"(HKEY_CURRENT_USER\Software\Cryptic\%1)").arg("SEGS"),
                            QSettings::NativeFormat);
    segs_settings.setValue("screenX", settings["screenX"].toString());
    segs_settings.setValue("screenY", settings["screenY"].toString());
    segs_settings.setValue("fullscreen", settings["fullscreen"].toString());
}
