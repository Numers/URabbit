//
//  URUserCenterViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/1.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URUserCenterViewController.h"
#import "URUserCenterHeadView.h"
#import "URUserCenterTableViewCell.h"
#import "Member.h"
#import "AppStartManager.h"
//#import "URMemberScrollViewController.h"
#import "URMemberCompositonViewController.h"
#import "URUserSettingViewController.h"
#import "URShareViewController.h"
#import "URUserDownloadedViewController.h"
#import "URSaveViewController.h"
#import "URLoginScrollViewController.h"
#import "UINavigationController+NavigationBar.h"
#import "URUMShareManager.h"
#import "GeneralManager.h"
static NSString *userCenterTableViewCellIdentify = @"UserCenterTableViewCellIdentify";
@interface URUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,URUserCenterHeadViewProtocol,UTShareViewProtocol>
{
    URUserCenterHeadView *headView;
    Member *currentMember;
}
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation URUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    headView = [[URUserCenterHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 184)];
    headView.delegate = self;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor colorFromHexString:@"#F8F8F8"]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[URUserCenterTableViewCell class] forCellReuseIdentifier:userCenterTableViewCellIdentify];
    [_tableView setTableHeaderView:headView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
//    [_tableView setSectionHeaderHeight:8];
    //设置layoutMargins(iOS8之后)
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [_tableView setTableFooterView:[UIView new]];

    [self.view addSubview:_tableView];
    
    [self makeConstraints];
}

-(void)makeConstraints
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController setNavigationViewColor:[UIColor colorFromHexString:@"#FFDE44"]];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationItem setTitle:@"个人中心"];
    
    currentMember = [[AppStartManager shareManager] currentMember];
    [headView setCurrentMember:currentMember];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareToScence:(UMSocialPlatformType)scence
{
    [[GeneralManager defaultManager] shareConfig:^(NSDictionary *config) {
        if (config) {
            NSString *shareTitle = [config objectForKey:@"shareTitle"];
            NSString *shareSummery = [config objectForKey:@"shareSummery"];
            NSString *shareThumbnail = [config objectForKey:@"shareThumbnail"];
            NSData *shareThumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareThumbnail]];
            NSString *shareUrl = [config objectForKey:@"shareUrl"];
            [[URUMShareManager shareManager] shareWebPageToPlatformType:scence title:shareTitle description:shareSummery thumImage:shareThumbData webpageUrl:shareUrl callback:^(id response) {
                
            }];
        }
    }];
    
}

#pragma -mark UITableViewDelegate|UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
//        case 0:
//        {
//            URMemberScrollViewController *memeberScrollVC = [[URMemberScrollViewController alloc] init];
//            [memeberScrollVC setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:memeberScrollVC animated:YES];
//        }
//            break;
//        case 1:
//        {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            URMemberCoinViewController *memberCoinVC = [storyboard instantiateViewControllerWithIdentifier:@"UTMemberCoinViewIdentify"];
//            [memberCoinVC setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:memberCoinVC animated:YES];
//        }
//            break;
        case 0:
        {
            URMemberCompositonViewController *memberCompositionVC = [[URMemberCompositonViewController alloc] init];
            [memberCompositionVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:memberCompositionVC animated:YES];
        }
            break;
        case 1:
        {
            URShareViewController *shareVC = [[URShareViewController alloc] init];
            shareVC.delegate = self;
            [self presentViewController:shareVC animated:YES completion:^{
                
            }];
        }
            break;
        case 2:
        {
            URUserSettingViewController *userSettingVC = [[URUserSettingViewController alloc] init];
            [userSettingVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:userSettingVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    URUserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCenterTableViewCellIdentify forIndexPath:indexPath];
    switch (indexPath.row) {
//        case 0:
//            [cell setIcon:[UIImage imageNamed:@"huiyuanIconImage"] leftTitle:@"VIP会员" rightTitle:@"畅想专属特权" isShowBottomLine:YES];
//            break;
//        case 1:
//            [cell setIcon:[UIImage imageNamed:@"jinbiIconImage"] leftTitle:@"我的金币" rightTitle:@"88金币" isShowBottomLine:YES];
//            break;
        case 0:
            [cell setIcon:[UIImage imageNamed:@"zuopinIconImage"] leftTitle:@"作品合集" rightTitle:@"" isShowBottomLine:YES];
            break;
        case 1:
            [cell setIcon:[UIImage imageNamed:@"fenxiangIconImage"] leftTitle:@"分享好友" rightTitle:@"" isShowBottomLine:YES];
            break;
        case 2:
            [cell setIcon:[UIImage imageNamed:@"shezhiIconImage"] leftTitle:@"设置" rightTitle:@"" isShowBottomLine:NO];
            break;
        default:
            break;
    }
    return cell;
}

#pragma -mark URUserCenterHeadViewProtocol
-(void)gotoLoadedView
{
    URUserDownloadedViewController *userDownloadedVC = [[URUserDownloadedViewController alloc] init];
    [userDownloadedVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:userDownloadedVC animated:YES];
}

-(void)gotoSaveView
{
    URSaveViewController *saveVC = [[URSaveViewController alloc] init];
    [saveVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:saveVC animated:YES];
}

-(void)gotoLoginView
{
    URLoginScrollViewController *loginScrollVC = [[URLoginScrollViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginScrollVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma -mark UTShareViewProtocol
-(void)sendShareToWeixin
{
    [self shareToScence:UMSocialPlatformType_WechatSession];
}

-(void)sendShareToFriend
{
    [self shareToScence:UMSocialPlatformType_WechatTimeLine];
}

-(void)sendShareToQQ
{
    [self shareToScence:UMSocialPlatformType_QQ];
}

-(void)sendShareToWeibo
{
    [self shareToScence:UMSocialPlatformType_Sina];
}
@end
