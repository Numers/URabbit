//
//  URLManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "URLManager.h"
static URLManager *manager;
@implementation URLManager
+(id)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[URLManager alloc] init];
        }
    });
    return manager;
}

-(NSString *)returnBaseUrl
{
    return BaseURL;
}

-(void)setUrlWithState:(BOOL)state
{
    if (state) {
        BaseURL = @"http://47.97.126.151:8080/urabbit-core";
    }else{
        BaseURL = @"http://47.97.126.151:8080/urabbit-core";
    }
}
@end
