//
//  UTHomeViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTHomeViewController.h"
#import "UTHomeRecommendView.h"
#import "RecommendTemplate.h"

#import "UTHomeTemplateView.h"
#import "HomeTemplate.h"
#import "UTDownloadTemplateViewController.h"
#import "UTUserCenterViewController.h"
#import "UTCategoryViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "UTHomeNetworkAPIManager.h"
#import "AppStartManager.h"
#import "UINavigationController+NavigationBar.h"
#define HomeRecommendViewIdentify @"fenlei"
#define ChoosenTemplateViewIdentify @"jingxuan"
#define LatestTemplateViewIdentify @"latest"
@interface UTHomeViewController ()<HomeTemplateViewProtocol,UTHomeRecommendViewProtocl>
{
    UTHomeRecommendView *homeRecommendView;
    NSMutableArray *recommendList;
    
    UTHomeTemplateView *choosenTemplateView;
    NSMutableArray *choosenTemplateList;
    
    UTHomeTemplateView *latestTemplateView;
    NSMutableArray *latestTemplateList;
    
    CGFloat recommendViewHeight;
    CGFloat choosenTemplateViewHeight;
    CGFloat latestTemplateViewHeight;
}
@property(nonatomic, strong)  UIView *searchBarBackgroundView;
//@property(nonatomic, strong)  UISearchBar *searchBar;
//@property(nonatomic, strong)  UIButton *filterButton;
@property(nonatomic, strong) UIImageView *userCenterImageView;
@property(nonatomic, strong) UIButton *userCenterButton;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong)  UIView *topLineView;

@property(nonatomic, strong) UIScrollView *scrollView;;
@end

@implementation UTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundColor];
    recommendList = [NSMutableArray array];
    choosenTemplateList = [NSMutableArray array];
    latestTemplateList = [NSMutableArray array];
//    recommendViewHeight = 167.0f;
    recommendViewHeight = -8.0f;
    choosenTemplateViewHeight = 0.0f;
    latestTemplateViewHeight = 0.0f;
    
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
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
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
    
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setBackgroundColor:[UIColor colorFromHexString:@"#F0F1F3"]];
    [self.view addSubview:_scrollView];
    
    homeRecommendView = [[UTHomeRecommendView alloc] initWithFrame:CGRectMake(0, recommendViewHeight, SCREEN_WIDTH, recommendViewHeight)];
    [homeRecommendView setHidden:YES];
    homeRecommendView.delegate = self;
    [homeRecommendView setHeadImage:[UIImage imageNamed:@"jingxuan"] headTitle:@"推荐合集"];
    [_scrollView addSubview:homeRecommendView];
    
    choosenTemplateView = [[UTHomeTemplateView alloc] initWithFrame:CGRectMake(0, recommendViewHeight + 8, SCREEN_WIDTH, choosenTemplateViewHeight)];
    choosenTemplateView.delegate = self;
    [choosenTemplateView setHeadImage:[UIImage imageNamed:@"jingxuan"] headTitle:@"精选模板" viewIdentify:ChoosenTemplateViewIdentify];
    [_scrollView addSubview:choosenTemplateView];
    
    latestTemplateView = [[UTHomeTemplateView alloc] initWithFrame:CGRectMake(0, recommendViewHeight + 8 + choosenTemplateViewHeight + 8, SCREEN_WIDTH, latestTemplateViewHeight)];
    latestTemplateView.delegate = self;
    [latestTemplateView setHeadImage:[UIImage imageNamed:@"jingxuan"] headTitle:@"最新模板" viewIdentify:LatestTemplateViewIdentify];
    [_scrollView addSubview:latestTemplateView];
    
    [self addConstraints];
    [self setScrollViewContentSize];
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [self requestData];
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
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLineView.bottom);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-[UIDevice safeAreaBottomHeight]);
    }];
}

-(void)setScrollViewContentSize
{
    CGFloat height = recommendViewHeight;
    if (choosenTemplateViewHeight > 0) {
        [choosenTemplateView setHidden:NO];
        height += choosenTemplateViewHeight + 8;
    }else{
        [choosenTemplateView setHidden:YES];
    }
    
    if (latestTemplateViewHeight > 0) {
        [latestTemplateView setHidden:NO];
        height += latestTemplateViewHeight + 8;
    }else{
        [latestTemplateView setHidden:YES];
    }
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, height)];
}

-(void)requestData
{
    [AppUtils showLoadingInView:self.view];
    [self requestWithRecommendList];
    [self requestChoosenTemplateList];
    [self requestLatestTemplateList];
}

-(void)endRefresh
{
    if ([_scrollView.mj_header isRefreshing]) {
        [_scrollView.mj_header endRefreshing];
    }
}

-(void)requestWithRecommendList
{
    if (recommendList.count > 0) {
        [recommendList removeAllObjects];
    }
    [[UTHomeNetworkAPIManager shareManager] getReccmmendTemplateCallback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        NSArray *templateArr = (NSArray *)data;
        if (templateArr && templateArr.count > 0) {
            for (NSDictionary *dic in templateArr) {
                RecommendTemplate *template = [[RecommendTemplate alloc] initWithDictionary:dic];
                [recommendList addObject:template];
            }
            [homeRecommendView setDatasource:recommendList];
            if (recommendList.count > 0) {
                [homeRecommendView setHidden:NO];
                [self updateViewHeight:167.0f identify:HomeRecommendViewIdentify];
            }else{
                [homeRecommendView setHidden:YES];
                [self updateViewHeight:-8.0f identify:HomeRecommendViewIdentify];
            }
        }
    }];
}

-(void)requestChoosenTemplateList
{
    if (choosenTemplateList.count > 0) {
        [choosenTemplateList removeAllObjects];
    }
    
    [[UTHomeNetworkAPIManager shareManager] getChoiceRecommendTemplateWithPage:1 size:50 callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        NSArray *templateArr = (NSArray *)data;
        if (templateArr && templateArr.count > 0) {
            for (NSDictionary *dic in templateArr) {
                HomeTemplate *template = [[HomeTemplate alloc] initWithDictionary:dic];
                if (template.duration > 0) {
                    [choosenTemplateList addObject:template];
                }
            }
            [choosenTemplateView setDatasource:choosenTemplateList];
        }
    }];
}

-(void)requestLatestTemplateList
{
    if (latestTemplateList.count > 0) {
        [latestTemplateList removeAllObjects];
    }
    
    [[UTHomeNetworkAPIManager shareManager] getNewTemplateWithPage:1 size:50 callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        [AppUtils hiddenLoadingInView:self.view];
        NSArray *templateArr = (NSArray *)data;
        if (templateArr && templateArr.count > 0) {
            for (NSDictionary *dic in templateArr) {
                HomeTemplate *template = [[HomeTemplate alloc] initWithDictionary:dic];
                if (template.duration > 0) {
                    [latestTemplateList addObject:template];
                }
            }
            [latestTemplateView setDatasource:latestTemplateList];
        }
        [self endRefresh];
    }];
}

#pragma -mark IBAction
-(void)clickUserCenterButton
{
    UTUserCenterViewController *userCenterVC = [[UTUserCenterViewController alloc] init];
    [self.navigationController pushViewController:userCenterVC animated:YES];
}
#pragma -mark HomeTemplateViewProtocol
-(void)updateViewHeight:(CGFloat)height identify:(id)identify
{
    if ([HomeRecommendViewIdentify isEqualToString:identify]) {
        recommendViewHeight = height;
    }
    
    if ([ChoosenTemplateViewIdentify isEqualToString:identify]) {
        choosenTemplateViewHeight = height;
    }
    
    if ([LatestTemplateViewIdentify isEqualToString:identify]) {
        latestTemplateViewHeight = height;
    }
    
    if (recommendViewHeight > 0) {
        if (homeRecommendView) {
            [homeRecommendView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, recommendViewHeight)];
            [homeRecommendView setNeedsUpdateConstraints];
        }
    }
    
    if (choosenTemplateViewHeight > 0) {
        if (choosenTemplateView) {
            [choosenTemplateView setFrame:CGRectMake(0, recommendViewHeight + 8, SCREEN_WIDTH, choosenTemplateViewHeight)];
            [choosenTemplateView setNeedsUpdateConstraints];
        }
    }
    
    if (latestTemplateViewHeight > 0) {
        if (latestTemplateView) {
            [latestTemplateView setFrame:CGRectMake(0, recommendViewHeight + 8 + choosenTemplateViewHeight + 8, SCREEN_WIDTH, latestTemplateViewHeight)];
            [latestTemplateView setNeedsUpdateConstraints];
        }
    }
    [self setScrollViewContentSize];
}

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
    UTCategoryViewController *categoryVC = [[UTCategoryViewController alloc] initWithItems:recommendList selectIndex:index];
    [self.navigationController pushViewController:categoryVC animated:YES];
}
@end
