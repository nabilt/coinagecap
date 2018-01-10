#ifndef DYNAMICROLEMODEL_H
#define DYNAMICROLEMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QMap>
#include <QVariant>
#include <QSet>
#include <QHash>
#include <QVariantMap>

class DynamicRoleModel : public QAbstractListModel
{
    Q_OBJECT

public:

    Q_PROPERTY(QVariantMap roleNames READ getRoleNames NOTIFY roleNameChanged)

    explicit DynamicRoleModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    Q_INVOKABLE void beginInsert();
    Q_INVOKABLE void endInsert();
    Q_INVOKABLE bool addItem(const QMap<QString, QVariant> &coin);
    Q_INVOKABLE int roleValue(const QString &key);
    QVariantMap getRoleNames();
    Q_INVOKABLE void addRole(const QString& name, int role);
    Q_INVOKABLE QVariantList exportData();
    Q_INVOKABLE void sort(int role, Qt::SortOrder order);

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);
signals:
    void roleNameChanged();

protected:
    QHash<int, QByteArray> roleNames() const;
private:
    int m_next_role;
    QList<QMap<int, QVariant>> m_data;
    QMap<QString, int> m_roles;
    QSet<QString> m_updateList;

};

#endif // DYNAMICROLEMODEL_H
