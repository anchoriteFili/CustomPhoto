//
//  CustomCameraVC.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/26.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertificateCellModel.h"

// 闪光灯的状态
typedef NS_ENUM(NSInteger, CameraFlashlightState) {
    CameraFlashlightStateAuto, // 闪光灯自动
    CameraFlashlightStateON, // 闪光灯开
    CameraFlashlightStateOFF // 闪光灯关
};

// cell右上角小图片显示类型
#pragma mark 添加代理方法
@protocol CustomCameraVCDelegate <NSObject>

/**
 1. 点击取消按钮清空数组刷新页面
 2. 点击完成启动收回页面命令
 3. 点击去相册刷新相册数据
 */

- (void)customCameraCVButtonClickEventType:(CustomCameraVCButtonClickType)touchEventType;

@end

@interface CustomCameraVC : UIViewController

@property (nonatomic,retain) NSMutableArray *modelArray; // model数据数组
@property (nonatomic,strong) NSMutableArray *modelAdditionArray; // 用于存储从相册或相机中添加的图片

@property (nonatomic,assign) id<CustomCameraVCDelegate,NSObject> delegate; // 创建代理


@end
