//
//  UTUMShareManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/27.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
@interface UTUMShareManager : NSObject
+(instancetype)shareManager;
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType complete:(void (^)(UMSocialUserInfoResponse *result))callback;
@end
