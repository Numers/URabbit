//
//  UTUserVipNetworkAPIManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"
typedef enum{
    WechatPay = 1,
    Alipay = 2
}PayType;
@interface UTUserVipNetworkAPIManager : NSObject
+(instancetype)shareManager;
-(void)requestVIPPriceCallback:(APIRequstCallBack)callback;
-(void)requestBuyVipBillInfoWithPriceId:(NSInteger)priceId channel:(PayType)type callback:(APIRequstCallBack)callback;
@end
