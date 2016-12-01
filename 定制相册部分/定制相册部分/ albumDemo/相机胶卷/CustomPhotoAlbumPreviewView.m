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
        
        self.imagesScrollView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [self.bearView addSubview:self.imagesScrollView];
        self.imagesScrollView.delegate = self;
        
    }
    return self;
}

#pragma mark 更新图片部分
- (void)updateScrollViewWithModelArray:(NSMutableArray *)modelArray atIndex:(NSInteger)index {
    
    [UIApplication sharedApplication].statusBarHidden = YES; // 关闭状态栏
    
    self.modelAddtionArray = modelArray;
    self.selectModelCount = modelArray.count;
    [self updateSelectImageCountLabel];
    
    
    [self.selectButton setImage:[UIImage imageNamed:@"CustomPhotoAlbumPreviewView_choose"] forState:UIControlStateNormal];
    
    // 添加图片，更新scrollView
    NSMutableArray *images = [NSMutableArray array];
    
    for (CertificateCellModel *model in modelArray) {
        [images addObject:model.bigImage];
    }
    
    [self.imagesScrollView inputImages:images atIndex:index andComplete:^(BOOL complete) {
        
    }];
    
    self.currentPage = index;
    self.headerContentLabel.text = [NSString stringWithFormat:@"%ld/%lu",index+1,(unsigned long)modelArray.count];
}

#pragma mark 滚动图代理方法
- (void)imagesScrollViewDidEndScrollAtPage:(NSInteger)page {
    
    self.currentPage = page;
    
    self.headerContentLabel.text = [NSString stringWithFormat:@"%ld/%lu",page+1,(unsigned long)self.modelAddtionArray.count];
    
    CertificateCellModel *model = [self.modelAddtionArray objectAtIndex:self.currentPage];
    
    if (model.cellImageType == CertificateCellImageDeselect) {
        [self.selectButton setImage:[UIImage imageNamed:@"CustomPhotoAlbumPreviewView_NoChoose"] forState:UIControlStateNormal];
    } else if (model.cellImageType == CertificateCellImageSelect) {
        [self.selectButton setImage:[UIImage imageNamed:@"CustomPhotoAlbumPreviewView_choose"] forState:UIControlStateNormal];
    }
}

#pragma mark 滚动图代理方法___点击
- (void)imagesScrollViewDidClickImageAtPage:(NSInteger)page {
    
    /**
     交互点击，隐藏或显示上交互栏
     */
    
    self.isInteractionViewHidden = !self.isInteractionViewHidden;
    
    if (self.isInteractionViewHidden) {
        self.headerView.hidden = YES;
        self.footerView.hidden = YES;
    } else {
        self.headerView.hidden = NO;
        self.footerView.hidden = NO;
    }
}

#pragma mark 返回按钮点击事件
- (IBAction)backButtonClick:(UIButton *)sender {
    /**
     基本逻辑：
     返回时，将所有数据类型换成对号状态，退出即可
     */
    for (CertificateCellModel *model in self.modelAddtionArray) {
        model.cellImageType = CertificateCellImageSelect;
    }
    [UIApplication sharedApplication].statusBarHidden = NO; // 打开状态栏
    
    self.hidden = YES;
}

#pragma mark 选择按钮的点击方法
- (IBAction)chooseButtonClick:(UIButton *)sender {

    /**
     基本逻辑：
     1. 根据currentPage来去除数组中的此位置的选择状态，如果选择则别为为选择，如果未选择，则变为选择
     2. 改变此按钮的背景图片，如果变为未选择则直接清空，若果变为选择则打对号
     */
    
    CertificateCellModel *model = [self.modelAddtionArray objectAtIndex:self.currentPage];
    
    if (model.cellImageType == CertificateCellImageDeselect) {
        model.cellImageType = CertificateCellImageSelect;
        [sender setImage:[UIImage imageNamed:@"CustomPhotoAlbumPreviewView_choose"] forState:UIControlStateNormal];
        
        self.selectModelCount ++;
        [self updateSelectImageCountLabel];
        
        
    } else if (model.cellImageType == CertificateCellImageSelect) {
        model.cellImageType = CertificateCellImageDeselect;
        [sender setImage:[UIImage imageNamed:@"CustomPhotoAlbumPreviewView_NoChoose"] forState:UIControlStateNormal];
        self.selectModelCount --;
        [self updateSelectImageCountLabel];
    }
}

#pragma mark 完成按钮点击事件
- (IBAction)completeButtonClick:(UIButton *)sender {
    /**
     基本逻辑：
     1. 点击确定将数组中所有空圈儿的model去掉
     2. 刷新复本页面
     */
    
    NSMutableArray *deleteModelArray = [NSMutableArray array];
    
    for (CertificateCellModel *model in self.modelAddtionArray) {
        if (model.cellImageType == CertificateCellImageDeselect) {
            [deleteModelArray addObject:model];
        }
    }
    
    [self.modelAddtionArray removeObjectsInArray:deleteModelArray];
    
    if (_delegate && [_delegate respondsToSelector:@selector(customPhotoAlbumPreviewCompleteButtonClickWithDeleteModel:)]) {
        [_delegate customPhotoAlbumPreviewCompleteButtonClickWithDeleteModel:deleteModelArray];
    }
    [UIApplication sharedApplication].statusBarHidden = NO; // 打开状态栏
    self.hidden = YES;
}

#pragma mark 更新右下角label的显示数量
- (void)updateSelectImageCountLabel {
    self.totalCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.selectModelCount];;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
