#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <QVariant>

class Worker : public QObject
{
    Q_OBJECT
public:
    explicit Worker(QObject *parent = nullptr);
    virtual ~Worker();
    void fetch_server_status(QString auth_addr, QString server_name);

private:
    int m_rpc_timeout = 5000; // Milliseconds (5 Seconds)

signals:
    void serverStatusWorkerReady(bool status, QString server, QString uptime = "?");


public slots:
    void server_status_dispatcher();

};

#endif // WORKER_H
