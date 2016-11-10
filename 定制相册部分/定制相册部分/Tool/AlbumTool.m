//
//  AlbumTool.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/26.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "AlbumTool.h"

@implementation AlbumTool

#pragma mark 访问是否获取了相册权限
+ (void)albumAuthorizationWithAuthorization:(void(^)(AlbumAuthorizationType authorization))authorization {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {

        authorization(AlbumAuthorizationTypeClose); // 关闭了权限
    } else if (status == PHAuthorizationStatusAuthorized) {
        
        authorization(AlbumAuthorizationTypeAllow); // 开了权限
    } else {
        
        // 如果是默认状态，就开始申请权限，并将申请到的权限返回
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusDenied) {
                authorization(AlbumAuthorizationTypeClose); // 关闭了权限
            } else if (status == PHAuthorizationStatusAuthorized) {
                authorization(AlbumAuthorizationTypeAllow); // 开了权限
            }
        }];
    }
}

#pragma mark 获取相机权限
+ (void)cameraAuthorizationWithAuthorization:(void(^)(CameraAuthorizationType authorization))authorization {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        
        authorization(CameraAuthorizationTypeAllow); // 权限已开启
    } else if (authStatus == AVAuthorizationStatusDenied) {
        
        authorization(CameraAuthorizationTypeClose); // 权限已关闭
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted) {
                authorization(CameraAuthorizationTypeAllow); // 权限已开启
            } else {
                authorization(CameraAuthorizationTypeClose); // 权限已关闭
            }
        }];
    }
}

#pragma mark 获取胶卷的名字相关数据
+ (NSMutableArray *)getAlbumObjects {
    
    NSMutableArray *array = [NSMutableArray array];
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    
    if (!cameraRoll) {
        return array;
    }
    
    [array addObject:cameraRoll];
    
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        if (assets.count) { // 如果相册里有图片，则添加到数组中
            [array addObject:assetCollection];
        }
    }
    
    return array;
    
}

#pragma mark 获取所有的缩略图
+ (void)getAlbumThumbnailWithAssetCollection:(PHAssetCollection *)assetCollection withPage:(NSInteger)page andComplete:(void(^)(NSMutableArray *modelArray,NSInteger totalPhotos, NSInteger totalPage, NSInteger currentPage))modelArrayBlock {
    [self enumerateAssetsInAssetCollection:assetCollection original:NO withPage:page andComplete:^(NSMutableArray *modelArray,NSInteger totalPhotos, NSInteger totalPage, NSInteger currentPage) {
        modelArrayBlock(modelArray,totalPhotos,totalPage,page);
    }];
}

#pragma mark 缩略图的获取
+ (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original withPage:(NSInteger)page andComplete:(void(^)(NSMutableArray *modelArray,NSInteger totalPhotos, NSInteger totalPage, NSInteger currentPage))modelArrayBlock {
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
//    NSLog(@"assets.count ========== %lu",(unsigned long)assets.count);
    
    /**
     如果我在这里添加一个GCD呢，会怎样呢？先试试
     */
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *modelArray = [NSMutableArray array];
        NSUInteger totalPage = assets.count/PageNumber;
        
        if (assets.count % PageNumber) {
            totalPage ++;
        }
        
        for (NSInteger i = page*PageNumber; i < page*PageNumber + PageNumber; i ++) {
            
            if (i >= assets.count) {
                break;
            } else {
                
                PHAsset *asset = [assets objectAtIndex:assets.count-i-1];
                // 是否要原图
                CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeMake(125, 125);
                
                // 从asset中获得图片
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    
                    /**
                     为了优化，直接将model在这里创建
                     */
                    
                    CertificateCellModel *model = [[CertificateCellModel alloc] init];
                    model.itemImage = result;
                    model.page = page;
                    model.assetCollection = assetCollection;
                    model.localIdentifier = asset.localIdentifier;
                    model.cellImageType = CertificateCellImageDeselect;
                    [modelArray addObject:model];
                }];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            modelArrayBlock(modelArray, assets.count, totalPage, page);
            //回到主线程
        });
        
    });
}

#pragma mark 获取单张原图
/**
 基本逻辑：
 首先知道相册，然后再知道相册中的第几个，那么直接匹配localIdentifier即可
 */
+ (void)photoWithAssetCollection:(PHAssetCollection *)assetCollection withLocalIdentifier:(NSString *)localIdentifier andPage:(NSInteger)page withBlcok:(void(^)(UIImage *bigImage))bigImage {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    
    for (NSInteger i = page*PageNumber; i < page*PageNumber + PageNumber; i ++) {
        
        if (i >= assets.count) {
            break;
        } else {
            
            PHAsset *asset = [assets objectAtIndex:assets.count-i-1];
            // 是否要原图
            if ([asset.localIdentifier isEqualToString:localIdentifier]) {
                
                // 是否要原图
                CGSize size = CGSizeMake(480.0, 640.0);
                
                if (asset.pixelWidth > 480 || asset.pixelHeight > 640) {
                    size = CGSizeMake(480.0, 640.0);
                } else {
                    size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
                }
                
                // 从asset中获得图片
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    
                    bigImage(result);
                }];
                break;
            }
        }
    }
}

#pragma mark 获取某胶卷儿的照片数量
+ (NSUInteger)getAlbumCountWith:(PHAssetCollection *)assetCollection {
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return assets.count;
}

#pragma mark 获取封面图片方法
+ (void)getCoverImageWith:(PHAssetCollection *)assetCollection withBlcok:(void(^)(UIImage *image))image {
    
    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    [[PHImageManager defaultManager] requestImageForAsset:assetResult.firstObject targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:[PHImageRequestOptions new] resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image(result);
    }];

}

#pragma mark 保存图片
+ (void)saveImage:(UIImage *)image withLocalIdentifier:(void(^)(NSString *localIdentifier))localIdentifier {
    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    __block NSString *assetId = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{ // 这个block里保存一些"修改"性质的代码
        // 新建一个PHAssetCreationRequest对象, 保存图片到"相机胶卷"
        // 返回PHAsset(图片)的字符串标识
        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"保存图片到相机胶卷中失败");
            return;
        }
        
        localIdentifier(assetId); // 将图片保存到相册中，并获取其唯一标识assetId及localIdentifier，用于后期的筛选
        NSLog(@"成功保存图片到相机胶卷中");
    }];
    
}


@end
