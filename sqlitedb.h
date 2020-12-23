#ifndef SQLITEDB_H
#define SQLITEDB_H

#include <QObject>

#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

class SqliteDB : public QObject
{
    Q_OBJECT


public:
    explicit SqliteDB(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getUsersIds();
    Q_INVOKABLE QVariantList getUsersMedctrIds();

    Q_INVOKABLE QVariantList getCampaignsIds();
    Q_INVOKABLE QVariantList getCampaignsDates();

    Q_INVOKABLE QVariantList getUserCampaignIds();
    Q_INVOKABLE QVariantList getUserCampaignUserIds();
    Q_INVOKABLE QVariantList getUserCampaignCampaignIds();

    Q_INVOKABLE void cleanDroppedData(QString data);

//    void insertUserCampaign(QString medctr_id);

signals:

};

#endif // SQLITEDB_H
