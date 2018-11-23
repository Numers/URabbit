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
            self.memberId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
            self.mobile = [dic objectForKey:@"mobile"];
            self.nickName = [dic objectForKey:@"nickName"];
            self.password = [dic objectForKey:@"password"];
            self.token = [dic objectForKey:@"token"];
            self.headIcon = [dic objectForKey:@"headIcon"];
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
    
    if (_nickName) {
        [dic setObject:_nickName forKey:@"nickName"];
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
    
    if (_mobile) {
        [dic setObject:_mobile forKey:@"mobile"];
    }
    return dic;
}
@end
