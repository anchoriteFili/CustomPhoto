//
//  CertificateCollectionViewCell.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/24.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertificateCellModel.h"

#pragma mark 添加两个代理方法
@protocol CertificateCollectionViewCellDelegate <NSObject>

#pragma mark 传出各种点击类型
- (void)certificateCollectionViewCellDelegateEventType:(TouchEventType)touchEventType;

@end

static  NSString * identifierCell = @"certificateCollectionViewCell";

@interface CertificateCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) CertificateCellImageType cellImageType; // 本cell显示类型

@property (weak, nonatomic) IBOutlet UIImageView *certificateBackImageView; // 背景大图片

@property (weak, nonatomic) IBOutlet UIImageView *certificateImageView; // 右上角小图片

@property (nonatomic,assign) BOOL isEverLongPress; // 判断上次是否是长手势点击，限制长手势事件多次触发
@property (nonatomic,assign) BOOL isAlbum; // 判断是否是相册形式

@property (nonatomic,assign) id<CertificateCollectionViewCellDelegate,NSObject> delegate; // 各种代理方法

@property (nonatomic,retain) CertificateCellModel *model;

- (void)updateCellWithModel:(CertificateCellModel *)model;


@end
