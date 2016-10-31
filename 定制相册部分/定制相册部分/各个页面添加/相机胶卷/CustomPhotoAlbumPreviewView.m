//
//  CustomPhotoAlbumPreviewView.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/31.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CustomPhotoAlbumPreviewView.h"

@implementation CustomPhotoAlbumPreviewView

#pragma mark 要想调用xib，需写下面部分
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] lastObject];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
