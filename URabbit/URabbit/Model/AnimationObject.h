//
//  AnimationObject.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/16.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationObject : NSObject
@property(nonatomic) AnimationType animationType;
@property(nonatomic) NSInteger category;
@property(nonatomic) CGFloat duration;
@property(nonatomic) CGFloat beginTime;
@property(nonatomic) id fromValue;
@property(nonatomic) id toValue;
@property(nonatomic) BOOL isRemoved;
-(instancetype)initWithDictionary:(NSDictionary *)dic baseTime:(CGFloat)baseTime;
-(CABasicAnimation *)generateAnimation;
@end
