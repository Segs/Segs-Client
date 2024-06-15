#pragma once

#include <QObject>
#include <QVariantMap>
#include <QVersionNumber>

class QNetworkAccessManager;
class QNetworkReply;

class LauncherSetup : public QObject
{
    Q_OBJECT
    // make the version and changelogs available to qml
    Q_PROPERTY(QVersionNumber latest_version READ get_latest_version NOTIFY newVersionAvailable)
    Q_PROPERTY(QStringList changelogs READ get_changelogs NOTIFY newVersionAvailable)
public:
    explicit LauncherSetup(QObject *parent = nullptr);
    ~LauncherSetup() override;
    Q_INVOKABLE void prepare_launcher_setup(const QString &channel);
    Q_INVOKABLE QVariantMap read_launcher_settings();
    Q_INVOKABLE void write_launcher_settings(QVariantMap launcher_settings);
    //Q_INVOKABLE void verify_client_version(QString cox_dir);
    Q_INVOKABLE void check_for_new_version();
    QVersionNumber get_latest_version() const { return m_latest_version; }
    QStringList get_changelogs() const { return m_changelogs; }
signals:
    void newVersionAvailable(QVersionNumber version);

public slots:
private slots:
    void version_check_finished(QNetworkReply *reply);
private:
    constexpr static const char *launcher_version_url = "https://segs.dev/launcher_version.json";
    QString m_channel;
    QVersionNumber m_latest_version;
    QStringList m_changelogs;

    QNetworkAccessManager *m_net_manager=nullptr;
};
