//
//  ImagesScrollView.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/28.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "ImagesScrollView.h"

@interface ImagesScrollView ()<UIScrollViewDelegate>

@property (retain,nonatomic) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger currentPage; // 滚动的当前页面

@end

@implementation ImagesScrollView

#pragma mark 传入图片，将图片放入scrollView中
- (void)inputImages:(NSMutableArray *)images atIndex:(NSInteger)index andComplete:(void(^)(BOOL complete))complete {
    
    
    
    // 1. 移除scrollView中所有的子视图
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }

    self.scrollView.contentSize = CGSizeMake(images.count*GETWIDTH(self.scrollView), GETHEIGHT(self.scrollView));
    
    // 2. 添加子视图
    for (int i = 0; i < images.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];

        imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat imageX = i*GETWIDTH(self.scrollView);
        imageView.frame = CGRectMake(imageX, 0, GETWIDTH(self.scrollView), GETHEIGHT(self.scrollView));
        imageView.image = [images objectAtIndex:i];
        imageView.userInteractionEnabled = YES;
        
        //1、创建手势实例，并连接方法handleTapGesture,点击手势
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
        //设置手势点击数,双击：点2下
        tapGesture.numberOfTapsRequired=1;
        // imageView添加手势识别
        [imageView addGestureRecognizer:tapGesture];
        
        //        隐藏指示条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.scrollView addSubview:imageView];
    }
    
    [self.scrollView setContentOffset:CGPointMake(index*GETWIDTH(self.scrollView), 0) animated:NO];
    
    complete(YES);
}

#pragma mark 处理传过来的链接
- (void)inputImageUrlArray:(NSMutableArray *)imageUrlArray atIndex:(NSInteger)index andComplete:(void(^)(BOOL complete))complete {
    
    // 1. 移除scrollView中所有的子视图
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    self.scrollView.contentSize = CGSizeMake(imageUrlArray.count*GETWIDTH(self.scrollView), GETHEIGHT(self.scrollView));
    
    // 2. 添加子视图
    for (int i = 0; i < imageUrlArray.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat imageX = i*GETWIDTH(self.scrollView);
        imageView.frame = CGRectMake(imageX, 0, GETWIDTH(self.scrollView), GETHEIGHT(self.scrollView));
        
        [imageView sd_setImageWithURL:[imageUrlArray objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"placeholderIm"]];
        imageView.userInteractionEnabled = YES; // 图片可交互
        
        //1、创建手势实例，并连接方法handleTapGesture,点击手势
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
        //设置手势点击数,双击：点2下
        tapGesture.numberOfTapsRequired=1;
        // imageView添加手势识别
        [imageView addGestureRecognizer:tapGesture];
        
        //        隐藏指示条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.scrollView addSubview:imageView];
    }
    
    [self.scrollView setContentOffset:CGPointMake(index*GETWIDTH(self.scrollView), 0) animated:NO];
    
    complete(YES);
}

#pragma mark 返回滑动页数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = (x + scrollViewW / 2) / scrollViewW;
    self.currentPage = page;
    
    if (_delegate && [_delegate respondsToSelector:@selector(imagesScrollViewDidEndScrollAtPage:)]) {
        [_delegate imagesScrollViewDidEndScrollAtPage:page];
    }
}

#pragma mark 图片的点击手势
#pragma mark 点击手势触发事件
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(imagesScrollViewDidClickImageAtPage:)]) {
        [_delegate imagesScrollViewDidClickImageAtPage:self.currentPage];
    }
}

#pragma mark 懒加载scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}


@end
