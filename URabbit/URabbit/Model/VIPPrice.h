//
//  VIPPrice.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPPrice : NSObject
@property(nonatomic) NSInteger priceId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic) NSInteger months;
@property(nonatomic) NSInteger amount;
@property(nonatomic, copy) NSString *desc;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
