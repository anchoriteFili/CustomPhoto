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
    
    self.certificateCellButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
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
    [self.certificateCellButton.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.certificateCellButton setImage:image forState:UIControlStateNormal];
        
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

@end
