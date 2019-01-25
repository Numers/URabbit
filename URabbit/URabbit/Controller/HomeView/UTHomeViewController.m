//
//  UTHomeViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTHomeViewController.h"
#import "UTHomeRecommendView.h"
#import "UTHomeCollectionFootReusableView.h"
#import "RecommendTemplate.h"

#import "WSLWaterFlowLayout.h"
#import "UTHomeCollectionViewCell.h"
#import "HomeTemplate.h"
#import "UTDownloadTemplateViewController.h"
#import "UTUserCenterViewController.h"
#import "UTCategoryViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "UTHomeNetworkAPIManager.h"
#import "AppStartManager.h"
#import "UINavigationController+NavigationBar.h"

NSString *homeTemplateCollectionViewCellIdentify = @"HomeTemplateCollectionViewCellIdentify";
NSString *homeTemplateCollectionHeadViewIdentify = @"HomeTemplateCollectionHeadViewIdentify";
NSString *homeTemplateCollectionFootViewIdentify = @"HomeTemplateCollectionFootViewIdentify";
@interface UTHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate,UTHomeRecommendViewProtocl>
{
    UTHomeRecommendView *homeRecommendView;
    NSMutableArray *recommendList;
    
    NSMutableArray *choosenTemplateList;
    
    NSInteger currentPage;
    NSInteger currentSize;
    BOOL hasMore;
}
@property(nonatomic, strong)  UIView *searchBarBackgroundView;
//@property(nonatomic, strong)  UISearchBar *searchBar;
//@property(nonatomic, strong)  UIButton *filterButton;
@property(nonatomic, strong) UIImageView *userCenterImageView;
@property(nonatomic, strong) UIButton *userCenterButton;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong)  UIView *topLineView;

@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation UTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundColor];
    currentPage = 1;
    currentSize = 10;
    hasMore = YES;
    recommendList = [NSMutableArray array];
    choosenTemplateList = [NSMutableArray array];
    
    _topLineView = [[UIView alloc] init];
    [_topLineView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_topLineView];
//    _searchBarBackgroundView = [[UIView alloc] init];
//    [_searchBarBackgroundView setBackgroundColor:[UIColor colorFromHexString:@"#F0F1F3"]];
//    [_searchBarBackgroundView.layer setCornerRadius:16.0f];
//    [_searchBarBackgroundView.layer setMasksToBounds:YES];
//    [self.view addSubview:_searchBarBackgroundView];
    _userCenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userCenterButton addTarget:self action:@selector(clickUserCenterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userCenterButton];
    
    _userCenterImageView = [[UIImageView alloc] init];
    [_userCenterImageView.layer setCornerRadius:16];
    [_userCenterImageView.layer setMasksToBounds:YES];
    [self.view insertSubview:_userCenterImageView belowSubview:_userCenterButton];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setText:@"有兔"];
    [_titleLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
    [_titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_titleLabel setTextAlignment: NSTextAlignmentCenter];
    [self.view addSubview:_titleLabel];
    
//    _searchBar = [[UISearchBar alloc] init];
//    UIView *searchTextFieldView = [[[self.searchBar.subviews firstObject] subviews] lastObject];
//    [searchTextFieldView setBackgroundColor:[UIColor clearColor]];
//    [_searchBar setBackgroundImage:[AppUtils imageWithColor:[UIColor clearColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [_searchBar setImage:[UIImage imageNamed:@"sousou"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [_searchBar setPlaceholder:@"关键词搜索"];
//    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
//    [searchField setBackgroundColor:[UIColor clearColor]];
//    [searchField setValue:[UIColor colorFromHexString:@"#AEAEAE"] forKeyPath:@"_placeholderLabel.textColor"];
//    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
//    _searchBar.tintColor = [UIColor colorFromHexString:@"#333333"];
//    // 输入文本颜色
//    searchField.textColor = [UIColor colorFromHexString:@"#333333"];
//    searchField.font = [UIFont systemFontOfSize:13.0f];
//    [_searchBarBackgroundView addSubview:_searchBar];
    
//    _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_filterButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
//    NSAttributedString *filterTitle = [AppUtils generateAttriuteStringWithStr:@"筛选" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:13.0f]];
//    [_filterButton setAttributedTitle:filterTitle forState:UIControlStateNormal];
//    [self.view addSubview:_filterButton];
//
//    _filterButton.imageEdgeInsets = UIEdgeInsetsMake(0, _filterButton.frame.size.width - _filterButton.imageView.frame.origin.x - _filterButton.imageView.frame.size.width-5, 0, 0);
//    _filterButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(_filterButton.frame.size.width - _filterButton.imageView.frame.size.width ), 0, 0);
    
    WSLWaterFlowLayout *layout = [[WSLWaterFlowLayout alloc] init];
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[UTHomeCollectionViewCell class] forCellWithReuseIdentifier:homeTemplateCollectionViewCellIdentify];
    [_collectionView registerClass:[UTHomeRecommendView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:homeTemplateCollectionHeadViewIdentify];
    [_collectionView registerClass:[UTHomeCollectionFootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeTemplateCollectionFootViewIdentify];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_collectionView];
    
    [self addConstraints];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshPageData];
    }];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestChoosenTemplateList];
    }];
    if (![_collectionView.mj_header isRefreshing]) {
        [_collectionView.mj_header beginRefreshing];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleDefault];
    Member *host = [[AppStartManager shareManager] currentMember];
    if (host) {
        [_userCenterImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_userCenterImageView sd_setImageWithURL:[NSURL URLWithString:host.headIcon]  placeholderImage:[UIImage imageNamed:@"tabbar_usercenter_normal"]];
    }else{
        [_userCenterImageView setContentMode:UIViewContentModeCenter];
        [_userCenterImageView setImage:[UIImage imageNamed:@"tabbar_usercenter_normal"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addConstraints
{
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@(0.5));
        make.top.equalTo(self.view).offset([UIDevice safeAreaTopHeight]);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topLineView.top).offset(-6);
        make.height.equalTo(@(32));
        make.centerX.equalTo(self.view.centerX);
    }];
    
    [_userCenterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(0);
        make.width.equalTo(@(49));
        make.height.equalTo(@(32));
        make.centerY.equalTo(_titleLabel.mas_centerY);
    }];
    
    [_userCenterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.width.equalTo(@(32));
        make.height.equalTo(@(32));
        make.centerY.equalTo(_titleLabel.mas_centerY);
    }];
    
//    [_filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.view);
//        make.width.equalTo(@(69));
//        make.height.equalTo(@(32));
//        make.bottom.equalTo(_topLineView.top).offset(-6);
//    }];
//
//    [_searchBarBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(_filterButton.leading);
//        make.bottom.equalTo(_topLineView.top).offset(-6);
//        make.width.equalTo(@([UIDevice adaptWidthWithIphone6Width:265.0f]));
//        make.height.equalTo(@(32.0f));
//    }];
//
//    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_searchBarBackgroundView.top);
//        make.leading.equalTo(_searchBarBackgroundView.leading);
//        make.trailing.equalTo(_searchBarBackgroundView.trailing);
//        make.bottom.equalTo(_searchBarBackgroundView.bottom);
//    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLineView.bottom);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void)requestData
{
    if (currentPage == 1) {
        [AppUtils showGIFHudProgress:@"" forView:self.view];
        [self requestWithRecommendList];
    }
    [self requestChoosenTemplateList];
//    [self requestLatestTemplateList];
}

-(void)refreshPageData
{
    currentPage = 1;
    hasMore = YES;
    [_collectionView.mj_footer resetNoMoreData];
    [self requestData];
}

-(void)endRefresh
{
    if ([_collectionView.mj_header isRefreshing]) {
        [_collectionView.mj_header endRefreshing];
    }
    
    if ([_collectionView.mj_footer isRefreshing]) {
        if (hasMore) {
            [_collectionView.mj_footer endRefreshing];
        }else{
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        if (hasMore) {
            
        }else{
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

-(void)requestWithRecommendList
{
    if (recommendList.count > 0) {
        return;
    }
    [[UTHomeNetworkAPIManager shareManager] getReccmmendTemplateCallback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        NSArray *templateArr = (NSArray *)data;
        if (templateArr && templateArr.count > 0) {
            for (NSDictionary *dic in templateArr) {
                RecommendTemplate *template = [[RecommendTemplate alloc] initWithDictionary:dic];
                [recommendList addObject:template];
            }
            
            if (recommendList.count > 0) {
                [_collectionView reloadData];
            }
        }
    }];
}

-(void)requestChoosenTemplateList
{
    if (currentPage == 1) {
        if (choosenTemplateList.count > 0) {
            [choosenTemplateList removeAllObjects];
        }
    }
    
    [[UTHomeNetworkAPIManager shareManager] getChoiceRecommendTemplateWithPage:currentPage size:currentSize callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (currentPage == 1) {
            [AppUtils hiddenGIFHud:self.view];
        }
        NSArray *templateArr = (NSArray *)data;
        if (templateArr && templateArr.count > 0) {
            if (templateArr.count < currentSize) {
                hasMore = NO;
            }
            for (NSDictionary *dic in templateArr) {
                HomeTemplate *template = [[HomeTemplate alloc] initWithDictionary:dic];
                if (template.duration > 0) {
                    [choosenTemplateList addObject:template];
                }
            }
            currentPage ++;
            [_collectionView reloadData];
        }else{
            hasMore = NO;
        }
        [self endRefresh];
    }];
}

#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeTemplate *template = [choosenTemplateList objectAtIndex:indexPath.row];
    CGFloat width = (SCREEN_WIDTH - 45) / 2.0f;
    CGFloat ratio = template.videoSize.height / template.videoSize.width;
    CGFloat height = width * ratio + 50.0f;
    return CGSizeMake(width,height);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    if (recommendList.count > 0) {
        return CGSizeMake(SCREEN_WIDTH, 225);
    }
    return CGSizeZero;
}
/** 脚视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
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
    
    return UIEdgeInsetsMake(0, 15, 0, 15);
}


#pragma -mark UICollectionViewDataSource | UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return choosenTemplateList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UTHomeRecommendView *recommendView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:homeTemplateCollectionHeadViewIdentify forIndexPath:indexPath];
        if (recommendList.count > 0) {
            [recommendView setHidden:NO];
            recommendView.delegate = self;
            [recommendView setHeadImage:[UIImage imageNamed:@"jingxuan"] headTitle:@"推荐合集"];
            [recommendView setDatasource:recommendList];
        }else{
            [recommendView setHidden:YES];
        }
        return recommendView;
    }else{
        UTHomeCollectionFootReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeTemplateCollectionFootViewIdentify forIndexPath:indexPath];
        return footView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeTemplateCollectionViewCellIdentify forIndexPath:indexPath];
    [cell setNeedsDisplay];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HomeTemplate *template = [choosenTemplateList objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithHomeTemplate:template];
        });
    });
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTemplate *template = [choosenTemplateList objectAtIndex:indexPath.row];
    [AppUtils trackMTAEventNo:@"3" pageNo:@"2" parameters:@{@"templetId":[NSString stringWithFormat:@"%ld",template.templateId]}];
    [self selectHomeTemplate:template];
}

#pragma -mark IBAction
-(void)clickUserCenterButton
{
    UTUserCenterViewController *userCenterVC = [[UTUserCenterViewController alloc] init];
    [self.navigationController pushViewController:userCenterVC animated:YES];
}
#pragma -mark HomeTemplateViewProtocol
-(void)selectHomeTemplate:(HomeTemplate *)homeTemplate
{
    UTDownloadTemplateViewController *downloadTemplateVC = [[UTDownloadTemplateViewController alloc] initWithHomeTemplate:homeTemplate];
    [downloadTemplateVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:downloadTemplateVC animated:YES];
}

-(void)gotoCategoryView
{
    UTCategoryViewController *categoryVC = [[UTCategoryViewController alloc] initWithItems:recommendList selectIndex:0];
    [self.navigationController pushViewController:categoryVC animated:YES];
}

#pragma -mark UTHomeRecommendViewProtocl
-(void)gotoCategoryViewWithIndex:(NSInteger)index
{
    RecommendTemplate *recommend = [recommendList objectAtIndex:index];
    [AppUtils trackMTAEventNo:@"2" pageNo:@"1" parameters:@{@"categoryId":[NSString stringWithFormat:@"%ld",recommend.categoryId]}];
    UTCategoryViewController *categoryVC = [[UTCategoryViewController alloc] initWithItems:recommendList selectIndex:index];
    [self.navigationController pushViewController:categoryVC animated:YES];
}
@end
