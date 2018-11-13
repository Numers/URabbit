//
//  AppStartManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "AppStartManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "AppDelegate.h"
#import "GeneralManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AppLaunchManager.h"
#import "PushMessageManager.h"
#import "UTHomeViewController.h"
#import "UTUserCenterViewController.h"
#import "UTGuidViewController.h"
#import "UTLoginScrollViewController.h"
#import "UINavigationController+NavigationBar.h"
#import "LLTabBar.h"


#define HostProfilePlist @"PersonProfile.plist"
@interface AppStartManager()<LLTabBarDelegate>
@end
@implementation AppStartManager
+(instancetype)shareManager
{
    static AppStartManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppStartManager alloc] init];
    });
    return manager;
}


/**
 返回当前登录的用户
 
 @return 登录用户
 */
-(Member *)currentMember
{
    if (host == nil) {
        host = [self getProfileFromPlist];
    }
    return host;
}

/**
 设置记录当前登录的用户
 
 @param member 登录用户
 */
-(void)setMember:(Member *)member
{
    if (member) {
        host = member;
        [self saveProfileToPlist];
    }
}


/**
 移除本地用户数据
 */
-(void)removeLocalHostMemberData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    host = nil;
}


/**
 将登录用户信息保存本地
 */
-(void)saveProfileToPlist
{
    NSDictionary *dic = [host dictionaryInfo];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    [dic writeToFile:selfInfoPath atomically:YES];
}


/**
 获取本地登录用户信息

 @return 在本地登录过的用户信息
 */
-(Member *)getProfileFromPlist
{
    Member *member = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:selfInfoPath];
        if (dic != nil) {
            member = [[Member alloc] initWithDictionary:dic];
        }
    }
    return member;
}

/**
 app启动时处理事件
 */
-(void)startApp
{
//    NSString *mediaType = AVMediaTypeVideo;
//    AVAuthorizationStatus authStatusVedio = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];

    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
//                [AppUtils showInfo:@"未知网络类型"];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
//                [AppUtils showInfo:@"网络正在开小差"];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:ThemeHexColor])]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:ThemeHexColor])]];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}forState:UIControlStateNormal];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[GeneralManager defaultManager] getGlovalVarWithVersion];
    [self currentMember];
    if (host) {
        NSString *autoLogin = [AppUtils localUserDefaultsForKey:KMY_AutoLogin];
        if ([autoLogin isEqualToString:@"1"]) {
            [self setHomeView];
        }else{
            [self setLoginView];
        }
    }else{
        [self setHomeView];
    }
}

-(void)setNavigationColor:(UINavigationController *)nav
{
    if (nav) {
        [nav setNavigationViewColor:[UIColor whiteColor]];
//        [_navigationController setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

/**
 返回当前navigationController的最上面的ViewController
 
 @return ViewController
 */
-(UIViewController *)topViewController
{
    return _navigationController?_navigationController.topViewController:nil;
}

-(void)generateTabBarController
{
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController.navigationItem setHidesBackButton:YES];
    
    UTHomeViewController *homeVC = [[UTHomeViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [nav1 setTranslucentView];
    
    UTUserCenterViewController *userCenterVC = [[UTUserCenterViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
    [self setNavigationColor:nav2];
    
    [_tabBarController setViewControllers:@[nav1,nav2]];
    LLTabBar *tabBar = [[LLTabBar alloc] initWithFrame:_tabBarController.tabBar.bounds];
    tabBar.tabBarItemAttributes = @[@{kLLTabBarItemAttributeTitle:@"首页",kLLTabBarItemAttributeNormalImageName:@"tabbar_home_normal",kLLTabBarItemAttributeSelectedImageName:@"tabbar_home_select",kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},@{kLLTabBarItemAttributeTitle:@"拍摄",kLLTabBarItemAttributeNormalImageName:@"tabbar_camera_normal",kLLTabBarItemAttributeSelectedImageName:@"tabbar_camera_select",kLLTabBarItemAttributeType : @(LLTabBarItemRise)},@{kLLTabBarItemAttributeTitle:@"我的",kLLTabBarItemAttributeNormalImageName:@"tabbar_usercenter_normal",kLLTabBarItemAttributeSelectedImageName:@"tabbar_usercenter_select",kLLTabBarItemAttributeType : @(LLTabBarItemNormal)}];
    tabBar.delegate = self;
    [_tabBarController.tabBar addSubview:tabBar];
}

#pragma -mark protocol LLTabBarDelegate
- (void)tabBarDidSelectedRiseButton {
    
}

-(id)currentTabbarController
{
    return _tabBarController;
}
///////////////////////////////////////////////////////
-(void)setHomeView
{
    [self generateTabBarController];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_tabBarController];
    [_navigationController setNavigationBarHidden:YES];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    [_tabBarController setSelectedIndex:0];
}

-(void)pushHomeView
{
    [self generateTabBarController];
    [_navigationController setNavigationBarHidden:YES];
    [_navigationController pushViewController:_tabBarController animated:YES];
    [_tabBarController setSelectedIndex:0];
}

-(void)setGuidView
{
    UTGuidViewController *guidVC = [[UTGuidViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:guidVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
}

-(void)setLoginView
{
    UTLoginScrollViewController *loginScrollVC = [[UTLoginScrollViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:loginScrollVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
    
}


/**
 app退出登录时处理事件
 */
-(void)loginout
{
    if (_navigationController) {
        [_navigationController popToRootViewControllerAnimated:NO];
        _navigationController = nil;
    }
    
    if (_tabBarController) {
        _tabBarController = nil;
    }
    [AppUtils localUserDefaultsValue:@"0" forKey:KMY_AutoLogin];
    [self setLoginView];
}
@end
