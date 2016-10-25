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

@end
