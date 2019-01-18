//
//  UTUserDownloadedViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTUserDownloadedViewController.h"
#import "UTUserDownloadedCollectionViewCell.h"
#import "LoadedTemplate.h"
#import "WSLWaterFlowLayout.h"
#import "AppStartManager.h"
#import "UINavigationController+NavigationBar.h"
#import "UTDownloadTemplateViewController.h"
#import "HomeTemplate.h"

static NSString *userDownloadedCollectionViewCellIdentify = @"UserDownloadedCollectionViewCellIdentify";
@interface UTUserDownloadedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WSLWaterFlowLayoutDelegate>
{
    UICollectionView *collectionView;
    NSMutableArray *dataSource;
}
@end

@implementation UTUserDownloadedViewController

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
    NSArray *dataArray = [LoadedTemplate bg_find:LoadedTableName where:sqlStirng];
    if (dataArray && dataArray.count > 0) {
        dataSource = [NSMutableArray arrayWithArray:dataArray];
    }else{
        dataSource = [NSMutableArray array];
    }
    WSLWaterFlowLayout *layout = [[WSLWaterFlowLayout alloc] init];
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
    layout.delegate = self;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [collectionView registerClass:[UTUserDownloadedCollectionViewCell class] forCellWithReuseIdentifier:userDownloadedCollectionViewCellIdentify];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:collectionView];
    
    [self makeConstraints];
}

-(void)makeConstraints
{
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-[UIDevice safeAreaBottomHeight]);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setNavigationViewColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"我的下载"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationViewColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    LoadedTemplate *loadedTemplate = [dataSource objectAtIndex:indexPath.row];
    CGFloat width = (SCREEN_WIDTH - 45) / 2.0f;
    CGFloat height = width * (loadedTemplate.videoHeight / loadedTemplate.videoWidth) + 50;
    return CGSizeMake(width,height);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeZero;
}
/** 脚视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
    return CGSizeZero;
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 2;
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 15;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 0;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(18, 15, 0, 15);
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
    UTUserDownloadedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userDownloadedCollectionViewCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LoadedTemplate *loadedTemplate = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithLoadedTemplate:loadedTemplate];
        });
    });
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LoadedTemplate *loadedTemplate = [dataSource objectAtIndex:indexPath.row];
    HomeTemplate *homeTemplate = [[HomeTemplate alloc] init];
    homeTemplate.templateId = loadedTemplate.templateId;
    homeTemplate.title = loadedTemplate.title;
    homeTemplate.videoSize = CGSizeMake(loadedTemplate.videoWidth, loadedTemplate.videoHeight);
    UTDownloadTemplateViewController *downloadTemplateVC = [[UTDownloadTemplateViewController alloc] initWithHomeTemplate:homeTemplate];
    [self.navigationController pushViewController:downloadTemplateVC animated:YES];
}

@end
