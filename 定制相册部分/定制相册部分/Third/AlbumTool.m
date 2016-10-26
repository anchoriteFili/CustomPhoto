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
    
    NSLog(@"cameraRoll ====== %@",cameraRoll);
    
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
    
    NSMutableArray *imagesArray = [NSMutableArray array];
    
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [imagesArray addObject:result];
        }];
    }
    
    return imagesArray;
}

#pragma mark 获取单张原图
/**
 基本逻辑：
 首先知道相册，然后再知道相册中的第几个，那么
 */
+ (UIImage *)photoWithAssetCollection:(PHAssetCollection *)assetCollection atIndex:(NSInteger)index {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    PHAsset *asset = [assets objectAtIndex:index];
    
    // 是否要原图
    CGSize size =  CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    __block UIImage *image = [[UIImage alloc] init];
    
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@", result);
        image = result;
    }];
    
    return image;
}

#pragma mark 获取某胶卷儿的照片数量
+ (NSUInteger)getAlbumCountWith:(PHAssetCollection *)assetCollection {
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    return assets.count;
}

@end
