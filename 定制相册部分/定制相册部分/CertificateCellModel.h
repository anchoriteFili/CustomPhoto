//
//  CertificateCellModel.h
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/25.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <Foundation/Foundation.h>

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



@end
