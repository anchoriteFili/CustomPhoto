//
//  CertificateTableViewCell.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/26.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>

static  NSString * identifierTableViewCell = @"certificateTableViewCell";

@interface CertificateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView; // 显示的头图
@property (weak, nonatomic) IBOutlet UILabel *contentLabel; // 存放内容

@end
