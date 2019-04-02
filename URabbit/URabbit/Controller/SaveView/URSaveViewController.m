//
//  URSaveViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URSaveViewController.h"
#import "SavedTemplate.h"
#import "HomeTemplate.h"
#import "URDownloadTemplateViewController.h"
#import "WSLWaterFlowLayout.h"
#import "URSaveTemplateCollectionViewCell.h"
#import "URUserSaveNetworkAPIManager.h"
#import "UINavigationController+NavigationBar.h"
#import <MJRefresh/MJRefresh.h>

static NSString *savedTemplateCollectionViewCellIdentify = @"SavedTemplateCollectionViewCellIdentify";
@interface URSaveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WSLWaterFlowLayoutDelegate>
{
    UIView *navBackView;
    UICollectionView *collectionView;
    NSMutableArray *dataSource;
    NSInteger currentPage;
    NSInteger currentSize;
    BOOL hasMore;
}

@end

@implementation URSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#F8F8F8"]];
    currentPage = 1;
    currentSize = 20;
    hasMore = YES;
    dataSource = [NSMutableArray array];
    
    navBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [UIDevice safeAreaTopHeight])];
    [navBackView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navBackView];
    WSLWaterFlowLayout *layout = [[WSLWaterFlowLayout alloc] init];
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
    layout.delegate = self;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [collectionView registerClass:[URSaveTemplateCollectionViewCell class] forCellWithReuseIdentifier:savedTemplateCollectionViewCellIdentify];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:collectionView];
    [self makeConstraints];
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshPageData];
    }];
    
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestUserSavedTemplate];
    }];
    
    if (![collectionView.mj_header isRefreshing]) {
        [collectionView.mj_header beginRefreshing];
    }
}

-(void)makeConstraints
{
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navBackView.bottom).offset(6);
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
    [self.navigationItem setTitle:@"我的收藏"];
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

-(void)refreshPageData
{
    currentPage = 1;
    hasMore = YES;
    [collectionView.mj_footer resetNoMoreData];
    [self requestUserSavedTemplate];
}

-(void)endRefresh
{
    if ([collectionView.mj_header isRefreshing]) {
        [collectionView.mj_header endRefreshing];
    }
    
    if ([collectionView.mj_footer isRefreshing]) {
        if (hasMore) {
            [collectionView.mj_footer endRefreshing];
        }else{
            [collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        if (hasMore) {

        }else{
            [collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

-(void)requestUserSavedTemplate
{
    if (currentPage == 1) {
        if (dataSource.count > 0) {
            [dataSource removeAllObjects];
        }
    }
    [[URUserSaveNetworkAPIManager shareManager] requestUserSavedTemplateWithPage:currentPage size:currentSize callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (data) {
            NSArray *savedTemplateArray = (NSArray *)data;
            if (savedTemplateArray && savedTemplateArray.count > 0) {
                if (savedTemplateArray.count < currentSize) {
                    hasMore = NO;
                }
                for (NSDictionary *dic in savedTemplateArray) {
                    SavedTemplate *savedTemplate = [[SavedTemplate alloc] init];
                    savedTemplate.templateId = [[dic objectForKey:@"id"] longValue];
                    savedTemplate.title = [dic objectForKey:@"title"];
                    savedTemplate.coverUrl = [dic objectForKey:@"coverUrl"];
                    id width = [dic objectForKey:@"width"];
                    if (width) {
                        savedTemplate.videoWidth = [width floatValue];
                    }else{
                        savedTemplate.videoWidth = 544;
                    }
                    
                    id height = [dic objectForKey:@"height"];
                    if (height) {
                        savedTemplate.videoHeight = [height floatValue];
                    }else{
                        savedTemplate.videoHeight = 960;
                    }
                    savedTemplate.bg_tableName = SavedTemplateTableName;
                    [dataSource addObject:savedTemplate];
                }
                currentPage ++;
                [collectionView reloadData];
            }else{
                hasMore = NO;
            }
        }else{
            hasMore = NO;
        }
        [self endRefresh];
    }];
}

#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    SavedTemplate *savedTemplate = [dataSource objectAtIndex:indexPath.row];
    CGFloat width = (SCREEN_WIDTH - 45) / 2.0f;
    CGFloat height = width * (savedTemplate.videoHeight / savedTemplate.videoWidth) + 50;
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
    URSaveTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:savedTemplateCollectionViewCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SavedTemplate *savedTemplate = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithSavedTemplate:savedTemplate];
        });
    });
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SavedTemplate *savedTemplate = [dataSource objectAtIndex:indexPath.row];
    
    HomeTemplate *homeTemplate = [[HomeTemplate alloc] init];
    homeTemplate.templateId = savedTemplate.templateId;
    homeTemplate.title = savedTemplate.title;
    homeTemplate.videoSize = CGSizeMake(savedTemplate.videoWidth, savedTemplate.videoHeight);
    URDownloadTemplateViewController *downloadTemplateVC = [[URDownloadTemplateViewController alloc] initWithHomeTemplate:homeTemplate];
    [self.navigationController pushViewController:downloadTemplateVC animated:YES];
}
@end
