//
//  AlbumTool.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/26.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface AlbumTool : NSObject

#pragma mark 获取所有的胶卷的名字
+ (NSMutableArray *)getAlbumObjects;

#pragma mark 根据胶卷儿获取缩略图
+ (NSMutableArray *)getAlbumThumbnailWithAssetCollection:(PHAssetCollection *)assetCollection;

#pragma mark 获取指定某张图片的原图
+ (void)photoWithAssetCollection:(PHAssetCollection *)assetCollection atIndex:(NSInteger)index withBlcok:(void(^)(UIImage *image))image;

#pragma mark 获取指定胶卷儿的照片的数量
+ (NSUInteger)getAlbumCountWith:(PHAssetCollection *)assetCollection;

#pragma mark 获取封面图片方法
+ (void)getCoverImageWith:(PHAssetCollection *)assetCollection withBlcok:(void(^)(UIImage *image))image;


@end
