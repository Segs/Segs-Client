#ifndef MEDIAMANAGER_H
#define MEDIAMANAGER_H

#include <QObject>

class MediaManager : public QObject
{
    Q_OBJECT

public:
    explicit MediaManager(QObject *parent = nullptr);

signals:

public slots:
    void playStartupSound();

};

#endif // MEDIAMANAGER_H
