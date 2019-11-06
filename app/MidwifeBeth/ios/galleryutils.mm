#include <QString>
#include <QFile>
#include <QDebug>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

bool _copyImageFromGallery(const QString& source, const QString& target ) {
    qDebug("_copyImageFromGallery : start");
    QString decodedSource = QString(source).replace( "%3F", "?");
    NSURL* url = [[NSURL alloc] initWithString:decodedSource.toNSString()];
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithALAssetURLs:@[url] options: nil];
    NSLog(@"_copyImageFromGallery : found %d assets matching %@", [assets count], decodedSource.toNSString());
    if ( [assets count] > 0 ) {
        qDebug("_copyImageFromGallery : got assets");
        PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset: [assets firstObject]
                                                               targetSize:PHImageManagerMaximumSize
                                                               contentMode:PHImageContentModeDefault
                                                               options: options
                                                               resultHandler:^(UIImage *image, NSDictionary *info){
                                                                    qDebug("_copyImageFromGallery : got image");
                                                                    NSData* data = UIImageJPEGRepresentation(image,1.0);
                                                                    if ( data ) {
                                                                        qDebug("_copyImageFromGallery : writing data to file");
                                                                        [data writeToFile: target.toNSString() atomically: YES];
                                                                    }
                                                               }];


    }
    qDebug("_copyImageFromGallery : done");
    return QFile::exists(target);
}
