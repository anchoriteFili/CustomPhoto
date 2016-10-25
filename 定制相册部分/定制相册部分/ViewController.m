//
//  ViewController.m
//  定制相册部分
//
//  Created by 赵宏亚 on 16/10/24.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "ViewController.h"

#import "ChooseLicenseAccessoryVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)ChooseLicenseAccessoryVCPush:(UIButton *)sender {
    
    
    ChooseLicenseAccessoryVC *chooseLicenseAccessoryVC = [[ChooseLicenseAccessoryVC alloc] init];
    chooseLicenseAccessoryVC.title = @"选择证照附件";
    
    [self.navigationController pushViewController:chooseLicenseAccessoryVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
