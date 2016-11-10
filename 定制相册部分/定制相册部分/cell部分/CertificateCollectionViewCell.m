//
//  CertificateCollectionViewCell.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/24.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CertificateCollectionViewCell.h"

@implementation CertificateCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
#pragma mark 初始化加载xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CertificateCollectionViewCell" owner:self options:nil];
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;
}

#pragma mark 更新cell中所有的数据
- (void)updateCellWithModel:(CertificateCellModel *)model {
    
    self.model = model;
    
    if (model.cellImageType == CertificateCellImagePhoto) {
        
        self.certificateBackImageView.image = [UIImage imageNamed:@"CertificateCell_photo"];
    } else if (!model.itemImage) {
        // 大背景图片的赋值
        [self.certificateBackImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            model.itemImage = image;
        }];
    } else {
        self.certificateBackImageView.image = model.itemImage;
    }
    
    // 状态图片赋值
    switch (model.cellImageType) {
        case CertificateCellImageEmpty: // 没有图片状态
            self.certificateImageView.image = [UIImage imageNamed:@""];
            break;
            
        case CertificateCellImageDelete: // 编辑时的删除图片状态
            self.certificateImageView.image = [UIImage imageNamed:@"CustomCameraCVCell_delete"];
            break;
            
        case CertificateCellImageDeselect: // 空圆圈没有选择状态
            self.certificateImageView.image = [UIImage imageNamed:@"CustomPhotoAlbumPreviewView_NoChoose"];
            break;
            
        case CertificateCellImageSelect: // 打对号的选择状态
            self.certificateImageView.image = [UIImage imageNamed:@"CustomPhotoAlbumPreviewView_choose"];
            break;
            
        default:
            self.certificateImageView.image = [UIImage imageNamed:@""];
            break;
    }
}


#pragma mark 大背景图片的点击事件
- (IBAction)backImageViewTapClick:(UITapGestureRecognizer *)sender {
    
    /**
     点击事件基本逻辑：
     1. 在编辑状态的时候点击解除编辑状态
     2. 在正常状态的时候进入浏览页面
    只有这两个
     */
    
    switch (self.model.cellImageType) {
        case CertificateCellImageEmpty: {
            // 点击进入浏览页面
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypeBrowse atIndex:self.model.index];
            }
            break;
        }
            
        case CertificateCellImageDelete: {
            // 显示编辑状态，点击进入非编辑状态
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypeCancalEdit atIndex:self.model.index];
            }
            break;
        }
            
        case CertificateCellImagePhoto: {
            // 如果点击大图片为第一个item，点击直接进入拍照
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypePhoto atIndex:self.model.index];
            }
            break;
        }
            
        case CertificateCellImageSelect: {
            // 如果是选中状态，点击进入非选中状态
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypeDeselect atIndex:self.model.index];
            }
            break;
        }
            
        case CertificateCellImageDeselect: {
            // 如果是空圈儿非选中状态，点击进入选中状态
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypeSelect atIndex:self.model.index];
            }
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark 大背景图片的长按手势
- (IBAction)backImageViewLongPressClick:(UILongPressGestureRecognizer *)sender {
    /**
     长按手势：
     只有在为空的时候可以进入编辑状态，其他一切都不做处理
     */
    
    switch (self.model.cellImageType) {
        case CertificateCellImageEmpty: {
            // 点击长按进入编辑状态
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypeEdit atIndex:self.model.index];
            }
            break;
        }
            
        default:
            break;
    }

}

#pragma mark 右上角小图片的点击事件
- (IBAction)certificateImageViewTapClick:(UITapGestureRecognizer *)sender {
    
    /**
     右上角点击事件总共有三个
     1. 编辑时删除事件
     2. 选中状态
     3. 非选中状态
     */
    
    switch (self.model.cellImageType) {
        case CertificateCellImageDelete: {
            // 如果删除按钮状态的时候，直接进行删除
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypeDelete atIndex:self.model.index];
            }
            break;
        }
            
        case CertificateCellImageSelect: {
            // 如果是选中状态，点击进入非选中状态
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypeDeselect atIndex:self.model.index];
            }
            break;
        }
            
        case CertificateCellImageDeselect: {
            // 如果是空圈儿非选中状态，点击进入选中状态
            
            if (_delegate && [_delegate respondsToSelector:@selector(certificateCollectionViewCellDelegateEventType:atIndex:)]) {
                
                // 进入编辑状态
                [_delegate certificateCollectionViewCellDelegateEventType:TouchEventTypeSelect atIndex:self.model.index];
            }
            break;
        }
            
        default:
            break;
    }
}

@end
