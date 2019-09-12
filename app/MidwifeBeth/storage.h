#ifndef STORAGE_H
#define STORAGE_H

#include <QObject>
#include <QOAuth2AuthorizationCodeFlow>

class Storage : public QObject
{
    Q_OBJECT
public:
    explicit Storage(QObject *parent = nullptr);

signals:

public slots:
};

#endif // STORAGE_H
