//
//  AnimationInfo.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "AnimationInfo.h"
#import "AnimationObject.h"

@implementation AnimationInfo
-(instancetype)initWithDictionary:(NSDictionary *)dic fps:(CGFloat)fps
{
    self = [super init];
    if (self) {
        NSArray *rangeArray = [dic objectForKey:@"range"];
        NSInteger fromFrame = [[rangeArray objectAtIndex:0] integerValue];
        NSInteger toFrame = [[rangeArray objectAtIndex:1] integerValue];
        _range = NSMakeRange(fromFrame, toFrame - fromFrame);
        _axiosIndex = [[dic objectForKey:@"editIndex"] integerValue];
        _filterType = (FilterType)[[dic objectForKey:@"filterType"] integerValue];
        _animationObjects = [NSMutableArray array];
        NSArray *animations = [dic objectForKey:@"animationGroup"];
        CGFloat baseTime = fromFrame / fps;
        if (animations && animations.count > 0) {
            for (NSDictionary *animationDic in animations) {
                AnimationObject *animationObject = [[AnimationObject alloc] initWithDictionary:animationDic baseTime:baseTime];
                [_animationObjects addObject:animationObject];
            }
        }
    }
    return self;
}
@end
