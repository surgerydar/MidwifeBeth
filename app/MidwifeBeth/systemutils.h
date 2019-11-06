#ifndef SYSTEMUTILS_H
#define SYSTEMUTILS_H

#include <QObject>
#include <QThread>


class SystemUtils : public QObject
{
    Q_OBJECT
public:
    explicit SystemUtils(QObject *parent = nullptr);
    static SystemUtils* shared();

private:
    static SystemUtils* s_shared;

public slots:
    bool isFirstRun();
    //
    //
    //
    QString applicationDirectory();
    QString documentDirectory();
    QString temporaryDirectory();
    //
    //
    //
    QString documentPath( const QString& filename );
    QString mediaPath( const QString& filename );
    QString toLocalPath( const QString& path );
    //
    //
    //
    bool fileExists( const QString& path );
    bool copyFile( const QString& from, const QString& to, bool force = false );
    bool moveFile( const QString& from, const QString& to, bool force = false );
    bool removeFile( const QString& path );
    //
    //
    //
    QString urlFilename( const QUrl& url );
    QString urlPath( const QUrl& url );
    QString urlHost( const QUrl& url );
    QString urlProtocol( const QUrl& url );
    //
    //
    //
    QString copyImageFromGallery( const QString& url );
    //
    //
    //
    QString mimeTypeForFile( QString filename );
    //
    //
    //
    qreal pointToPixel( qreal point );
    qreal pixelToPoint( qreal pixel );
    //
    //
    //
    int textHeight( const QString &text, const QFont &font, const int maxWidth );
    //
    //
    //
    bool rotateImage( const QString& path, const qreal& rotation );
};

#endif // SYSTEMUTILS_H
