//
//  Author.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/19.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Author : NSObject
@property(nonatomic) long authorId;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *portrait;
@property(nonatomic, copy) NSString *summary;
@property(nonatomic) NSInteger subjectCount;
@property(nonatomic) NSInteger makeCount;
@property(nonatomic) NSInteger fansCount;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
