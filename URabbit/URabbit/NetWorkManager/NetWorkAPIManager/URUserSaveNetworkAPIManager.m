//
//  URUserSaveNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URUserSaveNetworkAPIManager.h"

@implementation URUserSaveNetworkAPIManager
+(instancetype)shareManager
{
    static URUserSaveNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[URUserSaveNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)requestUserSavedTemplateWithPage:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@(page),@"page",@(size),@"size", nil];
    [[NetWorkRequestManager shareManager] get:UT_UserSavedTemplate_API parameters:parameters callback:callback isNotify:YES];
}

-(void)saveTemplateWithTemplateId:(long)templateId callback:(APIRequstCallBack)callback
{
    NSString *uri = [UT_SaveTemplate_API stringByReplacingOccurrencesOfString:@"{id}" withString:[NSString stringWithFormat:@"%ld",templateId]];
    [[NetWorkRequestManager shareManager] put:uri parameters:nil callback:callback isNotify:YES];
}

-(void)deleteTemplateWithTemplateId:(long)templateId callback:(APIRequstCallBack)callback
{
    NSString *uri = [UT_CancelSaveTemplate_API stringByReplacingOccurrencesOfString:@"{id}" withString:[NSString stringWithFormat:@"%ld",templateId]];
    [[NetWorkRequestManager shareManager] put:uri parameters:nil callback:callback isNotify:YES];
}
@end
