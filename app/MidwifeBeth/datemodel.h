#ifndef DATEMODEL_H
#define DATEMODEL_H

#include <QObject>
#include <QDate>
#include <QTime>
#include <QDateTime>
#include <QDebug>

class DateModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int year READ year WRITE setYear NOTIFY yearChanged)
    Q_PROPERTY(int month READ month WRITE setMonth NOTIFY monthChanged)
    Q_PROPERTY(int day READ day WRITE setDay NOTIFY dayChanged)
    Q_PROPERTY(int daysInMonth READ daysInMonth NOTIFY daysInMonthChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(int hour READ hour WRITE setHour NOTIFY hourChanged)
    Q_PROPERTY(int minute READ minute WRITE setMinute NOTIFY minuteChanged)
public:
    explicit DateModel(QObject *parent = nullptr);
    //
    //
    //
    int year() const {
        return m_dateTime.date().year();
    }
    void setYear( const int year ) {
        QDate date = m_dateTime.date();
        if ( year != date.year() ) {
            int daysInMonthBefore = date.daysInMonth();
            date.setDate(year,date.month(),date.day());
            m_dateTime.setDate(date);
            emit yearChanged( year );
            emit dateChanged(m_dateTime);
            int daysInMonthAfter = date.daysInMonth();
            if ( daysInMonthBefore != daysInMonthAfter ) {
                emit daysInMonthChanged(daysInMonthAfter);
            }
        }
    }
    int month() const {
        return m_dateTime.date().month();
    }
    void setMonth( const int month ) {
        QDate date = m_dateTime.date();
        if ( month != date.month() ) {
            int daysInMonthBefore = date.daysInMonth();
            date.setDate(date.year(),month,date.day());
            m_dateTime.setDate(date);
            emit monthChanged( month );
            emit dateChanged(m_dateTime);
            int daysInMonthAfter = date.daysInMonth();
            if ( daysInMonthBefore != daysInMonthAfter ) {
                emit daysInMonthChanged(daysInMonthAfter);
            }
        }
    }
    int day() const {
        qDebug() << "DateModel::day : " << m_dateTime.date().day();
        return m_dateTime.date().day();
    }
    void setDay( const int day ) {
        QDate date = m_dateTime.date();
        if ( day != date.day() ) {
            date.setDate(date.year(),date.month(),day);
            m_dateTime.setDate(date);
            emit dayChanged( day );
            emit dateChanged(m_dateTime);
        }
    }
    int daysInMonth() const {
        return m_dateTime.date().daysInMonth();
    }
    QDateTime date() const {
        return m_dateTime;
    }
    void setDate( const QDateTime& dateTime ) {
        //if ( m_dateTime != dateTime ) {
        qDebug() << "DateModel::setDate : " << dateTime;
            m_dateTime = dateTime;
            emit yearChanged(year());
            emit monthChanged(month());
            emit dayChanged(day());
            emit dateChanged(m_dateTime);
        //}
    }
    int hour() const {
        qDebug() << "DateModel::hour : " << m_dateTime.time().hour();
        return m_dateTime.time().hour();
    }
    void setHour( const int hour ) {
        qDebug() << "DateModel::setHour : " << hour;
        QTime time = m_dateTime.time();
        if ( hour != time.hour() ) {
            time.setHMS(hour,time.minute(),0);
            m_dateTime.setTime(time);
            emit hourChanged( hour );
            emit dateChanged(m_dateTime);
        }
    }
    int minute() const {
        return m_dateTime.time().minute();
    }
    void setMinute( const int minute ) {
        QTime time = m_dateTime.time();
        if ( minute != time.minute() ) {
            time.setHMS(time.hour(),minute,0);
            m_dateTime.setTime(time);
            emit minuteChanged( minute );
            emit dateChanged(m_dateTime);
        }
    }
signals:
    void yearChanged( int year );
    void monthChanged( int month );
    void dayChanged( int day );
    void daysInMonthChanged( int day );
    void dateChanged( QDateTime date );
    void hourChanged( int hours );
    void minuteChanged( int minutes );

public slots:

private:
    QDateTime m_dateTime;
};

#endif // DATEMODEL_H
