//
//  CustomCameraUsePhotoView.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/31.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertificateCellModel.h"

typedef void(^CustomCameraUsePhotoViewBlcok)(BOOL isUsePhoto);

@interface CustomCameraUsePhotoView : UIView

@property (nonatomic,copy) CustomCameraUsePhotoViewBlcok photoBlock;

@property (weak, nonatomic) IBOutlet UIImageView *imageView; // 用于显示图片

- (void)updateViewWithModel:(CertificateCellModel *)model andCompleteWithBlock:(CustomCameraUsePhotoViewBlcok)photoBlock;


@end
