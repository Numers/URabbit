//
//  AnimationSwitch.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "AnimationSwitch.h"

@implementation AnimationSwitch
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _type = (SwitchAnimationType)[[dic objectForKey:@"type"] integerValue];
        NSInteger startFrame = [[dic objectForKey:@"startFrame"] integerValue];
        NSInteger endFrame = [[dic objectForKey:@"endFrame"] integerValue];
        _range = NSMakeRange(startFrame, endFrame - startFrame + 1);
    }
    return self;
}
@end
