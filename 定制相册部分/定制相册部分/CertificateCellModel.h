//
//  CertificateCellModel.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/25.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TouchEventType) {
    
    /**
     创建点击时触发的各个事件的判断
     大图
     1. 长按手势，长按大图进入编辑状态
     2. 点击手势，点击撤销编辑状态
     3. 点击手势，点击进入浏览状态
     
     小图
     1. 进入选择状态
     2. 解除选择状态
     3. 编辑删除相关item事件
     总共有六种触发事件
     */
    TouchEventTypeEdit, // 进入编辑状态
    TouchEventTypeCancalEdit, // 取消编辑状态
    TouchEventTypeBrowse, // 进入浏览页
    TouchEventTypeSelect, // 进入选择状态
    TouchEventTypeDeselect, // 解除选择状态
    TouchEventTypeDelete // 编辑删除item事件
};


// cell右上角小图片显示类型
typedef NS_ENUM(NSInteger, CertificateCellImageType) {
    CertificateCellImageEmpty, // 没有任何图片
    CertificateCellImageDeselect, // 显示正常的空圈儿未选择图片
    CertificateCellImageSelect, // 显示对号小图片
    CertificateCellImageDelete // 显示删除红杠小图片
};

// cell右上角小图片显示类型
typedef NS_ENUM(NSInteger, CertificateCellType) {
    CertificateCellNomal, // 正常图片展示形式
    CertificateCellAlbum, // 相册形式
};

@interface CertificateCellModel : NSObject

@property (nonatomic,assign) BOOL isAlbum; // 判断是否是相册形式

@property (nonatomic,strong) NSString *imageUrl; // cell中的大背景图片链接

@property (nonatomic,assign) CertificateCellImageType cellImageType; // 本cell右上角显示类型

@property (nonatomic,assign) NSInteger index; // 判断是collectionView的第几个item


@end
