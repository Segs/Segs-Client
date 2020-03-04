#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <QVariantMap>
#include <QNetworkReply>
#include <QJsonArray>
#include <QJsonObject>
#include <QThread>

class Launcher : public QObject
{
    Q_OBJECT

public:
    explicit Launcher(QObject *parent = nullptr);
    virtual ~Launcher();
    void fetch_server_status();
    Q_INVOKABLE void launch_cox();
    Q_INVOKABLE void launch_segsadmin();
    Q_INVOKABLE void set_server(QVariantMap server_details);
    Q_INVOKABLE void set_launcher_game_settings(QVariantMap settings);
    Q_INVOKABLE void fetch_community_servers();
    Q_INVOKABLE void fetch_release_notes();
    Q_INVOKABLE void start_server_status_worker();
    Q_INVOKABLE void add_local_server(QVariantMap server);
    Q_INVOKABLE QVariantMap is_server_online();
    Q_INVOKABLE QVariantMap get_version_info();
    Q_INVOKABLE QVariantMap get_last_used_server();
    Q_INVOKABLE QJsonObject get_server_list();
    Q_INVOKABLE QJsonObject get_server_information();


private:
    QProcess *m_start_cox;
    QProcess *m_start_segsadmin;
    QNetworkReply *m_servers_network_reply;
    QNetworkReply *m_releases_network_reply;
    QNetworkAccessManager *m_community_servers_manager;
    QNetworkAccessManager *m_release_notes_manager;
    QJsonObject m_server_list;
    QVariantMap m_release_info;
    QVariant m_server_uptime;
    QString m_server_name;
    QThread worker_thread; // Move to Private -- test it
    bool m_server_status;

signals:
    void fetchServerListFinished();
    void fetchReleasesFinished();
    void getServerStatus();
    void serverStatusReady();

public slots:
    void handle_servers_reply();
    void handle_releases_reply();
    void handle_server_status_worker(bool status, QString server, QString uptime = "?");

};

#endif // LAUNCHER_H
