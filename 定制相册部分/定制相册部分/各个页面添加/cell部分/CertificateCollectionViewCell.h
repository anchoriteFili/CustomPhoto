//
//  CertificateCollectionViewCell.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/24.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>

// cell右上角小图片显示类型
typedef NS_ENUM(NSInteger, CertificateCellImageType) {
    CertificateCellImageDeselect, // 显示正常的空圈儿未选择图片
    CertificateCellImageSelect, // 显示对号小图片
    CertificateCellImageDelete // 显示删除红杠小图片
};

static  NSString * identifierCell = @"certificateCollectionViewCell";

@interface CertificateCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) CertificateCellImageType cellImageType; // 本cell显示类型

@end
