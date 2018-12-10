//
//  UTMemberScrollViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/23.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTMemberScrollViewController.h"
#import "UTMemberViewController.h"
#import "AppStartManager.h"
#import "VIPPrice.h"
#import "UTUserVipNetworkAPIManager.h"
#import "UTLoginScrollViewController.h"
#import "UINavigationController+NavigationBar.h"
#import "UIButton+Gradient.h"
@interface UTMemberScrollViewController ()<MemberViewProtocol>
{
    UTMemberViewController *memberVC;
    Member *currentHost;
    BOOL isPushIn;
}
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIButton *agreeButton;
@property(nonatomic, strong) UIButton *openMemberButton;
@end

@implementation UTMemberScrollViewController
-(instancetype)init
{
    self = [super init];
    if (self) {
        isPushIn = YES;
    }
    return self;
}

-(instancetype)initWithTransitionMethod:(BOOL)isPush
{
    self = [super init];
    if (self) {
        isPushIn = isPush;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_scrollView];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    memberVC = [storyboard instantiateViewControllerWithIdentifier:@"UTMemberViewIdentify"];
    memberVC.delegate = self;
    [_scrollView addSubview:memberVC.view];
    
    _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeButton addTarget:self action:@selector(clickAgreeButton) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *protocolTitle = [AppUtils generateAttriuteStringWithStr:@"《购买协议》" WithColor:[UIColor colorFromHexString:@"#003F00"] WithFont:[UIFont systemFontOfSize:11]];
    NSMutableAttributedString *title = [AppUtils generateAttriuteStringWithStr:@"选择开通VIP会员即同意" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:11]];
    [title appendAttributedString:protocolTitle];
    [_agreeButton setAttributedTitle:title forState:UIControlStateNormal];
    [self.view addSubview:_agreeButton];
    
    [_openMemberButton setTitleColor:[UIColor colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    
    _openMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_openMemberButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - 30, 44) colorArray:@[[UIColor colorFromHexString:@"#FED546"],[UIColor colorFromHexString:@"#FEBD43"]] percentageArray:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
    [_openMemberButton.layer setCornerRadius:22.0f];
    [_openMemberButton.layer setMasksToBounds:YES];
    [_openMemberButton addTarget:self action:@selector(clickOpenMemeberButton) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *openTitle = [AppUtils generateAttriuteStringWithStr:@"开通VIP会员" WithColor:[UIColor colorFromHexString:@"#333333"] WithFont:[UIFont systemFontOfSize:16]];
    [_openMemberButton setAttributedTitle:openTitle forState:UIControlStateNormal];
    [self.view addSubview:_openMemberButton];
    [self makeConstraints];
}

-(void)makeConstraints
{
    [_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-33);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(@(190));
        make.height.equalTo(@(16));
    }];
    
    [_openMemberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_agreeButton.top).offset(-15);
        make.height.equalTo(@(44));
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"开通会员"];
    currentHost = [[AppStartManager shareManager] currentMember];
    [memberVC setCurrentMember:currentHost];
    if (!isPushIn) {
        [self navigationBarSetting];
    }
}

-(void)navigationBarSetting
{
    [self.navigationController setNavigationViewColor:[UIColor whiteColor]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closeImage"] style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickAgreeButton
{
    
}

-(void)clickOpenMemeberButton
{
    VIPPrice *price = [memberVC selectedVipPrice];
    if (currentHost) {
        [[UTUserVipNetworkAPIManager shareManager] requestBuyVipBillInfoWithPriceId:price.priceId channel:WechatPay callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
            
        }];
    }else{
        [_scrollView setContentOffset:CGPointZero animated:NO];
        [self presentLoginView];
    }
}

#pragma -mark MemberViewProtocol
-(void)returnContentSizeHeight:(CGFloat)height
{
    [memberVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, height + (SCREEN_HEIGHT -_openMemberButton.frame.origin.y) + 10)];
}

-(void)presentLoginView
{
    UTLoginScrollViewController *loginScrollVC = [[UTLoginScrollViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginScrollVC];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
