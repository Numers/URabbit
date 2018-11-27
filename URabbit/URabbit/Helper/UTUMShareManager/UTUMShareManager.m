//
//  UTUMShareManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/27.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTUMShareManager.h"

@implementation UTUMShareManager
+(instancetype)shareManager
{
    static UTUMShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTUMShareManager alloc] init];
    });
    return manager;
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType complete:(void (^)(UMSocialUserInfoResponse *result))callback
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialUserInfoResponse *resp = result;
            // 第三方登录数据(为空表示平台未提供)
            // 授权数据
            NSLog(@" uid: %@", resp.uid);
            NSLog(@" openid: %@", resp.openid);
            NSLog(@" accessToken: %@", resp.accessToken);
            NSLog(@" refreshToken: %@", resp.refreshToken);
            NSLog(@" expiration: %@", resp.expiration);
            // 用户数据
            NSLog(@" name: %@", resp.name);
            NSLog(@" iconurl: %@", resp.iconurl);
            NSLog(@" gender: %@", resp.unionGender);
            // 第三方平台SDK原始数据
            NSLog(@" originalResponse: %@", resp.originalResponse);
            callback(resp);
        }
        
    }];
}
@end
