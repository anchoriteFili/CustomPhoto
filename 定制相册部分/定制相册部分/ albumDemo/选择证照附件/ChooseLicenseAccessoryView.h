//
//  ChooseLicenseAccessoryView.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/27.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollView.h"
#import "CertificateCellModel.h"

@interface ChooseLicenseAccessoryView : UIView<ImagesScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView; // 头部整条
@property (weak, nonatomic) IBOutlet UILabel *headerContentLabel; // 头部label显示
@property (weak, nonatomic) IBOutlet UIView *bearView; // 承载scrollView的view

@property (nonatomic,retain) ImagesScrollView *imagesScrollView; // 用于轮播的view
@property (nonatomic,strong) NSMutableArray *modelArray; // 接收数组
@property (nonatomic,strong) NSMutableArray *imageUrlArray; // 所有的链接url
@property (nonatomic,assign) NSInteger currentPage; // 当前页面与数组中位置一一对应，从0开始
@property (nonatomic,assign) BOOL isHeaderViewHidden; // 头部视图是否隐藏


- (void)updateScrollViewWithModelArray:(NSMutableArray *)modelArray atIndex:(NSInteger)index;

@end
