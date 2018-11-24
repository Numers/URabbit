//
//  UTEditUserInfoViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTEditUserInfoViewController.h"

@interface UTEditUserInfoViewController ()

@end

@implementation UTEditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"个人信息"];
    [self navigationBarSetting];
}

-(void)navigationBarSetting
{
    [self.navigationController setNavigationBarHidden:NO];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeEdit)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#FF5858"]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

-(void)completeEdit
{
    
}
@end
