//
//  ChooseLicenseAccessoryView.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/27.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "ImagesScrollView.h"

@interface ChooseLicenseAccessoryView : UIView<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerContentLabel; // 头部label显示

@property (weak, nonatomic) IBOutlet UIView *bearView; // 承载scrollView的view

@property (nonatomic,retain) ImagesScrollView *imagesScrollView; // 用于轮播的view



@end
