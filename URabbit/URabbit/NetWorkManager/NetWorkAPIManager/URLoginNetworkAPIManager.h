//
//  URLoginNetworkAPIManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface URLoginNetworkAPIManager : NSObject
+(instancetype)shareManager;
-(void)loginWithMobile:(NSString *)mobile checkCode:(NSString *)checkCode callback:(APIRequstCallBack)callback;
-(void)loginPlatformWithOid:(NSString *)oid type:(LoginPlatform)platfrom nickName:(NSString *)nickName portrait:(NSString *)portrait gender:(SexType)sex callback:(APIRequstCallBack)callback;
-(void)sendValidateCodeWithMobile:(NSString *)mobile callback:(APIRequstCallBack)callback;
-(void)checkValidateCodeWithMobile:(NSString *)mobile code:(NSString *)code callback:(APIRequstCallBack)callback;
@end
