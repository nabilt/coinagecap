#include "dynamicrolemodel.h"
#include <QDebug>

DynamicRoleModel::DynamicRoleModel(QObject *parent)
    : QAbstractListModel(parent),
      m_next_role(Qt::UserRole + 1)
{
}

void DynamicRoleModel::sort(int role, Qt::SortOrder order)
{
//beginMoveRows
}

int DynamicRoleModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.length();
}

void DynamicRoleModel::beginInsert()
{
    m_updateList.clear();
    for (int i = 0; i < m_data.length(); i++) {
        QVariant v = m_data.at(i)[m_roles["id"]];
        m_updateList.insert(v.toString());
    }
}
void DynamicRoleModel::endInsert()
{
    // Remove items that were not updated
    for (int i = 0; i < m_data.length(); i++) {
        QVariant v = m_data.at(i)[m_roles["id"]];
        //qDebug() << m_data.at(i)[m_roles["rank"]].toInt() << v.toString() << i;
        if (m_updateList.contains(v.toString())) {
            //qDebug() << "\tRemoved index" << i << v;
            beginRemoveRows(QModelIndex(), i, i);
            m_data.removeAt(i);
            i--;
            endRemoveRows();
        }
    }
}

void DynamicRoleModel::addRole(const QString& name, int role = -1)
{
    if (!m_roles.contains(name))
    {
        if (role == -1) {
            m_roles[name] = m_next_role;
            m_next_role++;
        } else {
            m_roles[name] = role;
        }
        emit roleNameChanged();
    }
}

bool DynamicRoleModel::addItem(const QMap<QString, QVariant> &coin)
{
    QMap<int, QVariant> v;
    int lastRoleIndex = m_next_role;
    QMap<QString, QVariant>::const_iterator i = coin.constBegin();
    while (i != coin.constEnd()) {
        if (!m_roles.contains(i.key())) {
            if (i.key() == "name") {
                m_roles[i.key()] = Qt::DisplayRole;
            } else {
                m_roles[i.key()] = m_next_role;
                m_next_role++;
            }
        }
        v[m_roles[i.key()]] = i.value();
        ++i;
    }
    if (lastRoleIndex != m_next_role)
        emit roleNameChanged();

    // Try to update list instead of appending if possible.
    // Assumes "id" role exists to match items
    if (m_roles.contains("id")) {
        for(int k = 0; k < m_data.size(); k++) {
            int id_role = m_roles["id"];
            if (!m_data[k].contains(id_role)) {
                qDebug() << "Missing ID" << m_data[k];
                continue;
            }
            if (m_data[k][id_role] == v[id_role]) {
                QVector<int> updatedRoles;
                QMap<int, QVariant>::const_iterator i = v.constBegin();
                while (i != v.constEnd()) {
                    m_data[k][i.key()] = i.value();
                    updatedRoles.append(i.key());
                    i++;
                }
                emit dataChanged(index(k),index(k), updatedRoles);
                m_updateList.remove(v[id_role].toString());
                return true;
            }
        }
    }

    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data.append(v);
    m_updateList.remove(v[m_roles["id"]].toString());
    endInsertRows();
    return false;
}

QVariant DynamicRoleModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    QMap<int,QVariant> map_value = m_data[index.row()];
    if (!map_value.contains(role))
        return QVariant();

    return map_value[role];
}

bool DynamicRoleModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    int row = index.row();
    if (row >= 0 && row < m_data.count()) {
        m_data[row][role] = value;
        emit dataChanged(index,index, QVector<int>(role));
        return true;
    }
    return false;
}

int DynamicRoleModel::roleValue(const QString &key)
{
    if (!m_roles.contains(key)) {
        return -1;
    }
    return m_roles[key];
}

QVariantMap DynamicRoleModel::getRoleNames()
{
    QVariantMap roles;
    QMap<QString, int>::const_iterator i = m_roles.constBegin();
    while (i != m_roles.constEnd()) {
        roles.insert(QString::number(i.value()), i.key());
        i++;
    }
    return roles;
}

QVariantList DynamicRoleModel::exportData()
{
    QVariantList list;
    for(int k = 0; k < m_data.size(); k++) {
        QVariantMap row;
        QMap<QString, int>::const_iterator i = m_roles.constBegin();
        while (i != m_roles.constEnd()) {
            row[i.key()] = m_data[k][i.value()];
            i++;
        }
        list.append(row);
    }
    return list;
}

QHash<int, QByteArray> DynamicRoleModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    QMap<QString, int>::const_iterator i = m_roles.constBegin();
    while (i != m_roles.constEnd()) {
        roles[i.value()] = i.key().toStdString().c_str();
        i++;
    }
    return roles;
}
