//
//  ChooseLicenseAccessoryView.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/27.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "ChooseLicenseAccessoryView.h"

@implementation ChooseLicenseAccessoryView

#pragma mark 要想调用xib，需写下面部分
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] lastObject];
        
        self.imagesScrollView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [self.bearView addSubview:self.imagesScrollView];
        self.imagesScrollView.delegate = self;

    }
    return self;
}

#pragma mark 更新图片部分
- (void)updateScrollViewWithModelArray:(NSMutableArray *)modelArray atIndex:(NSInteger)index {
    
    [UIApplication sharedApplication].statusBarHidden = YES; // 关闭状态来
    
    self.modelArray = modelArray;
    
    // 添加图片，更新scrollView
    NSMutableArray *imageUrlArray = [NSMutableArray array];
    
    for (CertificateCellModel *model in modelArray) {
        
        if (!model.imageUrl.length) {
            NSLog(@"有空链接");
        } else {
            [imageUrlArray addObject:model.imageUrl];
        }
    }
    
    NSLog(@"images.count ======= %lu",(unsigned long)imageUrlArray.count);
    
    [self.imagesScrollView inputImageUrlArray:imageUrlArray atIndex:index andComplete:^(BOOL complete) {
        
    }];
    
    self.currentPage = index;
    self.headerContentLabel.text = [NSString stringWithFormat:@"%ld/%lu",index+1,(unsigned long)modelArray.count];
}

#pragma mark 滚动图代理方法___滚动
- (void)imagesScrollViewDidEndScrollAtPage:(NSInteger)page {
    
    self.currentPage = page;    
    self.headerContentLabel.text = [NSString stringWithFormat:@"%ld/%lu",page+1,(unsigned long)self.modelArray.count];
}

#pragma mark 滚动图代理方法___点击
- (void)imagesScrollViewDidClickImageAtPage:(NSInteger)page {
    
    /**
     交互点击，隐藏或显示上交互栏
     */
    
    self.isHeaderViewHidden = !self.isHeaderViewHidden;
    
    if (self.isHeaderViewHidden) {
        self.headerView.hidden = YES;
    } else {
        self.headerView.hidden = NO;
    }
}

#pragma mark 返回按钮点击事件
- (IBAction)backButtonClick:(UIButton *)sender {
    
#pragma mark 对象通过通知中心广播消息，包括：信息名称、信息内容。
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadChooseLicenseAccessoryVCNotification object:self userInfo:@{@"isRefreshOnly":@"YES"}];
    
    [UIApplication sharedApplication].statusBarHidden = NO; // 打开状态栏
    self.hidden = YES;
    
}

#pragma mark 删除按钮点击事件
- (IBAction)deleteButtonClick:(UIButton *)sender {
    
    /**
     基本逻辑：
     1. 首先将所有的demo和demo中的链接从相关数组中移除
     2. 然后进行判断，判断是否是最后一个，如果是最后一个不再刷新页面
        直接退出页面并刷新选择证照附件页面
     3. 那么要做些什么？
        1> 要重写通知方法了，要分开两部分，一部分是只刷新数据的，另一个是先添加再刷新
        2> 此页面的有两步操作会刷新选择证照附件页面
           一： 在此页面中将数组中的数据都清零的一瞬间退出页面并刷新
           二： 主动点击返回按钮实行单纯的数据刷新
     */
    
    // 先移除链接和demo
    CertificateCellModel *model = [self.modelArray objectAtIndex:self.currentPage];
    [self.imageUrlArray removeObject:model.imageUrl]; // 移除相关链接
    [self.modelArray removeObject:model]; // 移除相关Model
    
    // 在此处判断是否所有的数据清零了，如果清零直接退出并刷新选择证照页面，
    
    if (self.modelArray.count == 0) {
        [self backButtonClick:nil]; // 直接启动返回返回按钮
        return; // 并且直接跳出方法
    } else {
        
        // 添加图片，更新scrollView
        NSMutableArray *imageUrlArray = [NSMutableArray array];
        
        for (CertificateCellModel *model in self.modelArray) {
            
            if (!model.imageUrl.length) {
                NSLog(@"有空链接");
            } else {
                [imageUrlArray addObject:model.imageUrl];
            }
        }
        
        /**
         在此处也有个判断逻辑：
         1. 如果正常情况删除，则直接删除即可，page不变
         2. 如果currentPage显示的位子为最后一张图片，则currentPage-1，后退一张图片
         */
        
        if (self.currentPage == self.modelArray.count) {
            self.currentPage --;
        }
        
        [self.imagesScrollView inputImageUrlArray:imageUrlArray atIndex:self.currentPage andComplete:^(BOOL complete) {
            
        }];
        
        self.headerContentLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentPage+1,(unsigned long)self.modelArray.count];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
