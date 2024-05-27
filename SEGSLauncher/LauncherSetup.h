#pragma once

#include <QObject>
#include <QVariantMap>

class LauncherSetup : public QObject
{
    Q_OBJECT

public:
    explicit LauncherSetup(QObject *parent = nullptr);
    void get_cox_directory();
    void verify_client_version();
    Q_INVOKABLE QVariantMap read_launcher_settings();
    Q_INVOKABLE void write_launcher_settings(QVariantMap launcher_settings);
    //Q_INVOKABLE void verify_client_version(QString cox_dir);
signals:


public slots:

private:
};
