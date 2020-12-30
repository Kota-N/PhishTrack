#ifndef SQLITEDB_H
#define SQLITEDB_H

#include <QObject>

#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlQuery>
#include <QSqlError>

#include <QFile>
#include <QTextStream>

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

    Q_INVOKABLE QVariantList getDataForMainPage();

    Q_INVOKABLE void exportCSV(QString folderPath);

    Q_INVOKABLE void setSelectedDate(QString date);

    Q_INVOKABLE void cleanDataAndInsertIntoUsers(QString data);
    void insertDateIntoCampaigns(QString date);
    void insertUserCampaign(QString medctr_id);

signals:
};

#endif // SQLITEDB_H
