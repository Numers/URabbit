//
//  URDownloadNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URDownloadNetworkAPIManager.h"

@implementation URDownloadNetworkAPIManager
+(instancetype)shareManager
{
    static URDownloadNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[URDownloadNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)requestTemplateDetailsWithTemplateId:(long)templateId callback:(APIRequstCallBack)callback
{
    NSString *uri = [UT_TemplateDetails_API stringByReplacingOccurrencesOfString:@"{id}" withString:[NSString stringWithFormat:@"%ld",templateId]];
    [[NetWorkRequestManager shareManager] get:uri parameters:nil callback:callback isNotify:YES];
}
@end
