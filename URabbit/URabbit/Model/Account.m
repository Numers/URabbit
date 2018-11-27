//
//  Account.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/27.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Account.h"

@implementation Account
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _platform = (LoginPlatform)[[dic objectForKey:@"type"] integerValue];
        _nickName = [dic objectForKey:@"nickname"];
        _account = [dic objectForKey:@"account"];
    }
    return self;
}

-(NSDictionary *)dictionaryInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_platform) {
        [dic setObject:@(_platform) forKey:@"type"];
    }
    
    if (_nickName) {
        [dic setObject:_nickName forKey:@"nickname"];
    }
    
    if (_account) {
        [dic setObject:_account forKey:@"account"];
    }
    
    return dic;
}
@end
