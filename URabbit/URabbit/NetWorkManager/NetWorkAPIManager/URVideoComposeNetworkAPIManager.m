//
//  URVideoComposeNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URVideoComposeNetworkAPIManager.h"

@implementation URVideoComposeNetworkAPIManager
+(instancetype)shareManager
{
    static URVideoComposeNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[URVideoComposeNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)requestRecommendMusicWithTemplateId:(long)templateId Callback:(APIRequstCallBack)callback
{
    NSString *uri = [UT_RecommendMusicList_API stringByReplacingOccurrencesOfString:@"{templetId}" withString:[NSString stringWithFormat:@"%ld",templateId]];
    [[NetWorkRequestManager shareManager] get:uri parameters:nil callback:callback isNotify:NO];
}
@end
