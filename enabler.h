#ifndef ENABLER_H
#define ENABLER_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QFileInfo>

class Enabler : public QObject
{
    Q_OBJECT
public:
    explicit Enabler(QObject *parent = nullptr);
    Q_INVOKABLE void EnableAutostart();
    Q_INVOKABLE void DisableAutostart();
private:
    bool fileExists(QString path);

signals:

public slots:
};

#endif // ENABLER_H
