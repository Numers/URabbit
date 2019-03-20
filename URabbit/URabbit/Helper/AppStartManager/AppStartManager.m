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
#import "URCategoryViewController.h"
#import "UTVideoComposeViewController.h"
#import "UTUserCenterViewController.h"
#import "UTGuidViewController.h"
#import "UTLoginScrollViewController.h"
#import "XFCameraController.h"
#import "UINavigationController+NavigationBar.h"
#import "LLTabBar.h"

#import "DraftTemplate.h"
#import "Composition.h"
#import "Resource.h"
#import "UTVideoManager.h"

#import <SAMKeychain/SAMKeychain.h>

#define DeviceTokenService @"com.ut.deviceTokenService"
#define DeviceTokenAccount @"com.ut.deviceTokenAccount"
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

-(NSString *)getDeviceToken
{
    if (deviceToken == nil) {
        NSString *token = [SAMKeychain passwordForService:DeviceTokenService account:DeviceTokenAccount];
        if (token == nil) {
            token = [AppUtils getUUID];
            [SAMKeychain setPassword:token forService:DeviceTokenService account:DeviceTokenAccount];
        }
        deviceToken = token;
    }
    return deviceToken;
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
                networkStatus = @"Unknow";
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
//                [AppUtils showInfo:@"网络正在开小差"];
                networkStatus = @"NoReachable";
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                networkStatus = @"mobile";
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                networkStatus = @"wifi";
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:@"#737373"])]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:@"#737373"])]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-CGFLOAT_MAX, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[GeneralManager defaultManager] getGlovalVarWithVersion];
    [self currentMember];
    if (host) {
        NSString *autoLogin = [AppUtils localUserDefaultsForKey:KMY_AutoLogin];
        if ([autoLogin isEqualToString:@"1"]) {
            [self setHomeView];
        }else{
            [self setHomeView];
        }
    }else{
        [self setHomeView];
    }
    
    [AppUtils trackMTAEventNo:@"1" pageNo:@"1" parameters:nil];
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
    
    URCategoryViewController *categoryVC = [[URCategoryViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:categoryVC];
//    [self setNavigationColor:nav1];
    
    UTUserCenterViewController *userCenterVC = [[UTUserCenterViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
//    [self setNavigationColor:nav2];
    [nav2.navigationBar setBackIndicatorImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:@"#737373"])]];
    [nav2.navigationBar setBackIndicatorTransitionMaskImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e621", IconfontGoBackDefaultSize, [UIColor colorFromHexString:@"#737373"])]];
    
    [_tabBarController setViewControllers:@[nav1,nav2]];
    LLTabBar *tabBar = [[LLTabBar alloc] initWithFrame:_tabBarController.tabBar.bounds];
    tabBar.tabBarItemAttributes = @[@{kLLTabBarItemAttributeTitle:@"首页",kLLTabBarItemAttributeNormalImageName:@"tabbar_home_normal",kLLTabBarItemAttributeSelectedImageName:@"tabbar_home_select",kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},@{kLLTabBarItemAttributeTitle:@"",kLLTabBarItemAttributeNormalImageName:@"tabbar_camera_normal",kLLTabBarItemAttributeSelectedImageName:@"tabbar_camera_select",kLLTabBarItemAttributeType : @(LLTabBarItemRise)},@{kLLTabBarItemAttributeTitle:@"我的",kLLTabBarItemAttributeNormalImageName:@"tabbar_usercenter_normal",kLLTabBarItemAttributeSelectedImageName:@"tabbar_usercenter_select",kLLTabBarItemAttributeType : @(LLTabBarItemNormal)}];
//    tabBar.tabBarItemAttributes = @[@{kLLTabBarItemAttributeTitle:@"首页",kLLTabBarItemAttributeNormalImageName:@"tabbar_home_normal",kLLTabBarItemAttributeSelectedImageName:@"tabbar_home_select",kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},@{kLLTabBarItemAttributeTitle:@"我的",kLLTabBarItemAttributeNormalImageName:@"tabbar_usercenter_normal",kLLTabBarItemAttributeSelectedImageName:@"tabbar_usercenter_select",kLLTabBarItemAttributeType : @(LLTabBarItemNormal)}];
    tabBar.delegate = self;
    [_tabBarController.tabBar addSubview:tabBar];
    [_tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
    
//    UITabBar *tabBar = _tabBarController.tabBar;
//    [tabBar setTranslucent:NO];
//    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
//    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#999999"]} forState:UIControlStateNormal];
//    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#FFDE44"]} forState:UIControlStateSelected];
//    [item1 setImage:[[UIImage imageNamed:@"tabbar_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item1 setSelectedImage:[[UIImage imageNamed:@"tabbar_home_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    item1.title = @"首页";
//    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
//    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#999999"]} forState:UIControlStateNormal];
//    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#FFDE44"]} forState:UIControlStateSelected];
//    [item2 setImage:[[UIImage imageNamed:@"tabbar_usercenter_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item2 setSelectedImage:[[UIImage imageNamed:@"tabbar_usercenter_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    item2.title = @"我的";
}

#pragma -mark protocol LLTabBarDelegate
- (void)tabBarDidSelectedRiseButton {
    return;
    XFCameraController *cameraController = [XFCameraController defaultCameraController];
    
    __weak XFCameraController *weakCameraController = cameraController;
    
    cameraController.takePhotosCompletionBlock = ^(UIImage *image, NSError *error) {
        NSLog(@"takePhotosCompletionBlock");
        
        [weakCameraController dismissViewControllerAnimated:YES completion:nil];
    };
    
    cameraController.shootCompletionBlock = ^(NSURL *videoUrl, CGFloat videoTimeLength,NSURL *audioUrl, UIImage *thumbnailImage, NSError *error) {
        NSLog(@"shootCompletionBlock");
        DraftTemplate *draftTemplate = [[DraftTemplate alloc] init];
        draftTemplate.memberId = host.memberId == nil ? NOUSERMemberID : host.memberId;
        draftTemplate.templateId = 1000000;
        draftTemplate.title = @"自制视频";
        draftTemplate.coverUrl = nil;
        draftTemplate.videoWidth = SCREEN_WIDTH;
        draftTemplate.videoHeight = SCREEN_HEIGHT;
        draftTemplate.duration = videoTimeLength;
        draftTemplate.summary = @"";
        draftTemplate.bg_tableName = DraftTemplateTableName;
        draftTemplate.movieUrl = [videoUrl absoluteString];
        draftTemplate.resourceFps = [[UTVideoManager shareManager] getFpsWithVideoPath:draftTemplate.movieUrl];
        draftTemplate.resourceMusic = [audioUrl absoluteString];
        
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
        
        [weakCameraController dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UTVideoComposeViewController *videoComposeVC = [[UTVideoComposeViewController alloc] initWithResource:resource movieUrl:draftTemplate.movieUrl composition:composition draftTemplate:draftTemplate isFromDraft:YES];
                [videoComposeVC setHidesBottomBarWhenPushed:YES];
                UINavigationController *selectNav = [_tabBarController selectedViewController];
                [selectNav pushViewController:videoComposeVC animated:YES];
            });
        }];
    };
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:cameraController animated:YES completion:nil];
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
    [self setNavigationColor:_navigationController];
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
}

-(NSDictionary *)trackDictionaryWithPageNO:(NSString *)pageNo eventNo:(NSString *)eventNo parameters:(NSDictionary *)parameters
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (parameters) {
        [dic setValuesForKeysWithDictionary:parameters];
    }
    [dic setObject:[NSString stringWithFormat:@"\"%@\"",pageNo] forKey:@"pageNo"];
    [dic setObject:[NSString stringWithFormat:@"\"%@\"",eventNo] forKey:@"eventNo"];
    [dic setObject:[self getDeviceToken] forKey:@"deviceToken"];
    if (host) {
        [dic setObject:[NSString stringWithFormat:@"\"%@\"",host.memberId] forKey:@"userid"];
    }else{
        [dic setObject:@"\"0\"" forKey:@"userid"];
    }
    
    if (deviceModel == nil) {
        deviceModel = [UIDevice deviceModel];
    }
    
    if (deviceModel) {
        [dic setObject:deviceModel forKey:@"model"];
    }
    
    [dic setObject:@"iphone" forKey:@"brand"];
    [dic setObject:@"IOS" forKey:@"OS"];
    [dic setObject:[NSString stringWithFormat:@"V%@",[AppUtils appVersion]] forKey:@"appVersion"];
    if (networkStatus) {
        [dic setObject:networkStatus forKey:@"networkStatus"];
    }

    return dic;
}
@end
