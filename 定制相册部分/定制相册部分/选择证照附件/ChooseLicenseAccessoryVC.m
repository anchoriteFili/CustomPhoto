//
//  ChooseLicenseAccessoryVC.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/24.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "ChooseLicenseAccessoryVC.h"
#import "CertificateCollectionViewCell.h" // 自定义cell
#import "CustomPhotoAlbum.h" // 自定义相册
#import "ChooseLicenseAccessoryView.h" // 预览页面
#import "AppDelegate.h"

@interface ChooseLicenseAccessoryVC ()<UICollectionViewDataSource,UICollectionViewDelegate,CertificateCollectionViewCellDelegate>

@property (nonatomic,retain) UICollectionView *collectionView; // 创建collectionView
@property (nonatomic,strong) UIView *bottomSaveView; // 承载底部保存按钮的view

@property (nonatomic,retain) NSMutableArray *modelArray; // model数据数组
@property (nonatomic,strong) NSMutableArray *imageUrlArray; // 所有的链接url

@property (nonatomic,assign) BOOL isEditState; // 是否进入编辑状态

@property (nonatomic,retain) ChooseLicenseAccessoryView *previewView; // 图片展示页面

@end

@implementation ChooseLicenseAccessoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeCollectionView]; // 初始化collectionView
    [self.view addSubview:self.bottomSaveView]; // 添加底部保存按钮的view
    [self initializeNotification]; // 初始化刷新collectionView页面的通知
    
    self.title = @"选择证照附件";
    [self setNav];
    
    self.view.backgroundColor = [UIColor redColor];
    
    NSMutableArray *imageUrlArray = [NSMutableArray arrayWithObjects:@"http://img1.3lian.com/2015/a1/131/d/271.jpg",@"http://img15.3lian.com/2015/a1/15/d/1.jpg",@"http://img1.3lian.com/2015/a1/3/d/53.jpg",@"http://img1.3lian.com/2015/a1/39/d/196.jpg",@"http://pic.nipic.com/2008-03-25/2008325121527690_2.jpg", nil];
    
    for (NSString *imageUrl in imageUrlArray) {
        CertificateCellModel *model = [[CertificateCellModel alloc] init];
        model.isAlbum = NO;
        model.cellImageType = CertificateCellImageEmpty;
        model.imageUrl = imageUrl;
        [self.modelArray addObject:model];
        [self.imageUrlArray addObject:imageUrl];
    }
    
    
    
//    [self loadDataSource];
    
    if (self.isUploadClick) {
        CustomPhotoAlbum *customPhotoAlbum = [[CustomPhotoAlbum alloc] init];
        customPhotoAlbum.modelArray = self.modelArray;
        [self presentViewController:customPhotoAlbum animated:YES completion:nil];
    }
    
}

#pragma mark - loadDataSource 数据加载部分
- (void)loadDataSource {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"OrderCustomerId":self.customerId}];
    
//    [IWHttpTool WMpostWithURL:@"/Order/GetOrderCustomerAttachmentById" params:params success:^(id json){
//        
//        NSLog(@"json ======= %@",json);
//        
//        NSArray * array = json[@"OrderCustomerAttachmentList"];
//        if (array.count) {
//            for (NSDictionary * dic in array) {
//                
//                CertificateCellModel *model = [[CertificateCellModel alloc] init];
//                model.isAlbum = NO;
//                model.cellImageType = CertificateCellImageEmpty;
//                model.imageUrl = dic[@"ImageUrl"];
//                [self.modelArray addObject:model];
//                [self.imageUrlArray addObject:dic[@"ImageUrl"]];
//            }
//        }
//        [self.collectionView reloadData];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"-------页面加载失败error is %@------",error);
//    }];
}

#pragma mark 上传图片接口
- (void)uploadImages {
    
    /**
     基本逻辑：
     1. 在进入页面的时候开始进行添加，判断是否有新添加的图片，如果没有，则直接返回不做任何处理
     2. 如果存在新添加的图片，则先将新的Model添加到一个用于上传图片的数组中
     3. 将新的model从modelArray中移除掉，用新的数组去上传图片
     4. 用上传返回的图片链接从新行程model并添加到modeArray中，行程新的modelArray来刷新页面
     */
    
    NSMutableArray *newImages = [NSMutableArray array];
    NSMutableArray *newImageModels = [NSMutableArray array];
    
    // 对存储新添加图片和model的数组进行赋值
    for (CertificateCellModel *model in self.modelArray) {
        if (model.isNewImage) {
            [newImageModels addObject:model];
            [newImages addObject:model.bigImage];
        }
    }
    
    if (newImages.count == 0) {
        // 如果不存在新的图片，那么直接返回
        [self.collectionView reloadData];
        return;
    }
    
    // 将新的数据从modelArray中移除掉
    [self.modelArray removeObjectsInArray:newImageModels];
    
    // 开始上传
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在添加";
    
    
    NSMutableArray *newImagesArray = [NSMutableArray array];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (UIImage *imageNew in newImages) {
            
            CGSize imagesize = imageNew.size;
            //对图片大小进行压缩--
            UIImage *compressImage = [self imageWithImage:imageNew scaledToSize:imagesize];
            NSData *imageData = UIImageJPEGRepresentation(compressImage,0.5);
            NSString *imageStr = [imageData base64EncodedStringWithOptions:0];
            [newImagesArray addObject:imageStr];
        }
        
//        [IWHttpTool postWithURL:@"/File/UploadPictureMulti" params:@{@"FileStreamData":newImagesArray,@"PictureType":@"1"} success:^(id json) {
//            NSLog(@"json = %@", json);
//            
//            NSLog(@"json ************** %@",json);
//            
//            NSArray *PicUrlArray = json[@"PicUrl"];
//            
//            for (NSString *imageUrl in PicUrlArray) {
//                // 在此处使用新的链接形成新的model，并将其添加到modelArray中
//                CertificateCellModel *model = [[CertificateCellModel alloc] init];
//                model.isAlbum = NO;
//                model.cellImageType = CertificateCellImageEmpty;
//                model.imageUrl = imageUrl;
//                [self.modelArray addObject:model];
//                
//                [self.imageUrlArray addObject:imageUrl];
//                
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //回到主线程
//                [self.collectionView reloadData];
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                [MBProgressHUD showSuccess:@"添加成功"];
//            });
//            
//        } failure:^(NSError * error) {
//            
//        }];
    });
    
    
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark 自定义返回按钮
- (void)setNav {
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,10,16)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fanhuian_white"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

// 退出页面
- (void)back {
    
    // 只有先退出编辑状态，才可以退出页面
    if (self.isEditState) {
        [self cancelItemEditState];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ****************** collectionView代理部分 begin ******************

- (void)initializeCollectionView {
    
#pragma mark 初始化collectionView
    //    1.创建布局管理类---flowLayout:流式布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //    1.1设置滚动方向
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    设置section内部cell之间的距离和大小
    //    1.2设置竖直方向cell之间距离
    layout.minimumInteritemSpacing = 10;
    //    1.3设置行方向cell之间距离
    layout.minimumLineSpacing = 10;
    //    1.4设置cell的大小
    layout.itemSize = CGSizeMake((WIDTH-41)/3, (WIDTH-41)/3);
    //    1.5设置整个section的上下左右的距离
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    //    1.6
    layout.footerReferenceSize = CGSizeMake(WIDTH, 23);
    
    //    2.根据布局管理类创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-GETHEIGHT(self.bottomSaveView)) collectionViewLayout:layout];
    
    //    3.设置数据源，代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor  = RGB_COLOR(241, 241, 246);
    
    //    创建自定义头view--ReusableView
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reuserFooter"];
    // 重用cell部分
    [self.collectionView registerClass:[CertificateCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    
    [self.view addSubview:self.collectionView]; // 添加collectionView
}

// 设置footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reuserableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reuserFooter" forIndexPath:indexPath];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.5, GETWIDTH(reuserableView), 12)];
    label.text = @"长按图片可进行删除";
    label.textColor = RGB_COLOR(194, 194, 208);
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [reuserableView addSubview:label];

    return reuserableView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.modelArray.count+1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CertificateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.delegate = self;
    
    if (indexPath.row == 0) {
        
        CertificateCellModel *model = [[CertificateCellModel alloc] init];
        model.isAlbum = NO;
        model.cellImageType = CertificateCellImagePhoto;
        
        [cell updateCellWithModel:model];
    } else {
        
        // 这只各个item的状态
        CertificateCellModel *model = [self.modelArray objectAtIndex:indexPath.row-1];
        model.index = indexPath.row-1; // 数据在数组中的位置
        [cell updateCellWithModel:model];
    }
    
    return cell;
}

#pragma mark ****************** collectionView代理部分 end ******************

#pragma mark item中各触发事件的代理方法
- (void)certificateCollectionViewCellDelegateEventType:(TouchEventType)touchEventType atIndex:(NSInteger)index {
    
    /**
     在其中对modelArray中的数据进行处理，处理完后刷新页面
     */
    
    switch (touchEventType) {
        case TouchEventTypeEdit: { // 进入编辑状态
            
            for (int i = 0; i < self.modelArray.count; i ++) {
                
                CertificateCellModel *model = [self.modelArray objectAtIndex:i];
                model.cellImageType = CertificateCellImageDelete;
            }
            self.isEditState = YES; // 添加进入编辑状态参数
            [self.collectionView reloadData];
            
            break;
        }

        case TouchEventTypeCancalEdit: { // 取消编辑状态
            
            [self cancelItemEditState]; // 取消编辑状态
            break;
        }
            
        case TouchEventTypeBrowse: {// 进入浏览页面

            self.previewView.hidden = NO;
            self.previewView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            self.previewView.imageUrlArray = self.imageUrlArray;
            [self.previewView updateScrollViewWithModelArray:self.modelArray atIndex:index];
            
            break;
        }
            
        case TouchEventTypeDelete: { // 删除触发事件
            // 先将相关链接删除
            CertificateCellModel *model = [self.modelArray objectAtIndex:index];
            if (model.imageUrl.length) {
                [self.imageUrlArray removeObject:model.imageUrl];
            }
            // 再讲相关model删除
            [self.modelArray removeObjectAtIndex:index];
            
            [self.collectionView reloadData];
            break;
        }
        case TouchEventTypePhoto: { // 进入拍照
            
            // 只有先退出编辑状态，才能点击拍照按钮
            if (self.isEditState) {
                [self cancelItemEditState];
                return;
            }
            NSLog(@"拍照状态");
            CustomPhotoAlbum *customPhotoAlbum = [[CustomPhotoAlbum alloc] init];
            customPhotoAlbum.modelArray = self.modelArray;
            [self presentViewController:customPhotoAlbum animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark 取消编辑状态方法
- (void)cancelItemEditState {
    for (int i = 0; i < self.modelArray.count; i ++) {
        
        CertificateCellModel *model = [self.modelArray objectAtIndex:i];
        model.cellImageType = CertificateCellImageEmpty;
    }
    self.isEditState = NO; // 取消编辑状态
    [self.collectionView reloadData];
}

#pragma mark modelArray的懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

#pragma mark 图片url数组imageUrlArray懒加载
- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

#pragma mark 浏览页面懒加载
- (ChooseLicenseAccessoryView *)previewView {
    if (!_previewView) {
        _previewView = [[ChooseLicenseAccessoryView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_previewView];
    }
    return _previewView;
}

#pragma mark 底部保存按钮view懒加载
- (UIView *)bottomSaveView {
    if (!_bottomSaveView) {
        _bottomSaveView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-65, WIDTH, 65)];
        
        UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15.5, GETWIDTH(_bottomSaveView)-30, 45)];
        saveBtn.center = CGPointMake(GETWIDTH(_bottomSaveView)/2, GETHEIGHT(_bottomSaveView)/2);
        saveBtn.layer.cornerRadius = 4;
        saveBtn.layer.masksToBounds = YES;
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"blue_bg"] forState:UIControlStateNormal];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"blue_bg_Highlighted"] forState:UIControlStateHighlighted];
        [saveBtn setTitleColor:RGBA_COLOR(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [saveBtn addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomSaveView addSubview:saveBtn];
        
        _bottomSaveView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomSaveView;
}

#pragma mark 保存按钮点击事件
- (void)saveButtonClick:(UIButton *)sender {
    
    // 只有先退出编辑状态，才可以进行保存
    if (self.isEditState) {
        [self cancelItemEditState];
        return;
    }
    NSLog(@"保存按钮点击事件");
    /**
     保存按钮中可以进行添加操作
     */
    
    NSLog(@"self.imageUrlArray ========= %@",self.imageUrlArray);
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];

    hudView.label.text = @"保存中...";
    [hudView hideAnimated:YES afterDelay:1];
    
    //    [hudView show:YES atHud:hudView toView:[[UIApplication sharedApplication].delegate window]];
    
//    [IWHttpTool postWithURL:@"/Order/OperationOrderCustomerAttachment" params:@{@"OrderCustomerImageUrl":self.imageUrlArray,@"OrderCustomerId":self.customerId} success:^(id json) {
//        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//        [MBProgressHUD showSuccess:@"保存成功"];
//        NSLog(@"%@", json);
//        
//    } failure:^(NSError *error) {
//    }];
}

#pragma mark ************** 通知部分 begin **************
#pragma mark 初始化通知
- (void)initializeNotification {
    
    // 添加页面数据刷新通知，因为页面通用一个数据
#pragma mark 接收信息对象在通知中心进行注册，包括：信息名称、接受信息时的处理方法。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionViewNotification:) name:reloadChooseLicenseAccessoryVCNotification object:nil];
}

#pragma mark 通知方法
- (void)reloadCollectionViewNotification:(NSNotification *)notification {

    if (notification.userInfo && [[notification.userInfo objectForKey:@"isRefreshOnly"] isEqualToString:@"YES"]) {
        // 根据参数只刷新页面数据
        [self.collectionView reloadData];
    } else {
        [self uploadImages]; // 上传图片部分
    }
}

- (void)dealloc {
#pragma mark 在通知中心注销
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ************** 通知部分 end **************

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
