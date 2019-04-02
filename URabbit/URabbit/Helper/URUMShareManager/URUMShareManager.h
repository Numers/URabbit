//
//  URUMShareManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/27.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#define WeixinShareServiceType @"com.tencent.xin.sharetimeline"
#define WeiboShareServiceType @"com.sina.weibo.ShareExtension"
#define QQShareServiceType @"com.tencent.mqq.ShareExtension"
@interface URUMShareManager : NSObject
+(instancetype)shareManager;
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType complete:(void (^)(UMSocialUserInfoResponse *result))callback;

- (void)shareVideoToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title description:(NSString *)desc thumImage:(UIImage *)image videoUrl:(NSString *)videoUrl callback:(void (^)(id response))callback;

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title description:(NSString *)desc thumImage:(id)image webpageUrl:(NSString *)webpageUrl callback:(void (^)(id response))callback;

-(void)indirectShareVideo:(NSURL *)url;
@end
