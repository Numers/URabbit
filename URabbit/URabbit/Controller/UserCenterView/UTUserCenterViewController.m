//
//  UTUserCenterViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/1.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTUserCenterViewController.h"
#import "UTUserCenterHeadView.h"
#import "UTUserCenterTableViewCell.h"
#import "Member.h"
#import "AppStartManager.h"
#import "UTMemberScrollViewController.h"
#import "UTMemberCoinViewController.h"
#import "UTMemberCompositonViewController.h"
#import "UTUserSettingViewController.h"
#import "UTShareViewController.h"
static NSString *userCenterTableViewCellIdentify = @"UserCenterTableViewCellIdentify";
@interface UTUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UTUserCenterHeadView *headView;
    Member *currentMember;
}
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation UTUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    currentMember = [[AppStartManager shareManager] currentMember];
    headView = [[UTUserCenterHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 184)];
    [headView setCurrentMember:currentMember];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UTUserCenterTableViewCell class] forCellReuseIdentifier:userCenterTableViewCellIdentify];
    [_tableView setTableHeaderView:headView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [_tableView setSectionHeaderHeight:8];
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
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"个人中心"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        case 0:
        {
            UTMemberScrollViewController *memeberScrollVC = [[UTMemberScrollViewController alloc] init];
            [memeberScrollVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:memeberScrollVC animated:YES];
        }
            break;
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UTMemberCoinViewController *memberCoinVC = [storyboard instantiateViewControllerWithIdentifier:@"UTMemberCoinViewIdentify"];
            [memberCoinVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:memberCoinVC animated:YES];
        }
            break;
        case 2:
        {
            UTMemberCompositonViewController *memberCompositionVC = [[UTMemberCompositonViewController alloc] init];
            [memberCompositionVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:memberCompositionVC animated:YES];
        }
            break;
        case 3:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UTShareViewController *shareVC = [storyboard instantiateViewControllerWithIdentifier:@"UTShareViewIdentify"];
            shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//            self.definesPresentationContext = YES;
            [self presentViewController:shareVC animated:YES completion:^{
                
            }];
        }
            break;
        case 4:
        {
            UTUserSettingViewController *userSettingVC = [[UTUserSettingViewController alloc] init];
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
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    UTUserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCenterTableViewCellIdentify forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            [cell setIcon:[UIImage imageNamed:@"huiyuanIconImage"] leftTitle:@"VIP会员" rightTitle:@"畅想专属特权" isShowBottomLine:YES];
            break;
        case 1:
            [cell setIcon:[UIImage imageNamed:@"jinbiIconImage"] leftTitle:@"我的金币" rightTitle:@"88金币" isShowBottomLine:YES];
            break;
        case 2:
            [cell setIcon:[UIImage imageNamed:@"zuopinIconImage"] leftTitle:@"作品合集" rightTitle:@"" isShowBottomLine:YES];
            break;
        case 3:
            [cell setIcon:[UIImage imageNamed:@"fenxiangIconImage"] leftTitle:@"分享好友" rightTitle:@"" isShowBottomLine:YES];
            break;
        case 4:
            [cell setIcon:[UIImage imageNamed:@"shezhiIconImage"] leftTitle:@"设置" rightTitle:@"" isShowBottomLine:NO];
            break;
        default:
            break;
    }
    return cell;
}
@end
