//
//  VIPPrice.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "VIPPrice.h"

@implementation VIPPrice
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _priceId = [[dic objectForKey:@"id"] integerValue];
        _name = [dic objectForKey:@"name"];
        _months = [[dic objectForKey:@"months"] integerValue];
        _amount = [[dic objectForKey:@"amount"] integerValue];
        _desc = [dic objectForKey:@"description"];
    }
    return self;
}
@end
