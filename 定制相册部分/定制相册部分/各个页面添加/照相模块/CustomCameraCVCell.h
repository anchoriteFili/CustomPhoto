//
//  CustomCameraCVCell.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/27.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>

static  NSString * identifierCustomCameraCVCell = @"customCameraCVCell";

@interface CustomCameraCVCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView; // 内部图片


@end
