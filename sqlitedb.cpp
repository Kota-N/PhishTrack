#include "sqlitedb.h"

QString dbFilePath = "/Users/user/Desktop/phishtrack.sqlite";

SqliteDB::SqliteDB(QObject *parent) : QObject(parent)
{
    if (QSqlDatabase::isDriverAvailable("QSQLITE"))
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName("phishtrack.sqlite");

        if(!db.open()) qDebug("Error opening database");

        QSqlQuery qry;
        if (!db.tables().contains("users")) qry.exec("CREATE TABLE users (id INTEGER PRIMARY KEY, medctr_id TEXT UNIQUE);");
        if (!db.tables().contains("campaigns")) qry.exec("CREATE TABLE campaigns (id INTEGER PRIMARY KEY, date DATE UNIQUE);");
        if (!db.tables().contains("user_campaign")) qry.exec("CREATE TABLE user_campaign (id INTEGER PRIMARY KEY, user_id INTEGER, campaign_id INTEGER, FOREIGN KEY(user_id) REFERENCES users(id), FOREIGN key(campaign_id) REFERENCES campaigns(id));");

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

QVariantList SqliteDB::getDataForMainPage()
{
    QVariantList dataForMainPage;
    QVariantList medctrIdColumn;
    QVariantList countColumn;
    QVariantList dateColumn;
    QSqlQuery qry;

    if (!qry.exec("SELECT users.medctr_id, COUNT(campaigns.date) AS count, group_concat(campaigns.date) AS date FROM users JOIN user_campaign ON users.id = user_campaign.user_id JOIN campaigns ON campaigns.id = user_campaign.campaign_id GROUP BY users.medctr_id ORDER BY count DESC, medctr_id ASC")) qDebug() << "Error selecting and joining tables: " << qry.lastError();

    while(qry.next()) {
        QVariantMap medctrIdRow;
        QVariantMap countRow;
        QVariantMap dateRow;
        medctrIdRow["medctr_id"] = qry.value(0).toString();
        countRow["count"] = qry.value(1).toString();
        dateRow["date"] = qry.value(2).toString();
        medctrIdColumn.push_back(medctrIdRow);
        countColumn.push_back(countRow);
        dateColumn.push_back(dateRow);
    }

    dataForMainPage.push_back(medctrIdColumn);
    dataForMainPage.push_back(countColumn);
    dataForMainPage.push_back(dateColumn);

    return dataForMainPage;
}

void SqliteDB::exportCSV(QString folderPath)
{
    getDataForMainPage();

    QFile file("/" + folderPath + "/phishtrack.csv");
    if (file.open(QFile::WriteOnly | QFile::Text)) {
        QSqlQuery qry;
        QTextStream out(&file);

        out << "medctr_id,count,date\n";

        if (!qry.exec("SELECT users.medctr_id, COUNT(campaigns.date) AS count, group_concat(campaigns.date) AS date FROM users JOIN user_campaign ON users.id = user_campaign.user_id JOIN campaigns ON campaigns.id = user_campaign.campaign_id GROUP BY users.medctr_id ORDER BY count DESC, medctr_id ASC")) qDebug() << "Error selecting and joining tables: " << qry.lastError();

        while(qry.next()) {
            QString medctrId = qry.value(0).toString();
            QString count = qry.value(1).toString();
            QString date = qry.value(2).toString();
            out << medctrId + "," + count + "," + "\"" + date + "\"\n";
        }

        file.flush();
        file.close();
    }
}

// -------------------
// DropData page
// -------------------

QString currentDate;

void SqliteDB::setSelectedDate(QString date)
{
    currentDate = date;
}

void SqliteDB::cleanDataAndInsertIntoUsers(QString data)
{
    insertDateIntoCampaigns(currentDate);
    QSqlQuery qry;
    QStringList tabSplit = data.split("\t");
    for (int i = 0; i < tabSplit.size(); i++) {
        if (tabSplit[i].contains("User Account Compromised")) {
            QStringList hyphenSplit = tabSplit[i].split(" - ");
            if (!qry.exec("INSERT OR IGNORE INTO users (medctr_id) VALUES ('" + hyphenSplit[0] + "');")) qDebug() << "Error inserting into users: " << qry.lastError();
            insertUserCampaign(hyphenSplit[0]);
        }
    }

}

void SqliteDB::insertDateIntoCampaigns(QString date)
{
    QSqlQuery qry;
    if (!qry.exec("INSERT OR IGNORE INTO campaigns (date) VALUES ('" + date + "');")) qDebug() << "Error inserting into campaigns: " << qry.lastError();

}


void SqliteDB::insertUserCampaign(QString medctr_id)
{
    QSqlQuery qry;
    if (!qry.exec("INSERT INTO user_campaign (user_id, campaign_id) SELECT users.id, campaigns.id FROM users, campaigns WHERE users.medctr_id='" + medctr_id + "' AND campaigns.date='" + currentDate + "';"))
        qDebug() << "Error inserting into user_campaign: " << qry.lastError();
}
