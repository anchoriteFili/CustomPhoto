//
//  ChooseLicenseAccessoryView.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/27.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLicenseAccessoryView : UIView

@property (weak, nonatomic) IBOutlet UILabel *headerContentLabel; // 头部label显示
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; // 用于浏览图片

@end
