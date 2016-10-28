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
        
        
        //    1. 采用本地图片实现
        //    1.1 创建图片数组
       
        
        NSMutableArray *images = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"h1.png"],
                                  [UIImage imageNamed:@"h2.png"],
                                  [UIImage imageNamed:@"h3.png"],
                                  [UIImage imageNamed:@"h4.png"]
                                  , nil];
        
        self.imagesScrollView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [self.bearView addSubview:self.imagesScrollView];

        
        [self.imagesScrollView inputImages:images andComplete:^(BOOL complete) {
            
        }];
        
        
        
        
    }
    return self;
}



#pragma mark 返回按钮点击事件
- (IBAction)backButtonClick:(UIButton *)sender {
    
    self.hidden = YES;
    
}

#pragma mark 删除按钮点击事件
- (IBAction)deleteButtonClick:(UIButton *)sender {
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
