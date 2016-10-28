//
//  ImagesScrollView.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/28.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

/**
 view解释：
 此view基础简单，只向里边传入图片数组即可在scrollView中显示能滑动的图片。
 需要做的东西：
 1. 一个imageView占整个scrollView页面，那么，既然是可重用，好处理，就纯代码
 2. 图片保存原比例，不能有变形，要显示全图，这个要做处理。
 3. 需要滑动监控代理，和图片点击代理两个代理，只需要简单的这两个，那么，开始吧
 */

#import <UIKit/UIKit.h>

@protocol ImagesScrollViewDelegate <NSObject>

#pragma mark 传出各种点击类型
- (void)certificateCollectionViewCellDelegateEventType:(TouchEventType)touchEventType atIndex:(NSInteger)index;

// 停止滚动代理
- (void)imagesScrollViewDidEndScrollAtPage:(NSInteger)page;

@end

@interface ImagesScrollView : UIView

#pragma mark 基础的东西

/**
 * 自身代理
 */
@property (nonatomic,assign) id<ImagesScrollViewDelegate,NSObject> delegate;



/**
 * 传入的图片数组
 */
- (void)inputImages:(NSMutableArray *)images atIndex:(NSInteger)index andComplete:(void(^)(BOOL complete))complete;


@end
