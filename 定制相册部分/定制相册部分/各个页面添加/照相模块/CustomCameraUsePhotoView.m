//
//  CustomCameraUsePhotoView.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/31.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CustomCameraUsePhotoView.h"

@implementation CustomCameraUsePhotoView

#pragma mark 要想调用xib，需写下面部分
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] lastObject];

        
    }
    return self;
}

#pragma mark 填充页面
- (void)updateViewWithModel:(CertificateCellModel *)model andCompleteWithBlock:(CustomCameraUsePhotoViewBlcok)photoBlock {
    self.photoBlock = photoBlock;
    
    self.imageView.image = model.itemImage;
}

#pragma mark 重拍按钮点击事件
- (IBAction)rephotographButtonClick:(UIButton *)sender {
    /**
     基本逻辑：
     直接关闭页面，不做任何处理
     */
    self.photoBlock(NO);
    self.hidden = YES;
}

#pragma mark 使用图片按钮点击事件
- (IBAction)usePhotoButtonClick:(UIButton *)sender {
    /**
     基本逻辑：
     需要将图片传过去，要做些什么呢？
     */
    self.photoBlock(YES);
    self.hidden = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
