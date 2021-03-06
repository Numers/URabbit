//
//  URHomeNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/19.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URHomeNetworkAPIManager.h"

@implementation URHomeNetworkAPIManager
+(instancetype)shareManager
{
    static URHomeNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[URHomeNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)getReccmmendTemplateCallback:(APIRequstCallBack)callback
{
    [[NetWorkRequestManager shareManager] get:UT_CategoryRecommend_API parameters:nil callback:callback isNotify:NO];
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
