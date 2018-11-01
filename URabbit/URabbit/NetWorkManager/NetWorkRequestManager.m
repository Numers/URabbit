//
//  NetWorkRequestManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/15.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "NetWorkRequestManager.h"
#import "AppStartManager.h"
@implementation NetWorkRequestManager
+(instancetype)shareManager
{
    static NetWorkRequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[NetWorkRequestManager alloc] init];
        }
    });
    return manager;
}

-(NSDictionary *)analyzedResponse:(NSDictionary *)responseObject isNotify:(BOOL)isNotify
{
    if (responseObject) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSInteger c = [[responseObject objectForKey:@"code"] integerValue];
        [result setObject:@(c) forKey:@"status"];
        if (c == 200) {
            id dataDic = [responseObject objectForKey:@"data"];
            if (dataDic) {
                [result setObject:dataDic forKey:@"data"];
            }
        }else if(c == 401){
            if (isNotify) {
                [AppUtils showInfo:[responseObject objectForKey:@"message"]];
            }
            [[AppStartManager shareManager] loginout];
        }else{
            id message = [responseObject objectForKey:@"message"];
            if (message) {
                [result setObject:message forKey:@"message"];
            }
            if (isNotify) {
                [AppUtils showInfo:[responseObject objectForKey:@"message"]];
            }
        }
        return result;
    }
    return nil;
}

-(NSDictionary *)analyzedSimplelyResponse:(NSDictionary *)responseObject isNotify:(BOOL)isNotify
{
    if (responseObject) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSInteger c = [[responseObject objectForKey:@"code"] integerValue];
        [result setObject:@(c) forKey:@"status"];
        if (c == 200) {
            id dataDic = [responseObject objectForKey:@"data"];
            if (dataDic) {
                [result setObject:dataDic forKey:@"data"];
            }
        }else{
            id message = [responseObject objectForKey:@"message"];
            if (message) {
                [result setObject:message forKey:@"message"];
            }
            if (isNotify) {
                [AppUtils showInfo:[responseObject objectForKey:@"message"]];
            }
        }
        return result;
    }
    return nil;
}


-(void)get:(NSString *)uri parameters:(id)parameters callback:(APIRequstCallBack)callback isNotify:(BOOL)isNotify
{

    [[NetWorkManager defaultManager] get:uri parameters:parameters success:^(NSNumber *statusCode,id responseObject) {
        NSDictionary *resultDic = [self analyzedResponse:responseObject isNotify:isNotify];
        if (resultDic) {
            id data = [resultDic objectForKey:@"data"];
            NSNumber *status = [resultDic objectForKey:@"status"];
            id errorMessage = [resultDic objectForKey:@"message"];
            callback(statusCode,status,data,errorMessage);
        }else{
            callback(statusCode,nil,nil,nil);
        }
    } failed:^(NSError *error) {
        if (isNotify) {
            [self alertWarning];
        }
        callback(nil,nil,nil,[error localizedDescription]);
    }];
}

-(void)getSync:(NSString *)uri parameters:(id)parameters callback:(APIRequstCallBack)callback isNotify:(BOOL)isNotify
{
    [[NetWorkManager defaultManager] getSync:uri parameters:parameters success:^(NSNumber *statusCode, id responseObject) {
        NSDictionary *resultDic = [self analyzedResponse:responseObject isNotify:isNotify];
        if (resultDic) {
            id data = [resultDic objectForKey:@"data"];
            NSNumber *status = [resultDic objectForKey:@"status"];
            id errorMessage = [resultDic objectForKey:@"message"];
            callback(statusCode,status,data,errorMessage);
        }else{
            callback(statusCode,nil,nil,nil);
        }
    } failed:^(NSError *error) {
        if (isNotify) {
            [self alertWarning];
        }
        callback(nil,nil,nil,[error localizedDescription]);
    }];
}

-(void)post:(NSString *)uri parameters:(id)parameters callback:(APIRequstCallBack)callback isNotify:(BOOL)isNotify
{
    [[NetWorkManager defaultManager] post:uri parameters:parameters success:^(NSNumber *statusCode,id responseObject) {
        NSDictionary *resultDic;
        if ([uri isEqualToString:UP_Login_API]) {
            resultDic = [self analyzedSimplelyResponse:responseObject isNotify:isNotify];
        }else{
            resultDic = [self analyzedResponse:responseObject isNotify:isNotify];
        }
        
        if (resultDic) {
            id data = [resultDic objectForKey:@"data"];
            NSNumber *status = [resultDic objectForKey:@"status"];
            id errorMessage = [resultDic objectForKey:@"message"];
            callback(statusCode,status,data,errorMessage);
        }else{
            callback(statusCode,nil,nil,nil);
        }
    }failed:^(NSError *error) {
        if (isNotify) {
            [self alertWarning];
        }
        callback(nil,nil,nil,[error localizedDescription]);
    }];
}

-(void)put:(NSString *)uri parameters:(id)parameters callback:(APIRequstCallBack)callback isNotify:(BOOL)isNotify
{
    [[NetWorkManager defaultManager] put:uri parameters:parameters success:^(NSNumber *statusCode,id responseObject) {
        NSDictionary *resultDic = [self analyzedResponse:responseObject isNotify:isNotify];
        if (resultDic) {
            id data = [resultDic objectForKey:@"data"];
            NSNumber *status = [resultDic objectForKey:@"status"];
            id errorMessage = [resultDic objectForKey:@"message"];
            callback(statusCode,status,data,errorMessage);
        }else{
            callback(statusCode,nil,nil,nil);
        }
    }failed:^(NSError *error) {
        if (isNotify) {
            [self alertWarning];
        }
        callback(nil,nil,nil,[error localizedDescription]);
    }];
}

-(void)uploadImage:(UIImage *)image uri:(NSString *)uri parameters:(id)parameters callback:(APIRequstCallBack)callback isNotify:(BOOL)isNotify
{
    [[NetWorkManager defaultManager] uploadImage:image uri:uri parameters:parameters success:^(NSNumber *statusCode,id responseObject) {
        NSDictionary *resultDic = [self analyzedResponse:responseObject isNotify:isNotify];
        if (resultDic) {
            id data = [resultDic objectForKey:@"data"];
            NSNumber *status = [resultDic objectForKey:@"status"];
            id errorMessage = [resultDic objectForKey:@"message"];
            callback(statusCode,status,data,errorMessage);
        }else{
            callback(statusCode,nil,nil,nil);
        }
    } failed:^(NSError *error) {
        if (isNotify) {
            [self alertWarning];
        }
        callback(nil,nil,nil,[error localizedDescription]);
    }];
}

-(void)alertWarning
{
    if (alertVC == nil) {
        alertVC = [UIAlertController alertControllerWithTitle:@"提 醒" message:@"网络不给力，请检查网络设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            alertVC = nil;
        }];
        [alertVC addAction:cancelAction];
        NSMutableAttributedString *str = [AppUtils generateAttriuteStringWithStr:@"\r\n网络不给力，请检查网络设置" WithColor:[UIColor blackColor] WithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        [alertVC setValue:str forKey:@"attributedMessage"];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:^{
            
        }];
    }
}
@end
