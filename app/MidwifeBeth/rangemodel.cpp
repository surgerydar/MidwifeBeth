#include "rangemodel.h"

RangeModel::RangeModel(QObject *parent) : QAbstractListModel(parent) {

}
//
// QAbstractListModel overrides
//
QHash<int, QByteArray> RangeModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[ 0 ] = QByteArray("value");
    return roles;
}
int RangeModel::rowCount(const QModelIndex & /*parent*/) const {
    return ( m_to - m_from ) + 1;
}
QVariant RangeModel::data(const QModelIndex &index, int /*role*/) const {
    return QVariant::fromValue(m_from+index.row());
}
