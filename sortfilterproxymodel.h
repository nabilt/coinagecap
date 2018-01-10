#ifndef SORTFILTERPROXYMODEL_H
#define SORTFILTERPROXYMODEL_H

#include <QSortFilterProxyModel>

class SortFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    Q_PROPERTY(int sortRole READ sortRole WRITE setSortRole NOTIFY sortRoleChanged)
    Q_PROPERTY(bool onlyShowChecked READ getOnlyShowChecked WRITE setOnlyShowChecked NOTIFY onlyShowCheckedChanged)

public:
    explicit SortFilterProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void sort(int column, Qt::SortOrder order = Qt::AscendingOrder);
    int sortRole() const;
    void setSortRole(int role);

    bool getOnlyShowChecked();
    void setOnlyShowChecked(bool state);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const  override;

signals:
    void sortRoleChanged();
    void onlyShowCheckedChanged();

private:
    bool m_onlyShowChecked;
};

#endif // SORTFILTERPROXYMODEL_H
