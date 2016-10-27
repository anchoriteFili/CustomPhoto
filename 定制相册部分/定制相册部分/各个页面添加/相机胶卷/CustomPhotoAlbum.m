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

@interface CustomPhotoAlbum ()<UICollectionViewDataSource,UICollectionViewDelegate,CertificateCollectionViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UICollectionView *collectionView; // 创建collectionView
@property (nonatomic,strong) UIView *tableViewBackView; // 承载tableView的背景view
@property (nonatomic,retain) UITableView *tableView; // 用于显示相册名的tableView

@property (nonatomic,strong) NSMutableArray *albumsArray; // 相册的数组

@property (weak, nonatomic) IBOutlet UIButton *middleHeaderButton; // 相册胶卷Button


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
#pragma mark =========================================================
#pragma mark ****************** tableView部分 begin ******************
#pragma mark tableView初始化
- (void)initializeTableView {
    
    // 添加承载背景view
    self.tableViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    self.tableViewBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableViewBackView];
    
    // 添加灰背景view
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GETWIDTH(self.tableViewBackView), GETHEIGHT(self.tableViewBackView))];
    
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.5;
    [self.tableViewBackView addSubview:grayView];
    
#pragma mark 创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GETWIDTH(self.tableViewBackView), GETHEIGHT(self.tableViewBackView)) style:UITableViewStylePlain];
    
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
    
    [self selectAlbumWithIndex:indexPath.row];
    
    
    
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
            
            CustomCameraVC *customCameraVC = [[CustomCameraVC alloc] init];
            customCameraVC.modelArray = self.modelArray;
            
            [self presentViewController:customCameraVC animated:YES completion:nil];
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
    
    self.tableViewBackView.hidden = NO;
    
}

#pragma mark 确定按钮点击事件
- (IBAction)ensureButtonClick:(UIButton *)sender {
}

#pragma mark 预览按钮点击事件
- (IBAction)previewButtonClick:(UIButton *)sender {
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

#pragma mark 加载相册显示数据
- (void)selectAlbumWithIndex:(NSInteger)index {
    
    [self.modelArray removeAllObjects];
    self.tableViewBackView.hidden = YES; // 隐藏tableView
    
    PHAssetCollection *assetCollection = [self.albumsArray objectAtIndex:index];
    
    if ([assetCollection.localizedTitle isEqualToString:@"All Photos"]) {
        [self.middleHeaderButton setTitle:@"所有相册" forState:UIControlStateNormal];
    } else {
        [self.middleHeaderButton setTitle:assetCollection.localizedTitle forState:UIControlStateNormal];
    }
    
    // 获取单个相册中的图片
    NSMutableArray *imagesArray = [AlbumTool getAlbumThumbnailWithAssetCollection:[self.albumsArray objectAtIndex:index]];
    
    // 将图片添加到数据源
    for (UIImage *image in imagesArray) {
        CertificateCellModel *model = [[CertificateCellModel alloc] init];
        model.itemImage = image;
        model.cellImageType = CertificateCellImageDeselect;
        [self.modelArray addObject:model];
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
