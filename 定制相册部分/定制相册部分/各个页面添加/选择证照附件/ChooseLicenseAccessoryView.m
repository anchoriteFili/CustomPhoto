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
    
    self.modelArray = modelArray;
    
    // 添加图片，更新scrollView
    NSMutableArray *images = [NSMutableArray array];
    
    for (CertificateCellModel *model in modelArray) {
        [images addObject:model.itemImage];
    }
    
    [self.imagesScrollView inputImages:images atIndex:index andComplete:^(BOOL complete) {
        
    }];
    
    self.currentPage = index;
    self.headerContentLabel.text = [NSString stringWithFormat:@"%ld/%lu",index+1,(unsigned long)modelArray.count];
}

#pragma mark 滚动图代理方法
- (void)imagesScrollViewDidEndScrollAtPage:(NSInteger)page {
    
    self.currentPage = page;
    
    self.headerContentLabel.text = [NSString stringWithFormat:@"%ld/%lu",page+1,(unsigned long)self.modelArray.count];
}

#pragma mark 返回按钮点击事件
- (IBAction)backButtonClick:(UIButton *)sender {
    
#pragma mark 对象通过通知中心广播消息，包括：信息名称、信息内容。
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadChooseLicenseAccessoryVCNotification object:self userInfo:nil];
    
    self.hidden = YES;
    
}

#pragma mark 删除按钮点击事件
- (IBAction)deleteButtonClick:(UIButton *)sender {
    
    
    [self.modelArray removeObjectAtIndex:self.currentPage];

    
    // 添加图片，更新scrollView
    NSMutableArray *images = [NSMutableArray array];
    
    for (CertificateCellModel *model in self.modelArray) {
        [images addObject:model.itemImage];
    }
    
    [self.imagesScrollView inputImages:images atIndex:self.currentPage-1 andComplete:^(BOOL complete) {
        
    }];
    
    self.currentPage = self.currentPage-1;
    self.headerContentLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentPage+1,(unsigned long)self.modelArray.count];
    
    if (self.currentPage+1 == 0) {
        self.hidden = YES;
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
