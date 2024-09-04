#pragma once

#include <QObject>

class Worker : public QObject
{
    Q_OBJECT
public:
    explicit Worker(QObject *parent = nullptr);
    ~Worker() override;
    void fetch_server_status(const QString &auth_addr, const QString &server_name);

signals:
    void serverStatusWorkerReady(bool status, QString server, QString uptime = "?");


public slots:
    void server_status_dispatcher();

private:
    int m_rpc_timeout = 5000; // Milliseconds (5 Seconds)
};

