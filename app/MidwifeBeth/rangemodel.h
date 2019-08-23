#ifndef RANGEMODEL_H
#define RANGEMODEL_H

#include <QAbstractListModel>

class RangeModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int from MEMBER m_from)
    Q_PROPERTY(int to MEMBER m_to)
public:
    explicit RangeModel(QObject *parent = nullptr);
    //
    // QAbstractListModel overrides
    //
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

signals:

public slots:
    int get( const int index ) const {
        return index < 0 || index > rowCount() ? -1 : m_from + index;
    }
private:
    int m_from;
    int m_to;
};

#endif // RANGEMODEL_H
