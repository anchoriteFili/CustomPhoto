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
+ (UIImage *)photoWithAssetCollection:(PHAssetCollection *)assetCollection atIndex:(NSInteger)index;





@end
