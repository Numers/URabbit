//
//  Media.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject
@property(nonatomic) MediaType type;
@property(nonatomic, copy) NSString *mediaName;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
