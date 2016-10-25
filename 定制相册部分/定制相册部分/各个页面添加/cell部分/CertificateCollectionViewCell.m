//
//  CertificateCollectionViewCell.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/24.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CertificateCollectionViewCell.h"

@implementation CertificateCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
#pragma mark 初始化加载xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CertificateCollectionViewCell" owner:self options:nil];
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;
}

- (void)updateCellWithImageUrl:(NSString *)imageUrl andCellImageType:(CertificateCellImageType)cellImageType {
    
    // button图片赋值
    [self.certificateBackImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
    }];
    
    // 状态图片赋值
    switch (cellImageType) {
        case CertificateCellImageEmpty:
            self.certificateImageView.image = [UIImage imageNamed:@""];
            break;
            
        case CertificateCellImageDeselect:
            self.certificateImageView.image = [UIImage imageNamed:@"CertificateCell_deselect"];
            break;
            
        case CertificateCellImageSelect:
            self.certificateImageView.image = [UIImage imageNamed:@"CertificateCell_select"];
            break;
            
        case CertificateCellImageDelete:
            self.certificateImageView.image = [UIImage imageNamed:@"CertificateCell_delete"];
            break;
            
        default:
            break;
    }
}

#pragma mark 大背景图片的点击事件
- (IBAction)backImageViewTapClick:(UITapGestureRecognizer *)sender {
    
    /**
     基本逻辑，如果是长按手势状态，点击解除长按手势状态，如果不是长按手势状态，直接进入预览页面
     */
    
    if (self.isEverLongPress) {
        self.isEverLongPress = NO; // 普通点击手势
        // 启动取消编辑状态代理
        self.certificateImageView.image = [UIImage imageNamed:@""];
        
        
    } else {
        // 启用进入预览页面代理方法
        
        
    }
    
    
    
    
    
    
    
    
    
    
    NSLog(@"点击");
}

#pragma mark 大背景图片的长按手势
- (IBAction)backImageViewLongPressClick:(UILongPressGestureRecognizer *)sender {
    
    /**
     基本逻辑，如果不是长按手势状态，点击进入长按手势状态，如果是长按手势状态，则不做任何处理
     */
    
    if (!self.isEverLongPress) {
        // 启用进入编辑状态点击代理方法
        NSLog(@"长按");
        self.isEverLongPress = YES;
        self.certificateImageView.image = [UIImage imageNamed:@"CertificateCell_delete"];
        
    } else {
        // 不做任何处理
    }
    
    
    
    
    
    
}




@end
