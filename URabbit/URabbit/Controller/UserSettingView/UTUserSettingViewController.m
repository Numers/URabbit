//
//  UTUserSettingViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTUserSettingViewController.h"
#import "UTUserSettingTableViewCell.h"
#import "UTEditUserInfoViewController.h"
#import "UTAboutViewController.h"
#import "AppStartManager.h"
#import "LoadedTemplate.h"
#import "Composition.h"
#import "DraftTemplate.h"

static NSString *userSettingTableViewCellIdentify = @"UserSettingTableViewCellIdentify";
@interface UTUserSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation UTUserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSectionHeaderHeight:6];
    [_tableView setSectionFooterHeight:0.01];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[UTUserSettingTableViewCell class] forCellReuseIdentifier:userSettingTableViewCellIdentify];
    [self.view addSubview:_tableView];
    [self makeConstaints];
}

-(void)makeConstaints
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"设置"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginoutWithIndexPath:(NSIndexPath *)indexPath
{
//    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[AppStartManager shareManager] setMember:nil];
    [[AppStartManager shareManager] removeLocalHostMemberData];
    [_tableView reloadData];
}

-(void)deleteCache
{
    [AppUtils showLoadingInView:self.view];
    NSString * cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [AppUtils deleteFolderFilesAtPath:cacheDir];
    [LoadedTemplate bg_clear:LoadedTableName];
    [Composition bg_clear:CompositionTableName];
    [DraftTemplate bg_clear:DraftTemplateTableName];
    [AppUtils hiddenLoadingInView:self.view];
    [_tableView reloadData];
}

#pragma -mark UITableViewDelegate|UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
//                case 0:
//                {
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    UTEditUserInfoViewController *editUserInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"UTEditUserInfoViewIdentify"];
//                    [self.navigationController pushViewController:editUserInfoVC animated:YES];
//                }
//                    break;
                case 0:
                {
                    [self deleteCache];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    
                    break;
                case 1:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UTAboutViewController *aboutVC = [storyboard instantiateViewControllerWithIdentifier:@"UTAboutViewIdentify"];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                    break;
                case 2:
                    
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self loginoutWithIndexPath:indexPath];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numbers = 0;
    switch (section) {
        case 0:
            numbers = 1;
            break;
        case 1:
            numbers = 3;
            break;
        case 2:
        {
            Member *host = [[AppStartManager shareManager] currentMember];
            if (host) {
                numbers = 1;
            }else{
                numbers = 0;
            }
        }
            break;
        default:
            break;
    }
    return numbers;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    UTUserSettingTableViewCell *cell = nil;
    if (indexPath.section == 2) {
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:userSettingTableViewCellIdentify forIndexPath:indexPath];
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
//                case 0:
//                    [cell setLeftTitle:@"个人信息" rightTitle:@"" isShowBottomLine:YES];
//                    break;
//                case 0:
//                    [cell setLeftTitle:@"账号绑定" rightTitle:@"" isShowBottomLine:YES];
//                    break;
                case 0:{
                    NSString * cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    float size = [AppUtils folderSizeAtPath:cacheDir];
                    [cell setLeftTitle:@"清理缓存" rightTitle:[NSString stringWithFormat:@"%.2fM",size] isShowBottomLine:NO];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    [cell setLeftTitle:@"相关条款" rightTitle:@"" isShowBottomLine:YES];
                    break;
                case 1:
                    [cell setLeftTitle:@"关于我们" rightTitle:@"" isShowBottomLine:YES];
                    break;
                case 2:
                    [cell setLeftTitle:@"帮助中心" rightTitle:@"" isShowBottomLine:NO];
                    break;
//                case 3:
//                    [cell setLeftTitle:@"问题与反馈" rightTitle:@"" isShowBottomLine:YES];
//                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UITableViewCell *loginoutCell = [[UITableViewCell alloc] init];
                    [loginoutCell.textLabel setText:@"退出登录"];
                    [loginoutCell.textLabel setTextAlignment:NSTextAlignmentCenter];
                    [loginoutCell.textLabel setFont:[UIFont systemFontOfSize:16]];
                    [loginoutCell.textLabel setTextColor:[UIColor colorFromHexString:@"#FF5858"]];
                    return loginoutCell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

@end
