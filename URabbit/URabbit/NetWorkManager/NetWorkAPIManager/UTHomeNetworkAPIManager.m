//
//  UTHomeNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/19.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTHomeNetworkAPIManager.h"

@implementation UTHomeNetworkAPIManager
+(instancetype)shareManager
{
    static UTHomeNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTHomeNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)getNewTemplateWithPage:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@(page),@"page",@(size),@"size", nil];
    [[NetWorkRequestManager shareManager] get:UT_NewTemplate_API parameters:parameters callback:callback isNotify:NO];
}

-(void)getChoiceRecommendTemplateWithPage:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@(page),@"page",@(size),@"size", nil];
    [[NetWorkRequestManager shareManager] get:UT_ChoiceRecommend_API parameters:parameters callback:callback isNotify:NO];
}
@end
