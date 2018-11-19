//
//  Author.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/19.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Author.h"

@implementation Author
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _authorId = [[dic objectForKey:@"id"] longValue];
        _nickName = [dic objectForKey:@"nickname"];
        _portrait = [dic objectForKey:@"portrait"];
        _summary = [dic objectForKey:@"summary"];
        _subjectCount = [[dic objectForKey:@"subjectCount"] integerValue];
        _makeCount = [[dic objectForKey:@"makeCount"] integerValue];
        _fansCount = [[dic objectForKey:@"fansCount"] integerValue];
    }
    return self;
}
@end
