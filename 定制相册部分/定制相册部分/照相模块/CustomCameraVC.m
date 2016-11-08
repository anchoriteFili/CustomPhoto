//
//  CustomCameraVC.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/26.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CustomCameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomCameraCVCell.h"
#import "CustomCameraUsePhotoView.h" // 拍照后显示的数据
#import "ImageDirectionTool.h" // 旋转图片工具
#import "ChooseLicenseAccessoryVC.h" //


typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface CustomCameraVC ()<UICollectionViewDelegate,UICollectionViewDataSource,CustomCameraCVCellDelegate>

#pragma mark ******* collectionView部分 ********
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; // 用于存放拍过照片
// 用于存放所有的从上级传过来的图片和相机拍到的图片，先进行赋值
@property (nonatomic,strong) NSMutableArray *modelTakePhotosArray;

@property (nonatomic,assign) BOOL isFlashOn; //闪光灯是否开启
@property (nonatomic,assign) CameraFlashlightState cameraFlashlightState; // 闪光灯状态

#pragma mark ******* 相机部分 *******
@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton *takeButton;//拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *flashButton; // 闪光灯按钮

// 下面的暂时没用
@property (weak, nonatomic) IBOutlet UIButton *flashAutoButton;//自动闪光灯按钮
@property (weak, nonatomic) IBOutlet UIButton *flashOnButton;//打开闪光灯按钮
@property (weak, nonatomic) IBOutlet UIButton *flashOffButton;//关闭闪光灯按钮
@property (weak, nonatomic) IBOutlet UIImageView *focusCursor; //聚焦光标

@property (nonatomic,retain) CustomCameraUsePhotoView *usePhotoView; // 是否使用照片页面

#pragma mark 重力感应部分 ***
@property (nonatomic,assign) UIImageOrientation imageOrientation; // 用于保存当前方向状态
@property (nonatomic,strong) CMMotionManager *mManager; // 重力感应管理
@property (nonatomic,assign) NSTimeInterval updateInterval; // 时间间隔

@end

@implementation CustomCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self collectionViewInitialization]; // 初始化collectionView
    
    self.cameraFlashlightState = CameraFlashlightStateAuto; //初始化的时候自动
    [self.flashButton setImage:[UIImage imageNamed:@"CameraFlashlight_Auto"] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    // 打开状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 关闭状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
#pragma mark 非常重要的一个地方AVCaptureSessionPreset640x480否则会超屏
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset640x480;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    self.viewContainer.layer.frame = CGRectMake(0, 0, WIDTH, HEIGHT-168);
    CALayer *layer=self.viewContainer.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame = layer.frame;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    //[layer addSublayer:_captureVideoPreviewLayer];
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
    [self setFlashModeButtonStatus];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

-(void)dealloc{
    _mManager = nil; // 清除重力感应
    [self removeNotification];
}
#pragma mark - UI方法
#pragma mark 拍照
- (IBAction)takeButtonClick:(UIButton *)sender {
    
    // 9张图片的限制
    if (self.modelTakePhotosArray.count >= 5) {
//        [MBProgressHUD showError:@"最多只能添加5张"];
        return;
    }
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image=[UIImage imageWithData:imageData];
            
            // 页面显示是开启重力感应
            [ImageDirectionTool startUpdateAccelerometerWithManager:self.mManager Result:^(UIImageOrientation direction) {
                
                // 处理方向后的图片
                UIImage *newImage = [ImageDirectionTool image:image rotation:direction];
                
                CertificateCellModel *model = [[CertificateCellModel alloc] init];
                model.isNewImage = YES;
                model.itemImage = newImage;
                model.bigImage = newImage;
                
                self.usePhotoView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                self.usePhotoView.hidden = NO;
                
                [self.usePhotoView updateViewWithModel:model andCompleteWithBlock:^(BOOL isUsePhoto) {
                    // 如果返回YES，则添加数组，如果返回NO，则不做任何处理
                    
                    if (isUsePhoto) {
                        
                        // 如果选择使用图片，将图片保存到相册
                        [AlbumTool saveImage:newImage withLocalIdentifier:^(NSString *localIdentifier) {

                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                model.localIdentifier = localIdentifier;
                                [self.modelTakePhotosArray addObject:model];
                                //回到主线程刷新collectionView
                                [self.collectionView reloadData];
                            });
                            
                        }];
                    }
                }];

                NSLog(@"direction ====== %ld",(long)direction);
            }];
        }
    }];
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
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


#pragma mark 切换前后摄像头
- (IBAction)toggleButtonClick:(UIButton *)sender {
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
    
    [self setFlashModeButtonStatus];
}


#pragma mark 是否开启闪光灯
- (IBAction)flashButtonClick:(UIButton *)sender {
    
    
    switch (self.cameraFlashlightState) {
        case CameraFlashlightStateAuto: {
            
            // 关闭闪光灯
            [self setFlashMode:AVCaptureFlashModeOff];
            [sender setImage:[UIImage imageNamed:@"CameraFlashlight_OFF"] forState:UIControlStateNormal];
            [self setFlashModeButtonStatus];
            self.cameraFlashlightState = CameraFlashlightStateOFF;
            break;
        }

        case CameraFlashlightStateOFF: {
            // 打开闪光灯
            [self setFlashMode:AVCaptureFlashModeOff];
            [sender setImage:[UIImage imageNamed:@"CameraFlashlight_ON"] forState:UIControlStateNormal];
            [self setFlashModeButtonStatus];
            self.cameraFlashlightState = CameraFlashlightStateON;
            break;
        }
            
        case CameraFlashlightStateON: {
            // 闪光灯自动
            [self setFlashMode:AVCaptureFlashModeAuto];
            [sender setImage:[UIImage imageNamed:@"CameraFlashlight_Auto"] forState:UIControlStateNormal];
            [self setFlashModeButtonStatus];
            self.cameraFlashlightState = CameraFlashlightStateAuto;
            break;
        }

        default:
            break;
    }
    self.isFlashOn = !self.isFlashOn;
}

#pragma mark 自动闪光灯开启
- (IBAction)flashAutoClick:(UIButton *)sender {
    [self setFlashMode:AVCaptureFlashModeAuto];
    [self setFlashModeButtonStatus];
}

#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
//    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.viewContainer];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置闪光灯按钮状态
 */
-(void)setFlashModeButtonStatus{
    AVCaptureDevice *captureDevice=[self.captureDeviceInput device];
    AVCaptureFlashMode flashMode=captureDevice.flashMode;
    if([captureDevice isFlashAvailable]){
        self.flashAutoButton.hidden=NO;
        self.flashOnButton.hidden=NO;
        self.flashOffButton.hidden=NO;
        self.flashAutoButton.enabled=YES;
        self.flashOnButton.enabled=YES;
        self.flashOffButton.enabled=YES;
        switch (flashMode) {
            case AVCaptureFlashModeAuto:
                self.flashAutoButton.enabled=NO;
                break;
            case AVCaptureFlashModeOn:
                self.flashOnButton.enabled=NO;
                break;
            case AVCaptureFlashModeOff:
                self.flashOffButton.enabled=NO;
                break;
            default:
                break;
        }
    }else{
        self.flashAutoButton.hidden=YES;
        self.flashOnButton.hidden=YES;
        self.flashOffButton.hidden=YES;
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
}

#pragma mark modelTakePhotosArray的懒加载,先进行赋值
- (NSMutableArray *)modelTakePhotosArray {
    if (!_modelTakePhotosArray) {
        _modelTakePhotosArray = [NSMutableArray array];
        
        // 先承接相册中的数组，
        _modelTakePhotosArray = [NSMutableArray arrayWithArray:self.modelAdditionArray];
        NSLog(@"_modelTakePhotosArray ======= %@",_modelTakePhotosArray);
    }
    return _modelTakePhotosArray;
}



#pragma mark *************** collectionView部分 begin ***************
- (void)collectionViewInitialization {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CustomCameraCVCell class] forCellWithReuseIdentifier:identifierCustomCameraCVCell];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.modelTakePhotosArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCameraCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCustomCameraCVCell forIndexPath:indexPath];
    cell.delegate = self;
    CertificateCellModel *model = [self.modelTakePhotosArray objectAtIndex:indexPath.row];
    model.index = indexPath.row;
    [cell updateCellWithModel:model];
    
    return cell;
}

#pragma mark *************** collectionView部分 end ***************

#pragma mark cell代理部分
- (void)customCameraCVCellClickEventType:(CustomCameraCVCellClickType)touchEventType atIndex:(NSInteger)index {
    
    switch (touchEventType) {
        case CustomCameraCVCellClickTypeBigImage: { // 点击大图片，进入浏览页
            
            break;
        }
            
        case CustomCameraCVCellClickTypeSmallImage: { // 点击小图片，删除相关数据
            
            [self.modelTakePhotosArray removeObjectAtIndex:index];
            [self.collectionView reloadData];
            break;
        }

        default:
            break;
    }
    
}

#pragma mark *************** 自定义按钮方法部分 begin ***************
#pragma mark 取消按钮点击事件
- (IBAction)cancalButtonClick:(UIButton *)sender {
    /**
     基本逻辑：
     点击取消，不做任何处理，但是还是要写过去，以防万一
     */
    if (_delegate && [_delegate respondsToSelector:@selector(customCameraCVButtonClickEventType:)]) {
        [_delegate customCameraCVButtonClickEventType:CustomCameraVCButtonClickTypeCancleClick];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 完成按钮点击事件
- (IBAction)completeButtonClick:(UIButton *)sender {
    /**
     基本逻辑： CertificateCellImageEmpty
     点击完成，收回页面，并进入展示页面，将新添加的图片添加进去。
     这个有个问题，怎么把数据传过去，这是个问题，可以这样，原数据本身就是条线线，这样的话就可以了
     */
    
    for (CertificateCellModel *model in self.modelTakePhotosArray) {
        model.cellImageType = CertificateCellImageEmpty;
    }
    
    // 将数据添加过去
    [self.modelArray addObjectsFromArray:self.modelTakePhotosArray];
    
#pragma mark 刷新选择证照附件页面
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadChooseLicenseAccessoryVCNotification object:self userInfo:nil];
    
    // 完成按钮的代理方法
    if (_delegate && [_delegate respondsToSelector:@selector(customCameraCVButtonClickEventType:)]) {
        [_delegate customCameraCVButtonClickEventType:CustomCameraVCButtonClickTypeCompleteClick];
    }
    
    // 直接退回到选择证照附件页面
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 去相册按钮点击事件
- (IBAction)goPhotoAlbumButtonClick:(UIButton *)sender {
    /**
     基本逻辑：
     1. 将相机中照片数组直接复制到相机胶卷页面选中数组
     2. 启用代理方法，刷新相机胶卷页面数据
     3. 退出页面
     */
    
    [self.modelAdditionArray removeAllObjects];
    [self.modelAdditionArray addObjectsFromArray:self.modelTakePhotosArray];
    
    NSLog(@"self.modelAdditionArray ===== %@",self.modelAdditionArray);
    
    if (_delegate && [_delegate respondsToSelector:@selector(customCameraCVButtonClickEventType:)]) {
        [_delegate customCameraCVButtonClickEventType:CustomCameraVCButtonClickTypeAlbumClick];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark *************** 自定义按钮方法部分 end ***************

#pragma mark 是否使用照片view懒加载
- (CustomCameraUsePhotoView *)usePhotoView {
    if (!_usePhotoView) {
        _usePhotoView = [[CustomCameraUsePhotoView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_usePhotoView];
        _usePhotoView.hidden = YES;
    }
    return _usePhotoView;
}

#pragma mark ************ 重力感应部分 begin ************
// 重力感应管理懒加载
- (CMMotionManager *)mManager {
    if (!_mManager) {
        self.updateInterval = 5;
        _mManager = [[CMMotionManager alloc] init];
    }
    return _mManager;
}


#pragma mark ************ 重力感应部分 end ************


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
