//
//  CustomPhotoAlbumPreviewView.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/31.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollView.h"
#import "CertificateCellModel.h"

@protocol CustomPhotoAlbumPreviewViewDelegate <NSObject>

#pragma mark 完成按钮点击事件
- (void)customPhotoAlbumPreviewCompleteButtonClickWithDeleteModel:(NSMutableArray *)deleteModelArray;

@end


@interface CustomPhotoAlbumPreviewView : UIView<ImagesScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView; // 头部交互栏
@property (weak, nonatomic) IBOutlet UIView *footerView; // 底部交互栏
@property (weak, nonatomic) IBOutlet UILabel *headerContentLabel; // 头部label显示
@property (weak, nonatomic) IBOutlet UIView *bearView; // 承载scrollView的view
@property (weak, nonatomic) IBOutlet UIButton *selectButton; // 是否选择的button
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel; // 选择的图片的数量label的显示

@property (nonatomic,strong) NSMutableArray *modelAddtionArray; // 接收数组
@property (nonatomic,assign) NSInteger currentPage; // 当前页面
@property (nonatomic,assign) NSInteger selectModelCount; // 选择的图片的数量
@property (nonatomic,assign) BOOL isInteractionViewHidden; // 上下交互栏是否隐藏
@property (nonatomic,assign) id<CustomPhotoAlbumPreviewViewDelegate,NSObject> delegate; // 创建代理


@property (nonatomic,retain) ImagesScrollView *imagesScrollView; // 用于轮播的view

- (void)updateScrollViewWithModelArray:(NSMutableArray *)modelArray atIndex:(NSInteger)index;

@end
