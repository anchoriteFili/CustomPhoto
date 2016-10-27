//
//  AlbumTool.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/26.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "AlbumTool.h"

@implementation AlbumTool

#pragma mark 获取胶卷的名字相关数据
+ (NSMutableArray *)getAlbumObjects {
    
    NSMutableArray *array = [NSMutableArray array];
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [array addObject:cameraRoll];
    
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        [array addObject:assetCollection];
    }
    
//    NSLog(@"cameraRoll ====== %@",cameraRoll);
    
    return array;
    
}

#pragma mark 获取所有的缩略图
+ (NSMutableArray *)getAlbumThumbnailWithAssetCollection:(PHAssetCollection *)assetCollection {
    return [self enumerateAssetsInAssetCollection:assetCollection original:NO];
}

#pragma mark 缩略图的获取
+ (NSMutableArray *)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original {
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    NSLog(@"endDate == %@",assetCollection.localIdentifier);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
//    NSLog(@"assets.count ========== %lu",(unsigned long)assets.count);
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        
        NSLog(@"asset.burstIdentifier ====== %@",asset.localIdentifier);
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            /**
             为了优化，直接将model在这里创建
             */
            
            CertificateCellModel *model = [[CertificateCellModel alloc] init];
            model.itemImage = result;
            model.localIdentifier = asset.localIdentifier;
            model.cellImageType = CertificateCellImageDeselect;
            [modelArray addObject:model];
        }];
    }
    
    modelArray = (NSMutableArray *)[[modelArray reverseObjectEnumerator] allObjects];
    
    return modelArray;
}

#pragma mark 获取单张原图
/**
 基本逻辑：
 首先知道相册，然后再知道相册中的第几个，那么
 */
+ (void)photoWithAssetCollection:(PHAssetCollection *)assetCollection atIndex:(NSInteger)index withBlcok:(void(^)(UIImage *image))image {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    PHAsset *asset = [assets objectAtIndex:index];
    
    // 是否要原图
    CGSize size =  CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@", result);
        image(result);
    }];
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
        
        localIdentifier(assetId);
        NSLog(@"成功保存图片到相机胶卷中");
    }];
    
}


/**
 *  返回相册
 */
+ (PHAssetCollection *)collection{
    // 先获得之前创建过的相册
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    
    return cameraRoll;
}



#pragma mark 比较两张图片是否相等
+ (BOOL)compareImageOne:(UIImage *)imageOne withImageTwo:(UIImage *)imageTwo {
    
    
    NSData *dataOne;
    if (UIImagePNGRepresentation(imageOne) == nil) {
        
        dataOne = UIImageJPEGRepresentation(imageOne, 1);
        
    } else {
        
        dataOne = UIImagePNGRepresentation(imageOne);
    }
    
    NSData *dataTwo;
    if (UIImagePNGRepresentation(imageTwo) == nil) {
        
        dataTwo = UIImageJPEGRepresentation(imageTwo, 1);
        
    } else {
        
        dataTwo = UIImagePNGRepresentation(imageTwo);
    }
    
    
    // 如果两个图片相同，则返回YES,不相同，返回NO
    if ([dataOne isEqual:dataTwo]) {
        
        NSLog(@"有匹配");
        return YES;
    } else {
        return NO;
    }
}

@end
