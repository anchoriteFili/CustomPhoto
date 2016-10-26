//
//  CustomPhotoAlbum.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/25.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CustomPhotoAlbum.h"
#import "CertificateCollectionViewCell.h"
#import <Photos/Photos.h>

@interface CustomPhotoAlbum ()<UICollectionViewDataSource,UICollectionViewDelegate,CertificateCollectionViewCellDelegate>

@property (nonatomic,retain) UICollectionView *collectionView; // 创建collectionView

@property (nonatomic,retain) NSMutableArray *modelArray; // model数据数组

@end

@implementation CustomPhotoAlbum

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
    layout.itemSize = CGSizeMake((WIDTH-40)/3, (WIDTH-40)/3);
    //    1.5设置整个section的上下左右的距离
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    //    1.6
    layout.footerReferenceSize = CGSizeMake(WIDTH, 23);
    
    //    2.根据布局管理类创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-45) collectionViewLayout:layout];
    
    //    3.设置数据源，代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor  = RGB_COLOR(241, 241, 246);
    
    // 重用cell部分
    [self.collectionView registerClass:[CertificateCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    
    [self.view addSubview:self.collectionView]; // 添加collectionView
    
    [self getThumbnailImages]; // 获取相册中的缩略图
    
}

#pragma mark ****************** collectionView代理部分 begin ******************
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
            [self.collectionView reloadData];
            
            break;
        }
            
        case TouchEventTypeCancalEdit: { // 取消编辑状态
            
            for (int i = 0; i < self.modelArray.count; i ++) {
                
                CertificateCellModel *model = [self.modelArray objectAtIndex:i];
                model.cellImageType = CertificateCellImageEmpty;
            }
            
            [self.collectionView reloadData];
            
            break;
            
        }
            
        case TouchEventTypeBrowse: // 进入浏览页面
            NSLog(@"进入浏览页面");
            
            break;
            
        case TouchEventTypeDelete: { // 删除触发事件
            
            [self.modelArray removeObjectAtIndex:index];
            [self.collectionView reloadData];
            break;
        }
            
        case TouchEventTypeSelect: { // 选中状态
            
            CertificateCellModel *model = [self.modelArray objectAtIndex:index];
            model.cellImageType = CertificateCellImageSelect;
            [self.collectionView reloadData];
            break;
        }
            
        case TouchEventTypeDeselect: {// 不选中状态
            CertificateCellModel *model = [self.modelArray objectAtIndex:index];
            model.cellImageType = CertificateCellImageDeselect;
            [self.collectionView reloadData];
            break;
        }
            
        case TouchEventTypePhoto: { // 进入拍照
            NSLog(@"拍照状态");
            break;
        }
            
        default:
            break;
    }
}

#pragma mark modelArray的懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}


#pragma mark *************** 页面中自定义按钮点击事件 begin ***************
#pragma mark 取消按钮点击事件
- (IBAction)cancalButtonClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 相机胶卷点击事件
- (IBAction)photoAlbumTypeClick:(UIButton *)sender {
    
}

#pragma mark 确定按钮点击事件
- (IBAction)ensureButtonClick:(UIButton *)sender {
}

#pragma mark 预览按钮点击事件
- (IBAction)previewButtonClick:(UIButton *)sender {
}

#pragma mark *************** 页面中自定义按钮点击事件 end ***************



#pragma mark ************ 相册获取部分 begin ****************
#pragma mark 获取所有的原图
- (void)getOriginalImages {
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}

#pragma mark 获取所有的缩略图
- (void)getThumbnailImages {
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    NSLog(@"assets.count ========== %lu",(unsigned long)assets.count);
    
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);

#pragma mark 初始化数据
            CertificateCellModel *model = [[CertificateCellModel alloc] init];
            model.isAlbum = NO;
            model.itemImage = result;
            model.cellImageType = CertificateCellImageEmpty;
            [self.modelArray addObject:model];

        }];
        NSLog(@"添加结束");
    }
}

#pragma mark ************ 相册获取部分 end ****************

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
