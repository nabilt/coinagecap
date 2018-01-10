#include <QDebug>
#include "sortfilterproxymodel.h"

SortFilterProxyModel::SortFilterProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent),
      m_onlyShowChecked(false)
{
    //setDynamicSortFilter(false);
}

void SortFilterProxyModel::sort(int column, Qt::SortOrder order)
{
    // Wihtout this the QML listview will run animations on sort
    beginResetModel();
    QSortFilterProxyModel::sort(column, order);
    endResetModel();
}

int SortFilterProxyModel::sortRole() const
{
    return QSortFilterProxyModel::sortRole();
}

void SortFilterProxyModel::setSortRole(int role)
{
    QSortFilterProxyModel::setSortRole(role);
    emit sortRoleChanged();
}

bool SortFilterProxyModel::getOnlyShowChecked()
{
    return m_onlyShowChecked;
}

void SortFilterProxyModel::setOnlyShowChecked(bool state)
{
    m_onlyShowChecked = state;
    emit onlyShowCheckedChanged();
}

bool SortFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const  {
    bool ret = QSortFilterProxyModel::filterAcceptsRow(sourceRow, sourceParent);

    QModelIndex index0 = sourceModel()->index(sourceRow, 0, sourceParent);

    if (m_onlyShowChecked) {
        QVariant v = sourceModel()->data(index0, Qt::CheckStateRole);
        ret = v.toBool() && ret;
    }

    return ret;
}
