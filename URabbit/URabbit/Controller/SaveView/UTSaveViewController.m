//
//  UTSaveViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTSaveViewController.h"
#import "SavedTemplate.h"
#import "HomeTemplate.h"
#import "UTDownloadTemplateViewController.h"
#import "LJJWaterFlowLayout.h"
#import "UTSaveTemplateCollectionViewCell.h"
#import "UTUserSaveNetworkAPIManager.h"
#import "UINavigationController+NavigationBar.h"
#import <MJRefresh/MJRefresh.h>

static NSString *savedTemplateCollectionViewCellIdentify = @"SavedTemplateCollectionViewCellIdentify";
@interface UTSaveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LJJWaterFlowLayoutProtocol>
{
    UICollectionView *collectionView;
    NSMutableArray *dataSource;
    NSInteger currentPage;
    NSInteger currentSize;
    BOOL hasMore;
}

@end

@implementation UTSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#F8F8F8"]];
    currentPage = 0;
    currentSize = 20;
    hasMore = YES;
    dataSource = [NSMutableArray array];
    LJJWaterFlowLayout *layout = [[LJJWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [collectionView registerClass:[UTSaveTemplateCollectionViewCell class] forCellWithReuseIdentifier:savedTemplateCollectionViewCellIdentify];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setContentInset:UIEdgeInsetsMake(18, 0, 0, 0)];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:collectionView];
    
    [self makeConstraints];
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshPageData];
    }];

    [self refreshPageData];
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
    [self.navigationController setNavigationViewColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"我的收藏"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshPageData
{
    currentPage = 0;
    hasMore = YES;
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestUserSavedTemplate];
    }];
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
    }
}

-(void)requestUserSavedTemplate
{
    if (currentPage == 0) {
        if (dataSource.count > 0) {
            [dataSource removeAllObjects];
        }
    }
    [[UTUserSaveNetworkAPIManager shareManager] requestUserSavedTemplateWithPage:currentPage size:currentSize callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
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
                    savedTemplate.videoWidth = 544;
                    savedTemplate.videoHeight = 960;
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
    UTSaveTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:savedTemplateCollectionViewCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SavedTemplate *savedTemplate = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithSavedTemplate:savedTemplate];
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
    SavedTemplate *savedTemplate = [dataSource objectAtIndex:indexPath.row];
    CGFloat width = (SCREEN_WIDTH - 45) / 2.0f;
    CGFloat height = width * (savedTemplate.videoHeight / savedTemplate.videoWidth) + 50;
    return CGSizeMake(width,height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SavedTemplate *savedTemplate = [dataSource objectAtIndex:indexPath.row];
    
    HomeTemplate *homeTemplate = [[HomeTemplate alloc] init];
    homeTemplate.templateId = savedTemplate.templateId;
    homeTemplate.title = savedTemplate.title;
    homeTemplate.videoSize = CGSizeMake(savedTemplate.videoWidth, savedTemplate.videoHeight);
    UTDownloadTemplateViewController *downloadTemplateVC = [[UTDownloadTemplateViewController alloc] initWithHomeTemplate:homeTemplate];
    [self.navigationController pushViewController:downloadTemplateVC animated:YES];
}
@end
