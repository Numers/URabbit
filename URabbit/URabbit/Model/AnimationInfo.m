//
//  AnimationInfo.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "AnimationInfo.h"

@implementation AnimationInfo
-(instancetype)init
{
    self = [super init];
    if (self) {
        _animationObjects = [NSMutableArray array];
    }
    return self;
}
@end
