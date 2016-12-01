//
//  ChooseLicenseAccessoryVC.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/24.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ChooseLicenseAccessoryVCFromTypeCustomer,
    ChooseLicenseAccessoryVCFromTypeOrderDetail,
    ChooseLicenseAccessoryVCFromTypeUpdateContract
} ChooseLicenseAccessoryVCFromType;

@interface ChooseLicenseAccessoryVC : UIViewController

@property (nonatomic,copy) NSString *customerId;
@property (nonatomic, assign)ChooseLicenseAccessoryVCFromType fromType;
@property (nonatomic,assign) BOOL isUploadClick; // 判断是否是点击上传证件按钮点击

@end
