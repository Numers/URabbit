//
//  UTCategoryPageViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2019/1/5.
//  Copyright © 2019年 鲍利成. All rights reserved.
//

#import "UTCategoryPageViewController.h"
#import "UTCategoryNetworkAPIManager.h"
#import "UTDownloadTemplateViewController.h"
#import "UTCategoryPageCollectionViewCell/UTCategoryPageCollectionViewCell.h"
#import "HomeTemplate.h"
#import <MJRefresh/MJRefresh.h>
static NSString *categoryCollectionViewCellIdentify = @"CategoryCollectionViewCellIdentify";
@interface UTCategoryPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    long currentCategoryId;
    UICollectionView *collectionView;
    NSMutableArray *dataSource;
    NSInteger currentPage;
    NSInteger currentSize;
    BOOL hasMore;
}
@end

@implementation UTCategoryPageViewController
-(instancetype)initWithCategoryId:(long)categoryId
{
    self = [super init];
    if (self) {
        currentCategoryId = categoryId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    currentPage = 1;
    currentSize = 20;
    hasMore = YES;
    dataSource = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.delegate = self;
//    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 110);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [collectionView registerClass:[UTCategoryPageCollectionViewCell class] forCellWithReuseIdentifier:categoryCollectionViewCellIdentify];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:collectionView];
    
    [self makeConstraints];
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshPageData];
    }];
    
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestHomeTemplate];
    }];
    
    if (![collectionView.mj_header isRefreshing]) {
        [collectionView.mj_header beginRefreshing];
    }
}

-(void)makeConstraints
{
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void)refreshPageData
{
    currentPage = 1;
    hasMore = YES;
    [collectionView.mj_footer resetNoMoreData];
    [self requestHomeTemplate];
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

-(void)requestHomeTemplate
{
    if (currentPage == 1) {
        if (dataSource.count > 0) {
            [dataSource removeAllObjects];
        }
    }

    [[UTCategoryNetworkAPIManager shareManager] getCategoryTemplateWithCategoryId:currentCategoryId Page:currentPage size:currentSize callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (data) {
            NSArray *templateArray = (NSArray *)data;
            if (templateArray && templateArray.count > 0) {
                if (templateArray.count < currentSize) {
                    hasMore = NO;
                }
                for (NSDictionary *dic in templateArray) {
                    HomeTemplate *template = [[HomeTemplate alloc] init];
                    template.templateId = [[dic objectForKey:@"id"] longValue];
                    template.title = [dic objectForKey:@"title"];
                    template.coverUrl = [dic objectForKey:@"coverUrl"];
                    template.videoSize = CGSizeMake(544, 960);
                    [dataSource addObject:template];
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
    UTCategoryPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCollectionViewCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HomeTemplate *template = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithHomeTemplate:template];
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
    HomeTemplate *template = [dataSource objectAtIndex:indexPath.row];
    CGFloat width = (SCREEN_WIDTH - 45) / 2.0f;
    CGFloat height = width * (template.videoSize.height / template.videoSize.width) + 50;
    return CGSizeMake(width,height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTemplate *homeTemplate = [dataSource objectAtIndex:indexPath.row];
    UTDownloadTemplateViewController *downloadTemplateVC = [[UTDownloadTemplateViewController alloc] initWithHomeTemplate:homeTemplate];
    [self.navigationController pushViewController:downloadTemplateVC animated:YES];
}

@end
