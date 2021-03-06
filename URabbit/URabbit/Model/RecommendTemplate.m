//
//  RecommendTemplate.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "RecommendTemplate.h"

@implementation RecommendTemplate
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _coverImage = [dic objectForKey:@"icon"];
        _name = [dic objectForKey:@"name"];
        _categoryId = [[dic objectForKey:@"id"] longValue];
    }
    return self;
}
@end
