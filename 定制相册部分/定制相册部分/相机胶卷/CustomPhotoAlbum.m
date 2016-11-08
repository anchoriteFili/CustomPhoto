//
//  CustomPhotoAlbum.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/25.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CustomPhotoAlbum.h"
#import "CertificateCollectionViewCell.h"
#import "CertificateTableViewCell.h"
#import "CustomCameraVC.h" // 拍照页面
#import "AlbumTool.h"
#import "CustomPhotoAlbumPreviewView.h" // 预览页面

@interface CustomPhotoAlbum ()<UICollectionViewDataSource,UICollectionViewDelegate,CertificateCollectionViewCellDelegate,UITableViewDataSource,UITableViewDelegate,CustomCameraVCDelegate,CustomPhotoAlbumPreviewViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *middleHeaderButton; // 相册胶卷Button
@property (weak, nonatomic) IBOutlet UIButton *ensuerButton; // 确定按钮点击
@property (weak, nonatomic) IBOutlet UILabel *ensureLabel; // 确定label
@property (weak, nonatomic) IBOutlet UILabel *middleHeaderLabel; // 头部label创建
@property (weak, nonatomic) IBOutlet UIImageView *headerArrowImageView; // 箭头图片

@property (nonatomic,retain) UICollectionView *collectionView; // 创建collectionView
@property (nonatomic,strong) UIView *tableViewBackView; // 承载tableView的背景view
@property (nonatomic,retain) UITableView *tableView; // 用于显示相册名的tableView

@property (nonatomic,strong) NSMutableArray *modelAdditionArray; // 用于存储从相册或相机中添加的图片
@property (nonatomic,strong) NSMutableArray *albumModelArray; // 用于存储所有的相册中的图片
@property (nonatomic,strong) NSMutableArray *albumsArray; // 相册的数组
@property (nonatomic,assign) BOOL isTableViewShow; // 是否像显示tableView

#pragma mark 相册滑动处理相关
@property (nonatomic,assign) NSInteger totalPage; // 相册中所有的照片页数
@property (nonatomic,assign) NSInteger totalPhotos; // 相册中所有的照片数量
@property (nonatomic,assign) NSInteger currentPage; // 当前已经加载的页数
@property (nonatomic,assign) NSInteger albumIndex; // 选择的相册的编号
@property (nonatomic,assign) BOOL isAddPage; // 是否添加相册页数
@property (nonatomic,assign) BOOL isFirstAdd; // 在滑动时不回到顶部判断，用于控制回到顶部

@property (nonatomic,retain) CustomPhotoAlbumPreviewView *previewView; // 图片展示页面


@end

@implementation CustomPhotoAlbum

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initializeCollectionView]; // 创建collectionView
    [self initializeTableView]; // tableView的初始化
    [self selectAlbumWithIndex:0]; // 默认显示第一个相册
}

#pragma mark ****************** collectionView部分 begin ******************
#pragma mark collectionView初始化
- (void)initializeCollectionView {
    
#pragma mark collectionView
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
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-45) collectionViewLayout:layout];
    
    //    3.设置数据源，代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = RGB_COLOR(241, 241, 246);
    
    // 重用cell部分
    [self.collectionView registerClass:[CertificateCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    
    [self.view addSubview:self.collectionView]; // 添加collectionView
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.totalPhotos+1;
//    return self.albumModelArray.count+1;
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
        
        if (indexPath.row-1 < self.albumModelArray.count) {
            // 这只各个item的状态
            CertificateCellModel *model = [self.albumModelArray objectAtIndex:indexPath.row-1];
            model.index = indexPath.row-1; // 数据在数组中的位置
            [cell updateCellWithModel:model];
        } else {
            
            CertificateCellModel *model = [[CertificateCellModel alloc] init];
            model.itemImage = [UIImage imageNamed:@"CommandplaceholderImage"];
            model.cellImageType = CertificateCellImageDeselect;

            [cell updateCellWithModel:model];
        }
    }
    
    return cell;
}

#pragma mark 滚动代理相关
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.collectionView) {
        
        if (self.isAddPage && self.collectionView.contentOffset.y > self.currentPage*3000-700 && self.currentPage < self.totalPage ) {
            
            self.isAddPage = NO;
            
            // 获取单个相册中的200张图片
            [AlbumTool getAlbumThumbnailWithAssetCollection:[self.albumsArray objectAtIndex:self.albumIndex] withPage:self.currentPage+1 andComplete:^(NSMutableArray *modelArray, NSInteger totalPhotos, NSInteger totalPage, NSInteger currentPage) {
                
                [self.albumModelArray addObjectsFromArray:modelArray];
                self.currentPage = currentPage; // 指定当前页数
                self.totalPage = totalPage; // 获取相册所有页数
                self.isAddPage = YES; // 如果有了返回数据，则可以进行添加了
                
                // 新添加一步，对两个数据源进行比较，用于初始化显示
                [self compareTwoModelArray]; // 可以一次匹配100张，这个也许可以
            }];
        }
    }
}

#pragma mark ****************** collectionView代理部分 end ******************
#pragma mark =========================================================
#pragma mark ****************** tableView部分 begin ******************
#pragma mark tableView初始化
- (void)initializeTableView {
    
    // 添加承载背景view
    self.tableViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    self.tableViewBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableViewBackView];
    
    // 添加灰背景view
//    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GETWIDTH(self.tableViewBackView), GETHEIGHT(self.tableViewBackView))];
    
    UIButton *grayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    grayButton.frame = CGRectMake(0, 0, GETWIDTH(self.tableViewBackView), GETHEIGHT(self.tableViewBackView));
    [grayButton addTarget:self action:@selector(grayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    grayButton.backgroundColor = [UIColor blackColor];
    grayButton.alpha = 0.5;
    [self.tableViewBackView addSubview:grayButton];
    
#pragma mark 创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GETWIDTH(self.tableViewBackView), 186) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    设置tableView背景色为透明色
    self.tableView.backgroundColor = [UIColor clearColor];
    //    分割线样式
    //     self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //去掉空白cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableViewBackView addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CertificateTableViewCell" bundle:nil] forCellReuseIdentifier:identifierTableViewCell];
}

#pragma mark tableView后灰色背景点击事件
- (void)grayButtonClick:(UIButton *)sender {
    
    // 刷新头部相册名相关
    self.isTableViewShow = NO;
    self.tableViewBackView.hidden = YES;
    self.headerArrowImageView.image = [UIImage imageNamed:@"CustomPhotoAlbum_expandImage"]; // 显示下箭头
}

#pragma mark 设置每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

#pragma mark 设置section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.albumsArray.count;
}

#pragma mark cellForRow方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CertificateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTableViewCell forIndexPath:indexPath];
    
    PHAssetCollection *assetCollection = [self.albumsArray objectAtIndex:indexPath.row];
    
    if ([assetCollection.localizedTitle isEqualToString:@"All Photos"]) {
        cell.contentLabel.text = [NSString stringWithFormat:@"所有相册 %lu",(unsigned long)[AlbumTool getAlbumCountWith:assetCollection]];
    } else {
        cell.contentLabel.text = [NSString stringWithFormat:@"%@ %lu",assetCollection.localizedTitle, (unsigned long)[AlbumTool getAlbumCountWith:assetCollection]];
    }
    
    [AlbumTool getCoverImageWith:assetCollection withBlcok:^(UIImage *image) {
        cell.headImageView.image = image;
    }];
    
    return cell;
}

#pragma mark 添加点击cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 加载数据
    [self selectAlbumWithIndex:indexPath.row];
    self.isFirstAdd = YES;
    
    //点击以后直接恢复正常状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark ****************** tableView部分 end ******************

#pragma mark item中各触发事件的代理方法
- (void)certificateCollectionViewCellDelegateEventType:(TouchEventType)touchEventType atIndex:(NSInteger)index {
    
    /**
     在其中对modelArray中的数据进行处理，处理完后刷新页面
     */
    switch (touchEventType) {
        case TouchEventTypeSelect: { // 选中状态 albumModelArray
            // 9张图片的限制
            if (self.modelAdditionArray.count >= 5) {
                [MBProgressHUD showError:@"最多只能添加5张"];
                return;
            }
            
            // 将选中的添加进数组
            CertificateCellModel *model = [self.albumModelArray objectAtIndex:index];
            model.cellImageType = CertificateCellImageSelect;
            model.isNewImage = YES;
            [self.modelAdditionArray addObject:model];
            
            if (!model.bigImage) { // 选中，如果是首次添加，则进行添加，不是首次不添加
                [AlbumTool photoWithAssetCollection:model.assetCollection withLocalIdentifier:model.localIdentifier andPage:model.page withBlcok:^(UIImage *bigImage) {
                    
                    if (bigImage) {
                        model.bigImage = bigImage;
                    } else {
                        model.bigImage = model.itemImage;
                    }
                }];
            }
            
            [self updateEnsureButtonContent]; // 更新确定按钮
            [self.collectionView reloadData];
            break;
        }
            
        case TouchEventTypeDeselect: {// 不选中状态
            CertificateCellModel *model = [self.albumModelArray objectAtIndex:index];
            model.cellImageType = CertificateCellImageDeselect;
            
            /**
             这个就尴尬了，要怎么弄呢？不是同一个啊。
             */
            for (CertificateCellModel *removeMode in self.modelAdditionArray) {
                if ([removeMode.localIdentifier isEqualToString:model.localIdentifier]) {
                    [self.modelAdditionArray removeObject:removeMode];
                    break;
                }
            }
            [self updateEnsureButtonContent]; // 更新确定按钮
            [self.collectionView reloadData];
            break;
        }
            
        case TouchEventTypePhoto: { // 进入拍照
            
            CustomCameraVC *customCameraVC = [[CustomCameraVC alloc] init];
            customCameraVC.modelAdditionArray = self.modelAdditionArray;
            customCameraVC.modelArray = self.modelArray;
            customCameraVC.delegate = self;
            [self presentViewController:customCameraVC animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark 相机页面传过来
- (void)customCameraCVButtonClickEventType:(CustomCameraVCButtonClickType)touchEventType {
    
    switch (touchEventType) {
        case CustomCameraVCButtonClickTypeCancleClick: { // 取消按钮
            // 暂时不做任何处理
            break;
        }
            
        case CustomCameraVCButtonClickTypeCompleteClick: { // 完成按钮
            // 直接退出页面即可 本页面暂不做处理

            break;
        }
            
        case CustomCameraVCButtonClickTypeAlbumClick: { // 去相册按钮
            
            self.albumModelArray = nil;
            self.albumsArray = nil;
            [self selectAlbumWithIndex:0]; // 获取第一个相册的数据
            
            break;
        }
        default:
            break;
    }
}

- (NSMutableArray *)modelAdditionArray {
    if (!_modelAdditionArray) {
        _modelAdditionArray = [NSMutableArray array];
    }
    return _modelAdditionArray;
}


#pragma mark *************** 页面中自定义按钮点击事件 begin ***************
#pragma mark 取消按钮点击事件
- (IBAction)cancalButtonClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 头部相机胶卷按钮点击事件
- (IBAction)photoAlbumTypeClick:(UIButton *)sender {
    /**
     基本逻辑：
     同步按钮可以连续点击，点击一次展开，再点击一次关闭，需要特定的属性值进行处理
     */
    
    self.isTableViewShow = !self.isTableViewShow;
    
    
    if (self.isTableViewShow) {
        self.tableViewBackView.hidden = NO;
        self.headerArrowImageView.image = [UIImage imageNamed:@"CustomPhotoAlbum_retractImage"]; // 显示上箭头
    } else {
        self.tableViewBackView.hidden = YES;
        self.headerArrowImageView.image = [UIImage imageNamed:@"CustomPhotoAlbum_expandImage"]; // 显示上箭头
    }
    
}

#pragma mark 确定按钮点击事件
- (IBAction)ensureButtonClick:(UIButton *)sender {
    
    /**
     基本逻辑：
     1. 刷新选择证照附件页面
     2. 并退出当前页面
     */
    
    for (CertificateCellModel *model in self.modelAdditionArray) {
        model.cellImageType = CertificateCellImageEmpty;
    }
    
    // 将数据添加过去
    [self.modelArray addObjectsFromArray:self.modelAdditionArray];
#pragma mark 刷新选择证照附件页面
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadChooseLicenseAccessoryVCNotification object:self userInfo:nil];
    
    // 收回自己页面
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 更新确定按钮中的相关内容方法
- (void)updateEnsureButtonContent {
    self.ensureLabel.text = [NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.modelAdditionArray.count];
}

#pragma mark 预览按钮点击事件
- (IBAction)previewButtonClick:(UIButton *)sender {
    
    /**
     预览view的创建：
         创建页面，完成相关链接即可，其实逻辑基本相同
     */
    
    if (self.modelAdditionArray.count) {
        self.previewView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [self.previewView updateScrollViewWithModelArray:self.modelAdditionArray atIndex:0];
        self.previewView.delegate = self;
        self.previewView.hidden = NO;
    } else {
        [MBProgressHUD showError:@"请选择您要浏览的图片"];
    }

}

#pragma mark 预览页面中完成按钮点击事件
- (void)customPhotoAlbumPreviewCompleteButtonClickWithDeleteModel:(NSMutableArray *)deleteModelArray {

    [self.collectionView reloadData]; // 直接刷新数据即可
}

#pragma mark 浏览页面懒加载
- (CustomPhotoAlbumPreviewView *)previewView {
    if (!_previewView) {
        _previewView = [[CustomPhotoAlbumPreviewView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_previewView];
        self.previewView.hidden = YES;
    }
    return _previewView;
}


#pragma mark *************** 页面中自定义按钮点击事件 end ***************

#pragma mark ************ 相册处理部分 begin ************
#pragma mark 相册数组懒加载
- (NSMutableArray *)albumsArray {
    if (!_albumsArray) {
        _albumsArray = [AlbumTool getAlbumObjects];
    }
    return _albumsArray;
}

#pragma mark 相册内所有图片数组懒加载
- (NSMutableArray *)albumModelArray {
    if (!_albumModelArray) {
        _albumModelArray = [NSMutableArray array];
    }
    return _albumModelArray;
}

#pragma mark 加载相册显示数据
- (void)selectAlbumWithIndex:(NSInteger)index {
    
    self.albumIndex = index; // 记住相册的编号
    
    // 刷新头部相册名相关
    self.isTableViewShow = NO;
    self.tableViewBackView.hidden = YES;
    self.headerArrowImageView.image = [UIImage imageNamed:@"CustomPhotoAlbum_expandImage"]; // 显示上箭头
    
    [self.albumModelArray removeAllObjects]; // 先清空相册
    
    PHAssetCollection *assetCollection = [self.albumsArray objectAtIndex:index];
    
    if ([assetCollection.localizedTitle isEqualToString:@"All Photos"]) {
        self.middleHeaderLabel.text = @"所有相册";
    } else {
        self.middleHeaderLabel.text = assetCollection.localizedTitle;
    }
    // 获取单个相册中的200张图片
    [AlbumTool getAlbumThumbnailWithAssetCollection:[self.albumsArray objectAtIndex:index] withPage:0 andComplete:^(NSMutableArray *modelArray,NSInteger totalPhotos, NSInteger totalPage, NSInteger currentPage) {
        
        [self.albumModelArray removeAllObjects];
        [self.albumModelArray addObjectsFromArray:modelArray];
        self.currentPage = currentPage; // 指定当前页数
        self.totalPage = totalPage; // 获取相册所有页数
        self.isAddPage = YES; // 如果有了返回数据，则可以进行添加了
        self.totalPhotos = totalPhotos;
        
        // 新添加一步，对两个数据源进行比较，用于初始化显示
        [self compareTwoModelArray]; // 可以一次匹配100张，这个也许可以
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self updateEnsureButtonContent]; // 刷新确定按钮内容
}

#pragma mark 比较两个数组中元素
- (void)compareTwoModelArray {
    
    /**
     匹配规则：
     新添加判断，一次只匹配比较pageNumber张
     */
    
    NSLog(@"self.modelAdditionArray.count; ==== %lu",(unsigned long)self.modelAdditionArray.count);
    
    NSInteger compareNumber = 0;
    
    if (self.currentPage*PageNumber + PageNumber < self.albumModelArray.count) {
        compareNumber = self.currentPage*PageNumber + PageNumber;
    } else {
        compareNumber = self.albumModelArray.count;
    }
    
    for (CertificateCellModel *model in self.modelAdditionArray) {
        
        for (NSInteger i = self.currentPage*PageNumber; i < compareNumber; i ++) {
            
            CertificateCellModel *modelOne = [self.albumModelArray objectAtIndex:i];
            
            if ([model.localIdentifier isEqualToString:modelOne.localIdentifier]) {
                
                NSLog(@"匹配到一张");
                modelOne.cellImageType = CertificateCellImageSelect;
                break;
            }
        }
    }
    
    // 在第一次添加的时候给一个第一次添加状态，其他的滑动启动这个方法，不会到顶部
    if (self.isFirstAdd) {
        // 数据加载完毕，将页面回到顶部
        self.collectionView.contentOffset=CGPointMake(0, 0);
        self.isFirstAdd = NO;
    }
    
    // 刷新数据
    [self.collectionView reloadData];
}

#pragma mark ************ 相册处理部分 end ************


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
