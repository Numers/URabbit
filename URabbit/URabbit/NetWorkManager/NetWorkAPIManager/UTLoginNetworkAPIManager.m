//
//  UTLoginNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTLoginNetworkAPIManager.h"

@implementation UTLoginNetworkAPIManager
+(instancetype)shareManager
{
    static UTLoginNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTLoginNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)loginWithMobile:(NSString *)mobile checkCode:(NSString *)checkCode callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",checkCode,@"checkcode", nil];
    [[NetWorkRequestManager shareManager] post:UT_Login_API parameters:parameters callback:callback isNotify:YES];
}

-(void)sendValidateCodeWithMobile:(NSString *)mobile callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile", nil];
    [[NetWorkRequestManager shareManager] post:UT_ValidateCode_API parameters:parameters callback:callback isNotify:YES];
}

-(void)checkValidateCodeWithMobile:(NSString *)mobile code:(NSString *)code callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",code,@"checkcode", nil];
    [[NetWorkRequestManager shareManager] post:UT_ValidateCheck_API parameters:parameters callback:callback isNotify:YES];
}
@end
