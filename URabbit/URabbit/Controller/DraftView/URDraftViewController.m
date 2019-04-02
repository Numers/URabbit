//
//  URDraftViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/27.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URDraftViewController.h"
#import "URDraftCollectionViewCell.h"
#import "DraftTemplate.h"
#import "WSLWaterFlowLayout.h"
#import "AppStartManager.h"
#import "UINavigationController+NavigationBar.h"
#import "URVideoComposeViewController.h"
#import "Composition.h"
#import "Resource.h"

static NSString *draftCollectionViewCellIdentify = @"DraftCollectionViewCellIdentify";
@interface URDraftViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WSLWaterFlowLayoutDelegate>
{
    UICollectionView *collectionView;
    NSMutableArray *dataSource;
}

@end

@implementation URDraftViewController

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
    NSArray *dataArray = [DraftTemplate bg_find:DraftTemplateTableName where:sqlStirng];
    if (dataArray && dataArray.count > 0) {
        dataSource = [NSMutableArray arrayWithArray:dataArray];
    }else{
        dataSource = [NSMutableArray array];
    }
    WSLWaterFlowLayout *layout = [[WSLWaterFlowLayout alloc] init];
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
    layout.delegate = self;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [collectionView registerClass:[URDraftCollectionViewCell class] forCellWithReuseIdentifier:draftCollectionViewCellIdentify];
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
        make.bottom.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setNavigationViewColor:[UIColor colorFromHexString:@"#FFDE44"]];
    [self.navigationItem setTitle:@"我的草稿箱"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationViewColor:[UIColor colorFromHexString:@"#FFDE44"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    DraftTemplate *draftTemplate = [dataSource objectAtIndex:indexPath.row];
    CGFloat width = (SCREEN_WIDTH - 45) / 2.0f;
    CGFloat height = width * (draftTemplate.videoHeight / draftTemplate.videoWidth) + 50;
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
    URDraftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:draftCollectionViewCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DraftTemplate *draftTemplate = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithDraftTemplate:draftTemplate];
        });
    });
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DraftTemplate *draftTemplate = [dataSource objectAtIndex:indexPath.row];
    Composition *composition = [[Composition alloc] init];
    composition.memberId = draftTemplate.memberId;
    composition.templateId = draftTemplate.templateId;
    composition.title = draftTemplate.title;
    composition.coverUrl = draftTemplate.coverUrl;
    composition.videoWidth = draftTemplate.videoWidth;
    composition.videoHeight = draftTemplate.videoHeight;
    composition.duration = draftTemplate.duration;
    composition.summary = draftTemplate.summary;
    composition.bg_tableName = CompositionTableName;
    
    Resource *resource = [[Resource alloc] init];
    resource.music = draftTemplate.resourceMusic;
    resource.fps = draftTemplate.resourceFps;
    resource.videoSize = CGSizeMake(draftTemplate.videoWidth, draftTemplate.videoHeight);
    
    URVideoComposeViewController *videoComposeVC = [[URVideoComposeViewController alloc] initWithResource:resource movieUrl:draftTemplate.movieUrl composition:composition draftTemplate:draftTemplate isFromDraft:YES];
    [self.navigationController pushViewController:videoComposeVC animated:YES];
}

@end
