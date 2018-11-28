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

- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title description:(NSString *)desc thumImage:(UIImage *)image videoUrl:(NSString *)videoUrl callback:(void (^)(id response))callback
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:desc thumImage:image];
    //设置视频网页播放地址
    shareObject.videoUrl = videoUrl;
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [AppUtils showInfo:[NSString stringWithFormat:@"分享失败,%@",error.description]];
        }else{
            NSLog(@"response data is %@",data);
            callback(data);
        }
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title description:(NSString *)desc thumImage:(UIImage *)image webpageUrl:(NSString *)webpageUrl callback:(void (^)(id response))callback
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:image];
    //设置网页地址
    shareObject.webpageUrl = webpageUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [AppUtils showInfo:[NSString stringWithFormat:@"分享失败,%@",error.description]];
        }else{
            NSLog(@"response data is %@",data);
            callback(data);
        }
    }];
}
@end
