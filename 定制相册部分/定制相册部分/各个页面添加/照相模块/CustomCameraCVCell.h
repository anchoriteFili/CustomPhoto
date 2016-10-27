//
//  CustomCameraCVCell.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/27.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomCameraCVCellClickType) {
    CustomCameraCVCellClickTypeBigImage, // 点击大图片进入预览页面
    CustomCameraCVCellClickTypeSmallImage // 点击小图片，删除相关数据
};

// cell右上角小图片显示类型
#pragma mark 添加代理方法
@protocol CustomCameraCVCellDelegate <NSObject>

#pragma mark 传出各种点击类型
- (void)customCameraCVCellClickEventType:(CustomCameraCVCellClickType)touchEventType atIndex:(NSInteger)index;

@end


static  NSString * identifierCustomCameraCVCell = @"customCameraCVCell";

@interface CustomCameraCVCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView; // 内部图片

@property (nonatomic,assign) id<CustomCameraCVCellDelegate,NSObject> delegate; // 创建代理



@end
