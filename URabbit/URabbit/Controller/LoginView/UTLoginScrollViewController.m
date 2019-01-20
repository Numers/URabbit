//
//  UTLoginScrollViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTLoginScrollViewController.h"
#import "UTLoginViewController.h"
#import "UINavigationController+NavigationBar.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UTWebViewController.h"

@interface UTLoginScrollViewController ()<UTLoginViewProtocol>
{
    UTLoginViewController *loginVC;
    TPKeyboardAvoidingScrollView *scrollView;
}
@end

@implementation UTLoginScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundColor];
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginVC = [storyboard instantiateViewControllerWithIdentifier:@"UTLoginViewIdentify"];
    loginVC.delegate = self;
    [loginVC addTextFieldNotification];
    [scrollView addSubview:loginVC.view];
    [scrollView setContentSize:CGSizeMake(loginVC.view.frame.size.width, loginVC.view.frame.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetting];
}

-(void)navigationBarSetting
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"手机验证码登录"];
    [self.navigationController setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.navigationController setNavigationViewColor:[UIColor whiteColor]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closeImage"] style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseItem)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

-(void)clickCloseItem
{
    [loginVC removeTextFieldNotification];
    [loginVC stopTimer];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma -mark UTLoginViewProtocol
-(void)loginsuccess
{
    [self clickCloseItem];
}

-(void)gotoProtocolView
{
    UTWebViewController *webVC = [[UTWebViewController alloc] init];
    webVC.navTitle = @"隐私协议";
    webVC.loadUrl = @"https://www.utsdk.com/privacy.html";
    [self.navigationController pushViewController:webVC animated:YES];
}
@end
