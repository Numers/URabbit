//
//  UTMemberCompositonViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTMemberCompositonViewController.h"
#import "UTMemberCompositonCollectionViewCell.h"
#import "Composition.h"
#import "LJJWaterFlowLayout.h"
#import "AppStartManager.h"

#import "UTMemberCompositionDetailsViewController.h"

static NSString *memberCompositionCollectionViewCellIdentify = @"MemberCompositionCollectionViewCellIdentify";
@interface UTMemberCompositonViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LJJWaterFlowLayoutProtocol>
{
    UICollectionView *collectionView;
    NSMutableArray *dataSource;
}
@end

@implementation UTMemberCompositonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#F8F8F8"]];
    Member *host = [[AppStartManager shareManager] currentMember];
    NSString *sqlStirng = nil;
    if (host) {
        sqlStirng = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"memberId"),bg_sqlValue(host.memberId)];
    }else{
        sqlStirng = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"memberId"),bg_sqlValue(NOUSERMemberID)];
    }
    NSArray *dataArray = [Composition bg_find:CompositionTableName where:sqlStirng];
    if (dataArray && dataArray.count > 0) {
        dataSource = [NSMutableArray arrayWithArray:dataArray];
    }else{
        dataSource = [NSMutableArray array];
    }
    LJJWaterFlowLayout *layout = [[LJJWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [collectionView registerClass:[UTMemberCompositonCollectionViewCell class] forCellWithReuseIdentifier:memberCompositionCollectionViewCellIdentify];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setScrollEnabled:NO];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setContentInset:UIEdgeInsetsMake(18, 0, 0, 0)];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:collectionView];
    
    [self makeConstraints];
}

-(void)makeConstraints
{
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"我的作品"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UICollectionViewDataSource | UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTMemberCompositonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:memberCompositionCollectionViewCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Composition *composition = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithCompositon:composition];
        });
    });
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(18, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Composition *compositon = [dataSource objectAtIndex:indexPath.row];
    CGFloat width = (SCREEN_WIDTH - 45) / 2.0f;
    CGFloat height = width * (compositon.videoHeight / compositon.videoWidth) + 50;
    return CGSizeMake(width,height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Composition *compositon = [dataSource objectAtIndex:indexPath.row];
    UTMemberCompositionDetailsViewController *memberCompositionDetailsVC = [[UTMemberCompositionDetailsViewController alloc] initWithComposition:compositon];
    [self.navigationController pushViewController:memberCompositionDetailsVC animated:YES];
    
}
@end
