//
//  CustomPhotoAlbum.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/25.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CustomPhotoAlbum.h"
#import "CertificateCollectionViewCell.h"

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
    
#pragma mark 初始化数据
    NSArray *imageUrlArray = @[@"http://img.ivsky.com/img/bizhi/slides/201511/11/december.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/267f9e2f0708283890f56e02bb99a9014c08f128.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/b219ebc4b74543a9fa0c4bc11c178a82b90114a3.jpg",@"http://c.hiphotos.baidu.com/image/pic/item/024f78f0f736afc33b1dbe65b119ebc4b7451298.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/77094b36acaf2edd481ef6e78f1001e9380193d5.jpg"];
    
    for (int i = 0; i < imageUrlArray.count; i ++) {
        
        CertificateCellModel *model = [[CertificateCellModel alloc] init];
        model.isAlbum = NO;
        model.cellImageType = CertificateCellImageEmpty;
        model.imageUrl = [imageUrlArray objectAtIndex:i];
        [self.modelArray addObject:model];
    }
    
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
