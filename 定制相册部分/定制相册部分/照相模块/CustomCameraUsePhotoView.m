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
        
        //1、创建手势实例，并连接方法handleTapGesture,点击手势
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
        //设置手势点击数,双击：点2下
        tapGesture.numberOfTapsRequired=1;
        // imageView添加手势识别
        [self.imageView addGestureRecognizer:tapGesture];
        
    }
    return self;
}

#pragma mark 图片的点击手势
- (void)imageTapClick:(UITapGestureRecognizer *)sender {
    
    self.isFooterViewHidden = !self.isFooterViewHidden;
    if (self.isFooterViewHidden) {
        self.footerView.hidden = YES;
    } else {
        self.footerView.hidden = NO;
    }
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
