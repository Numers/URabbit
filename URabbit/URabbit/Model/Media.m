//
//  Media.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Media.h"

@implementation Media
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _type = (MediaType)[[dic objectForKey:@"type"] integerValue];
        _mediaName = [dic objectForKey:@"name"];
    }
    return self;
}
@end
