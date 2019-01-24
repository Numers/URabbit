//
//  AppStartManager.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface AppStartManager : NSObject
{
    Member *host;
    NSString *deviceToken; //设备唯一标示
    NSString *networkStatus; // 网络类型
    NSString *deviceModel; //设备类型
}
@property(nonatomic, strong) UINavigationController *navigationController;
@property(nonatomic, strong) UITabBarController *tabBarController;

+(instancetype)shareManager;


/**
 返回当前登录的用户

 @return 登录用户
 */
-(Member *)currentMember;


/**
 设置记录当前登录的用户

 @param member 登录用户
 */
-(void)setMember:(Member *)member;

-(void)removeLocalHostMemberData;
/**
 push到home界面
 */
-(void)pushHomeView;


/**
 返回当前navigationController的最上面的ViewController

 @return ViewController
 */
-(UIViewController *)topViewController;


/**
 app启动时处理事件
 */
-(void)startApp;


/**
 app退出登录时处理事件
 */
-(void)loginout;


/**
 上报信息

 @return 上报信息字典
 */
-(NSDictionary *)trackDictionaryWithPageNO:(NSString *)pageNo eventNo:(NSString *)eventNo parameters:(NSDictionary *)parameters;
@end
