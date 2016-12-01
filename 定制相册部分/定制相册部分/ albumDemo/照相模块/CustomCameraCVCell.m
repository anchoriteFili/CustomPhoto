//
//  CustomCameraCVCell.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/27.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CustomCameraCVCell.h"

@implementation CustomCameraCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
#pragma mark 初始化加载xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CustomCameraCVCell" owner:self options:nil];
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;
}

#pragma mark 更新cell
- (void)updateCellWithModel:(CertificateCellModel *)model {
    
    self.model = model;
    self.contentImageView.image = model.itemImage;
}

#pragma mark 大图片的点击事件
- (IBAction)bigImageClick:(UITapGestureRecognizer *)sender {
    // 直接进入预览页面

    NSLog(@"点击了大图片");
    
    if (_delegate && [_delegate respondsToSelector:@selector(customCameraCVCellClickEventType:atIndex:)]) {
        [_delegate customCameraCVCellClickEventType:CustomCameraCVCellClickTypeBigImage atIndex:self.model.index];
    }
    
}

#pragma mark 小图片的点击事件
- (IBAction)smallImageClick:(UITapGestureRecognizer *)sender {
    
    // 删除相关图片
    if (_delegate && [_delegate respondsToSelector:@selector(customCameraCVCellClickEventType:atIndex:)]) {
        [_delegate customCameraCVCellClickEventType:CustomCameraCVCellClickTypeSmallImage atIndex:self.model.index];
    }
    
    NSLog(@"点击了小图片");
}


@end
