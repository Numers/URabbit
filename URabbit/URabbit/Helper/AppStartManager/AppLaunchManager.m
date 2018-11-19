//
//  AppLaunchManager.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/9.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "AppLaunchManager.h"
#import "NetWorkGlobalVar.h"

@implementation AppLaunchManager
+(instancetype)shareManager
{
    static AppLaunchManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppLaunchManager alloc] init];
    });
    return manager;
}

-(void)loginSync:(NSString *)loginName withPassword:(NSString *)password withSource:(NSString *)source callback:(void(^)(id data))callback
{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_BASE,UT_Login_API]];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:loginName,@"name",password,@"password",source,@"source", nil];
    
    if (params) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = data;
    }
    //第三步，连接服务器
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        callback(nil);
    }else{
        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        id result = [AppUtils objectWithJsonString:str1];
        callback(result);
    }
}
@end
