//
//  URMemberViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/23.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URMemberViewController.h"
#import "URMemberTableViewCell.h"
#import "VIPPrice.h"
#import "Member.h"
#import "URUserVipNetworkAPIManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
static NSString *memberTableViewCellIdentify = @"MemberTableViewCellIdentify";
@interface URMemberViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *datasource;
    NSInteger selectedRow;
    VIPPrice *selectPrice;
    
    UIImageView *vipMarkImageView;
}
@property(nonatomic, strong) IBOutlet UIView *headBackView;
@property(nonatomic, strong) IBOutlet UIImageView *headImageView;
@property(nonatomic, strong) IBOutlet UILabel *nickNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *isMemeberLabel;
@property(nonatomic, strong) IBOutlet UIButton *noLoginButton;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property(nonatomic, strong) IBOutlet UIView *backView;

@end

@implementation URMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    datasource = [NSMutableArray array];
    selectedRow = 0;
    
    [_headImageView.layer setCornerRadius:27.5];
    [_headImageView.layer setMasksToBounds:YES];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_tableView registerClass:[URMemberTableViewCell class] forCellReuseIdentifier:memberTableViewCellIdentify];
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self requestVIPPriceList];
}

-(void)requestVIPPriceList
{
    if (datasource.count > 0) {
        [datasource removeAllObjects];
    }
    
    [[URUserVipNetworkAPIManager shareManager] requestVIPPriceCallback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (data) {
            NSArray *dataArr = (NSArray *)data;
            for (NSDictionary *dic in dataArr) {
                VIPPrice *price = [[VIPPrice alloc] initWithDictionary:dic];
                [datasource addObject:price];
            }
            [_tableView reloadData];
        }
        _tableViewHeightConstraint.constant = 75 * datasource.count;
        if (datasource.count > 0) {
            
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            selectPrice = [datasource objectAtIndex:0];
        }
        
        if ([self.delegate respondsToSelector:@selector(returnContentSizeHeight:)]) {
            [self.delegate returnContentSizeHeight:[self returnMemberContentHeight]];
        }
    }];
}

-(void)setCurrentMember:(Member *)member
{
    if (member) {
        [_noLoginButton setHidden:YES];
        [_nickNameLabel setHidden:NO];
        [_isMemeberLabel setHidden:NO];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:member.headIcon] placeholderImage:[UIImage imageNamed:@"headIconImage"]];
        [_nickNameLabel setText:member.nickName];
        [_nickNameLabel sizeToFit];
        
        if (vipMarkImageView) {
            [vipMarkImageView removeFromSuperview];
            vipMarkImageView = nil;
        }
    
        if ([member isVip]) {
            NSString *expireTime = [AppUtils getDateFormatterFromTime:member.vipExpire formatter:@"yyyy-MM-dd"];
            [_isMemeberLabel setText:[NSString stringWithFormat:@"已开通VIP会员 有效期至%@",expireTime]];
            
            UIImage *vipMarkImage = [UIImage imageNamed:@"VipMarkImage"];
            vipMarkImageView = [[UIImageView alloc] initWithImage:vipMarkImage];
            [vipMarkImageView setCenter:CGPointMake(_nickNameLabel.frame.origin.x + _nickNameLabel.frame.size.width + 7 + vipMarkImage.size.width / 2.0f, _nickNameLabel.center.y)];
            [_backView addSubview:vipMarkImageView];
        }else{
            [_isMemeberLabel setText:@"未开通VIP会员"];
        }
    }else{
        [_noLoginButton setHidden:NO];
        [_nickNameLabel setHidden:YES];
        [_isMemeberLabel setHidden:YES];
        [_headImageView setImage:[UIImage imageNamed:@"headIconImage"]];
    }
}

-(CGFloat)returnMemberContentHeight
{
    return _backView.frame.origin.y + 247 + datasource.count * 75;
}

-(VIPPrice *)selectedVipPrice
{
    return selectPrice;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickNoLoginBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(presentLoginView)]) {
        [self.delegate presentLoginView];
    }
}
#pragma -mark UITableViewDelegate | UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectPrice = [datasource objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datasource.count;
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
    URMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:memberTableViewCellIdentify forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (selectedRow == indexPath.row) {
        [cell setIsSelect:YES];
    }else{
        [cell setIsSelect:NO];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        VIPPrice *price = [datasource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithVipPrice:price];
        });
    });
    return cell;
}
@end
