//
//  RecommendTemplate.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendTemplate : NSObject
@property(nonatomic, copy) NSString *coverImage;
@property(nonatomic, copy) NSString *name;
@property(nonatomic) long categoryId;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
