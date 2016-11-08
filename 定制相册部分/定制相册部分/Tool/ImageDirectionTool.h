//
//  ImageDirectionTool.h
//  ShouKeBao
//
//  Created by 赵宏亚 on 16/11/3.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ImageDirectionTool : NSObject
/**
* 开启重力感应
*/
+ (void)startUpdateAccelerometerWithManager:(CMMotionManager *)manager Result:(void (^)(UIImageOrientation direction))result;

/**
 * 关闭重力感应
 */
+ (void)stopUpdateWithManager:(CMMotionManager *)manager;

/**
 * 处理图片方向
 */
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;


@end
