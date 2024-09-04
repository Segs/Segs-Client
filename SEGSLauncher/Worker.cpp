#include "Worker.h"

#include "jcon/json_rpc_tcp_client.h"

#include <QDebug>
#include <QSettings>
#include <QTime>
#include <QDateTime>
#include <QVariant>

Worker::Worker(QObject *parent) : QObject(parent)
{

}

Worker::~Worker()
{

}

// Dispatch each server to get server status
void Worker::server_status_dispatcher()
{
    QSettings settings;
    settings.beginGroup("ServerConfig");
    settings.beginGroup("CommunityServers");
    for(const QString &group : settings.childGroups())
    {
            settings.beginGroup(group);
            qDebug()<<"Dispatching: "<<group;
            QString server_auth_addr = settings.value("ServerIP", "").toString();
            QString server_name = settings.value("ServerName", "").toString();
            fetch_server_status(server_auth_addr, server_name);
            settings.endGroup();
    }
    settings.endGroup();
    settings.beginGroup("LocalServers");
    for(const QString &group : settings.childGroups())
    {
        settings.beginGroup(group);
        qDebug()<<"Dispatching: "<<group;
        QString server_auth_addr = settings.value("ServerIP", "").toString();
        QString server_name = settings.value("ServerName", "").toString();
        fetch_server_status(server_auth_addr, server_name);
        settings.endGroup();
    }
    settings.endGroup();
    settings.endGroup();

}

// AdminRPC call to server
void Worker::fetch_server_status(const QString &auth_addr, const QString &server_name)
{
    QString uptime;
    qDebug()<<"RPC Client connecting to: "<<auth_addr;
    auto rpc_client = new jcon::JsonRpcTcpClient(this);
    if (!rpc_client->connectToServer(auth_addr, 6001))
    {
        qDebug() << "Unable to connect to RPC server";
        emit serverStatusWorkerReady(false, server_name);
        return;
    }
        qDebug()<<"Connected to RPC Server";
            auto result = rpc_client->call("ping");
            if (result->isSuccess())
            {
                auto result_2 = rpc_client->call("getStartTime");
                if (result_2->isSuccess())
                {
                    QVariant res_2 = result_2->result();
                    QDateTime start_date(QDateTime::fromSecsSinceEpoch(res_2.toInt()));
                    QDateTime current_date(QDateTime::currentDateTime());
                    QString uptime_days = QString::number(start_date.daysTo(current_date));
            qDebug() << "Uptime for: " << server_name << " is " << uptime_days;
            emit serverStatusWorkerReady(true, server_name, uptime_days);
                }
                else
                {
                    QString err_str = result->toString();
                    qDebug() << "Result: " << err_str;
                    emit serverStatusWorkerReady(false, server_name);
                }
            }
            else
            {
                QString err_str = result->toString();
                qDebug() << "Result: " << err_str;
                emit serverStatusWorkerReady(false, server_name);
            }
    }


