//
//  UTUserVipNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTUserVipNetworkAPIManager.h"

@implementation UTUserVipNetworkAPIManager
+(instancetype)shareManager
{
    static UTUserVipNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTUserVipNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)requestVIPPriceCallback:(APIRequstCallBack)callback
{
    [[NetWorkRequestManager shareManager] get:UT_VIPPriceList_API parameters:nil callback:callback isNotify:YES];
}

-(void)requestBuyVipBillInfoWithPriceId:(NSInteger)priceId channel:(PayType)type callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@(priceId),@"priceId",@(type),@"channel", nil];
    [[NetWorkRequestManager shareManager] post:UT_VIPBuy_API parameters:parameters callback:callback isNotify:YES];
}
@end
