#include "enabler.h"

Enabler::Enabler(QObject *parent) : QObject(parent)
{

}
void Enabler::EnableAutostart()
{
    if (fileExists(QDir::homePath() + ".config/autostart/welcome.desktop")) {
        QFile file(QDir::homePath() + ".config/autostart/welcome.desktop");

        file.remove();
    }
}

void Enabler::DisableAutostart()
{
    QFile::copy("/usr/share/welcome/welcome-disabled.desktop", QDir::homePath() + ".config/autostart/welcome.desktop");
}
bool fileExists(QString path)
{
    QFileInfo check_file(path);

    if (check_file.exists() && check_file.isFile()) {
        return true;
    } else {
        return false;
    }
}
