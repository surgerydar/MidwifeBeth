#include "datemodel.h"

DateModel::DateModel(QObject *parent) : QObject(parent),  m_dateTime(QDateTime::currentDateTime()) {
}
