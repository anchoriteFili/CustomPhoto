//
//  ImageDirectionTool.m
//  ShouKeBao
//
//  Created by 赵宏亚 on 16/11/3.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ImageDirectionTool.h"

@implementation ImageDirectionTool

#pragma mark **************** 重力感应部分 begin ****************
+ (void)startUpdateAccelerometerWithManager:(CMMotionManager *)manager Result:(void (^)(UIImageOrientation direction))result {
    if ([manager isAccelerometerAvailable] == YES) {
        //回调会一直调用,建议获取到就调用下面的停止方法，需要再重新开始，当然如果需求是实时不间断的话可以等离开页面之后再stop
        
        NSTimeInterval updateInterval = 1/15.0;
        
        [manager setAccelerometerUpdateInterval:updateInterval];
        [manager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             double x = accelerometerData.acceleration.x;
             double y = accelerometerData.acceleration.y;
             if (fabs(y) >= fabs(x))
             {
                 if (y >= 0){
                     //Down
                     NSLog(@"倒立");
                     result(UIImageOrientationDown);
                 }
                 else{
                     //Portrait
                     NSLog(@"正常");
                     result(UIImageOrientationUp);
                 }
             }
             else
             {
                 if (x >= 0){
                     //Right
                     NSLog(@"右边");
                     result(UIImageOrientationRight);
                 }
                 else{
                     //Left
                     
                     NSLog(@"左边");
                     result(UIImageOrientationLeft);
                 }
             }
             
             [self stopUpdateWithManager:manager]; // 调用一次直接关闭
         }];
    }
}

#pragma mark 关闭更新
+ (void)stopUpdateWithManager:(CMMotionManager *)manager {
    if ([manager isAccelerometerActive] == YES) {
        NSLog(@"停止");
        [manager stopAccelerometerUpdates];
        manager = nil;
    }
}

#pragma mark **************** 重力感应部分 end ****************

#pragma mark 图片处理部分
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation {
    
    switch (orientation) {
        case UIImageOrientationLeft: {
            UIImage *newImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
            return newImage;
            break;
        }

        case UIImageOrientationRight:{
            // 调整好
            UIImage *newImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationDown];
            
            return newImage;
            break;
        }
        case UIImageOrientationDown:{
            // 这个是对的
            UIImage *newImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeft];
            return newImage;
            break;
        }
        default:
            return image;
            break;
    }
    
    return image;
}

@end
