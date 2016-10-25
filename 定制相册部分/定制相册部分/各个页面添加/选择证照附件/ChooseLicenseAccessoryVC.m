//
//  ChooseLicenseAccessoryVC.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/24.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "ChooseLicenseAccessoryVC.h"
#import "CertificateCollectionViewCell.h"

@interface ChooseLicenseAccessoryVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain) UICollectionView *collectionView; // 创建collectionView

@end

@implementation ChooseLicenseAccessoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //    1.6
//    layout.headerReferenceSize = CGSizeMake(320, 10);
    
    //    2.根据布局管理类创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    //    3.设置数据源，代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
     [self.collectionView registerClass:[CertificateCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    
    self.collectionView.backgroundColor  = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
   
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 20;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CertificateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    

    return cell;
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
