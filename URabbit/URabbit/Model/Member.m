//
//  Member.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "Member.h"

@implementation Member
/**
 字典初始化对象
 
 @param dic 用户信息字典
 @return 用户对象
 */
-(instancetype)initWithDictionary:(NSDictionary *)dic;
{
    self = [super init];
    if (self) {
        if (dic) {
            self.memberId = [dic objectForKey:@"memberId"];
            self.name = [dic objectForKey:@"name"];
            self.loginName = [dic objectForKey:@"loginName"];
            self.password = [dic objectForKey:@"password"];
            self.ip = [dic objectForKey:@"ip"];
            self.token = [dic objectForKey:@"token"];
            self.headIcon = [dic objectForKey:@"headIcon"];
            self.source = [dic objectForKey:@"source"];
            self.time = [[dic objectForKey:@"time"] doubleValue];
            self.role = (Role)[[dic objectForKey:@"role"] integerValue];
            self.userInfo = dic;
        }
    }
    return self;
}


/**
 将用户对象转义成字典
 
 @return 用户信息字典
 */
-(NSDictionary *)dictionaryInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_memberId) {
        [dic setObject:_memberId forKey:@"memberId"];
    }
    
    if (_name) {
        [dic setObject:_name forKey:@"name"];
    }
    
    if (_loginName) {
        [dic setObject:_loginName forKey:@"loginName"];
    }
    
    if (_password) {
        [dic setObject:_password forKey:@"password"];
    }
    
    if (_headIcon) {
        [dic setObject:_headIcon forKey:@"headIcon"];
    }
    
    if (_token) {
        [dic setObject:_token forKey:@"token"];
    }
    
    if (_ip) {
        [dic setObject:_ip forKey:@"ip"];
    }
    
    if (_source) {
        [dic setObject:_source forKey:@"source"];
    }
    
    [dic setObject:@(_time) forKey:@"time"];
    [dic setObject:@(_role) forKey:@"role"];
    
    if (_userInfo) {
        [dic setObject:_userInfo forKey:@"userInfo"];
    }
    return dic;
}
@end
