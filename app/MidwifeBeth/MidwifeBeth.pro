QT += quick multimedia websockets networkauth

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    databaselist.h \
    datemodel.h \
    rangemodel.h \
    storage.h \
    systemutils.h \
    downloader.h \
    cachedimageprovider.h \
    cachedmediasource.h \
    cachedtee.h \
    networkaccess.h

SOURCES += \
    datemodel.cpp \
    ios/galleryutils.mm \
    main.cpp \
    databaselist.cpp \
    rangemodel.cpp \
    storage.cpp \
    systemutils.cpp \
    downloader.cpp \
    cachedimageprovider.cpp \
    cachedmediasource.cpp \
    cachedtee.cpp \
    networkaccess.cpp

RESOURCES = midwifebeth.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


ios {
    QMAKE_TARGET_BUNDLE_PREFIX = uk.co.soda
    QMAKE_INFO_PLIST = ios/Info.plist
    ios_icon.files = $$files($$PWD/ios/icons/Icon-App*.png)
    QMAKE_BUNDLE_DATA += ios_icon
    ios_launch.files = $$PWD/ios/Launch.storyboard $$PWD/ios/LaunchBackground.png $$PWD/ios/LaunchLogo.png
    QMAKE_BUNDLE_DATA += ios_launch
    QMAKE_ASSET_CATALOGS += ios/Images.xcassets

    OBJECTIVE_SOURCES += ios/galleryutils.mm
    LIBS += -framework Foundation -framework UIKit -framework AssetsLibrary -framework Photos

}

# Android OpenSSL
contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS += /Users/jonathanjones-morris/Documents/Developer/openssl-libraries/arm/libcrypto.so
    ANDROID_EXTRA_LIBS += /Users/jonathanjones-morris/Documents/Developer/openssl-libraries/arm/libssl.so
}
contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_EXTRA_LIBS += /Users/jonathanjones-morris/Documents/Developer/openssl-libraries/arm64/libcrypto.so
    ANDROID_EXTRA_LIBS += /Users/jonathanjones-morris/Documents/Developer/openssl-libraries/arm64/libssl.so
}
