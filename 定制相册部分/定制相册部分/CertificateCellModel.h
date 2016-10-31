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
    TouchEventTypeDelete, // 编辑删除item事件
    TouchEventTypePhoto // 点击进行拍照
};


// cell右上角小图片显示类型和照相图片判断
typedef NS_ENUM(NSInteger, CertificateCellImageType) {
    CertificateCellImageEmpty, // 没有任何图片
    CertificateCellImageDeselect, // 显示正常的空圈儿未选择图片
    CertificateCellImageSelect, // 显示对号小图片
    CertificateCellImageDelete, // 显示删除红杠小图片
    CertificateCellImagePhoto, // 此时为第一个item，为一个相机图片，点击进入相机
};

// cell右上角小图片显示类型
typedef NS_ENUM(NSInteger, CertificateCellType) {
    CertificateCellNomal, // 正常图片展示形式
    CertificateCellAlbum, // 相册形式
};

// 照相机个点击事件的相关枚举
typedef NS_ENUM(NSInteger, CustomCameraVCButtonClickType) {
    CustomCameraVCButtonClickTypeCancleClick, // 点击取消按钮
    CustomCameraVCButtonClickTypeCompleteClick, // 点击完成按钮
    CustomCameraVCButtonClickTypeAlbumClick // 点击去相册按钮
};

@interface CertificateCellModel : NSObject

@property (nonatomic,assign) BOOL isAlbum; // 判断是否是相册形式

@property (nonatomic,strong) NSString *imageUrl; // cell中的大背景图片链接

@property (nonatomic,assign) CertificateCellImageType cellImageType; // 本cell右上角显示类型

@property (nonatomic,assign) NSInteger index; // 显示model在数据中的位置

@property (nonatomic,retain) UIImage *itemImage; // 相册中的图片数据

@property (nonatomic,assign) BOOL isNewImage; // 是否是相机添加或者是相册添加的新图片

@property (nonatomic,strong) NSString *localIdentifier; // 照片在相册中的标识


@end
