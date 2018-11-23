//
//  UTMemberCoinViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTMemberCoinViewController.h"

@interface UTMemberCoinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UILabel *leftCoinLabel;
@end

@implementation UTMemberCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    [_leftCoinLabel setAttributedText:[self generateCoinStringWithLeftCoin:188]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"我的金币"];
    [self navigationBarSetting];
}

-(void)navigationBarSetting
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBill)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#999999"]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoBill
{
    
}

-(NSMutableAttributedString *)generateCoinStringWithLeftCoin:(NSInteger)leftCoin
{
    NSMutableAttributedString *tempString = [AppUtils generateAttriuteStringWithStr:@"金币余额：" WithColor:[UIColor colorFromHexString:@"#333333"] WithFont:[UIFont systemFontOfSize:16]];
    NSAttributedString *leftCoinString = [AppUtils generateAttriuteStringWithStr:[NSString stringWithFormat:@"%ld",leftCoin] WithColor:[UIColor colorFromHexString:@"#FF5858"] WithFont:[UIFont systemFontOfSize:16]];
    [tempString appendAttributedString:leftCoinString];
    return tempString;
}
#pragma -mark UITableViewDelegate|UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCoinTableViewCellIdentify" forIndexPath:indexPath];
    
    return cell;
}

@end
