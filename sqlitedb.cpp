#include "sqlitedb.h"

SqliteDB::SqliteDB(QObject *parent) : QObject(parent)
{
    if (QSqlDatabase::isDriverAvailable("QSQLITE"))
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName("db.qsqlite");

        if(!db.open()) qDebug("Error opening database");

        QSqlQuery qry;
        if (!db.tables().contains("users")) qry.exec("CREATE TABLE users (id INTEGER PRIMARY KEY, medctr_id TEXT UNIQUE);");
        if (!db.tables().contains("campaigns")) qry.exec("CREATE TABLE campaigns (id INTEGER PRIMARY KEY, date DATE UNIQUE);");
        if (!db.tables().contains("user_campaign")) qry.exec("CREATE TABLE user_campaign (id INTEGER PRIMARY KEY, user_id INTEGER, campaign_id INTEGER, FOREIGN KEY(user_id) REFERENCES users(id), FOREIGN key(campaign_id) REFERENCES campaigns(id));");

        if (!qry.exec("INSERT OR IGNORE INTO users (medctr_id) VALUES ('test1');")) qDebug() << "Error inserting into users: " << qry.lastError();
        if (!qry.exec("INSERT OR IGNORE INTO users (medctr_id) VALUES ('test2');")) qDebug() << "Error inserting into users: " << qry.lastError();
        if (!qry.exec("INSERT OR IGNORE INTO users (medctr_id) VALUES ('testing testing testing');")) qDebug() << "Error inserting into users: " << qry.lastError();

        if (!qry.exec("INSERT OR IGNORE INTO campaigns (date) VALUES ('2000-01-01');")) qDebug() << "Error inserting into campaigns: " << qry.lastError();
        if (!qry.exec("INSERT OR IGNORE INTO campaigns (date) VALUES ('2000-01-02');")) qDebug() << "Error inserting into campaigns: " << qry.lastError();
        if (!qry.exec("INSERT OR IGNORE INTO campaigns (date) VALUES ('2000-01-03');")) qDebug() << "Error inserting into campaigns: " << qry.lastError();
        if (!qry.exec("INSERT OR IGNORE INTO campaigns (date) VALUES ('2000-01-04');")) qDebug() << "Error inserting into campaigns: " << qry.lastError();
    }

}


// ------------------------------------------------
// Users Table Methods
// ------------------------------------------------

QVariantList SqliteDB::getUsersIds()
{
    QVariantList usersIds;
    QSqlQuery qry;

    if (!qry.exec("SELECT id FROM users;")) qDebug() << "Error selecting id from users: " << qry.lastError();

    while(qry.next()) {
        QVariantMap row;
        row["id"] = qry.value(0).toString();
        usersIds.push_back(row);
    }

    return usersIds;
}


QVariantList SqliteDB::getUsersMedctrIds()
{
    QVariantList usersMedctrIds;
    QSqlQuery qry;

    if (!qry.exec("SELECT medctr_id FROM users;")) qDebug() << "Error selecting medctr_id from users: " << qry.lastError();

    while(qry.next()) {
        QVariantMap row;
        row["medctr_id"] = qry.value(0).toString();
        usersMedctrIds.push_back(row);
    }

    return usersMedctrIds;
}

// ------------------------------------------------
// Campaigns Table Methods
// ------------------------------------------------

QVariantList SqliteDB::getCampaignsIds()
{
    QVariantList campaignsIds;
    QSqlQuery qry;

    if (!qry.exec("SELECT id  FROM campaigns;")) qDebug() << "Error selecting id from campaigns: " << qry.lastError();

    while(qry.next()) {
        QVariantMap row;
        row["id"] = qry.value(0).toString();
        campaignsIds.push_back(row);
    }

    return campaignsIds;
}

QVariantList SqliteDB::getCampaignsDates()
{
    QVariantList campaignsDates;
    QSqlQuery qry;

    if (!qry.exec("SELECT date FROM campaigns;")) qDebug() << "Error selecting date from campaigns: " << qry.lastError();

    while(qry.next()) {
        QVariantMap row;
        row["date"] = qry.value(0).toString();
        campaignsDates.push_back(row);
    }

    return campaignsDates;
}

// ------------------------------------------------
// User_Campaign Table Methods
// ------------------------------------------------

QVariantList SqliteDB::getUserCampaignIds()
{
    QVariantList userCampaignIds;
    QSqlQuery qry;

    if (!qry.exec("SELECT id FROM user_campaign;")) qDebug() << "Error selecting id from user_campaign: " << qry.lastError();

    while(qry.next()) {
        QVariantMap row;
        row["id"] = qry.value(0).toString();
        userCampaignIds.push_back(row);
    }

    return userCampaignIds;
}

QVariantList SqliteDB::getUserCampaignUserIds()
{
    QVariantList userCampaignUserIds;
    QSqlQuery qry;

    if (!qry.exec("SELECT user_id FROM user_campaign;")) qDebug() << "Error selecting user_id from user_campaign: " << qry.lastError();

    while (qry.next()) {
        QVariantMap row;
        row["user_id"] = qry.value(0).toString();
        userCampaignUserIds.push_back(row);
    }

    return userCampaignUserIds;
}

QVariantList SqliteDB::getUserCampaignCampaignIds()
{
    QVariantList userCampaignCampaignids;
    QSqlQuery qry;

    if (!qry.exec("SELECT campaign_id FROM user_campaign;")) qDebug() << "Error selecting campaign_id from user_campaign: " << qry.lastError();

    while (qry.next()) {
        QVariantMap row;
        row["campaign_id"] = qry.value(0).toString();
        userCampaignCampaignids.push_back(row);
    }

    return userCampaignCampaignids;
}

// -------------------
// DropData page
// -------------------

void SqliteDB::cleanDroppedData(QString data)
{
    QSqlQuery qry;
    QStringList tabSplit = data.split("\t");
    for (int i = 0; i < tabSplit.size(); i++) {
        if (tabSplit[i].contains("User Account Compromised")) {
            QStringList hyphenSplit = tabSplit[i].split(" - ");
            if (!qry.exec("INSERT OR IGNORE INTO users (medctr_id) VALUES ('" + hyphenSplit[0] + "');")) qDebug() << "Error inserting into users: " << qry.lastError();
            qDebug() << hyphenSplit[0];
//            insertUserCampaign(hyphenSplit[0]);
        }
    }
}

//void SqliteDB::insertUserCampaign(QString medctr_id)
//{
//    QSqlQuery qry;
//    QString submittedDate = ui->dateEdit->date().toString();
//    if (!qry.exec("INSERT INTO user_campaign (user_id, campaign_id) SELECT users.id, campaigns.id FROM users, campaigns WHERE users.medctr_id='" + medctr_id + "' AND campaigns.date='" + submittedDate + "';"))
//        qDebug() << "Error inserting into user_campaign: " << qry.lastError();
//}
