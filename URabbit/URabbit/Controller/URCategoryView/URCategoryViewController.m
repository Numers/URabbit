//
//  URCategoryViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2019/1/5.
//  Copyright © 2019年 鲍利成. All rights reserved.
//

#import "URCategoryViewController.h"
#import "RecommendTemplate.h"
#import "UINavigationController+NavigationBar.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "URCategoryPageViewController.h"
#import "URHomeNetworkAPIManager.h"
#import "GeneralManager.h"

@interface URCategoryViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>
{
    NSMutableArray *itemArray;
    NSInteger defaultSelectIndex;
    
    BOOL needRequestItems;
    
    BOOL isLoadData;
}
@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UIView *navBarView;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *navHeightConstraint;
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@end

@implementation URCategoryViewController
-(instancetype)initWithItems:(NSArray *)items selectIndex:(NSInteger)index
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"UTCategoryViewIdentify"];
    if (self) {
        needRequestItems = NO;
        itemArray = [NSMutableArray arrayWithArray:items];
        defaultSelectIndex = index;
    }
    return self;
}

-(instancetype)init
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"UTCategoryViewIdentify"];
    if (self) {
        needRequestItems = YES;
        itemArray = [NSMutableArray array];
        defaultSelectIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isLoadData = NO;
    [self.view setBackgroundColor:ViewBackgroundColor];
    [_backButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:@"#333333"])] forState:UIControlStateNormal];
    _navHeightConstraint.constant = [UIDevice safeAreaTopHeight];
    [self addTabPageBar];
    [self addPagerController];
    
    if (needRequestItems) {
        [_backButton setHidden:YES];
        [_titleLabel setText:@"有兔"];
        [_navBarView setBackgroundColor:[UIColor colorFromHexString:@"#FFDE44"]];
        [self beginMoniteNetwork];
    }else{
        [_titleLabel setText:@"全部模板"];
        [_backButton setHidden:NO];
        [self reloadData];
    }
}

- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    [tabBar setBackgroundColor:[UIColor whiteColor]];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
    tabBar.layout.normalTextColor = [UIColor blackColor];
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:17];
    tabBar.layout.selectedTextColor = [UIColor blackColor];
    tabBar.layout.progressColor = [UIColor colorFromHexString:@"#FFDE44"];
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, [UIDevice safeAreaTopHeight], CGRectGetWidth(self.view.frame), 36);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
}

-(void)beginMoniteNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != AFNetworkReachabilityStatusNotReachable) {
            [[GeneralManager defaultManager] shareConfig:^(NSDictionary *dic) {
                if (dic) {
                    [self requestWithRecommendList];
                }
            }];
        }
    }];
    [manager startMonitoring];
}

-(void)requestWithRecommendList
{
    if (itemArray.count > 0 || isLoadData) {
        return;
    }
    isLoadData = YES;
    [[URHomeNetworkAPIManager shareManager] getReccmmendTemplateCallback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        NSArray *templateArr = (NSArray *)data;
        if (templateArr && templateArr.count > 0) {
            if ([[GeneralManager defaultManager] isAuditSucess]) {
                for (NSDictionary *dic in templateArr) {
                    RecommendTemplate *template = [[RecommendTemplate alloc] initWithDictionary:dic];
                    [itemArray addObject:template];
                }
            }else{
                NSDictionary *dic = [templateArr objectAtIndex:0];
                RecommendTemplate *template = [[RecommendTemplate alloc] initWithDictionary:dic];
                template.name = @"全部模板";
                [itemArray addObject:template];
            }
        }
        [self reloadData];
        isLoadData = NO;
    }];
}

-(IBAction)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return itemArray.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    RecommendTemplate *template = [itemArray objectAtIndex:index];
    cell.titleLabel.text = template.name;
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    RecommendTemplate *template = [itemArray objectAtIndex:index];
    NSString *title = template.name;
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
    defaultSelectIndex = index;
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return itemArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    RecommendTemplate *template = [itemArray objectAtIndex:index];
    URCategoryPageViewController *pageVC = [[URCategoryPageViewController alloc] initWithCategoryId:template.categoryId];
    return pageVC;
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
//    [_tabBar scrollToItemFromIndex:0 toIndex:defaultSelectIndex animate:NO];
    [_pagerController scrollToControllerAtIndex:defaultSelectIndex animate:NO];
}
@end
