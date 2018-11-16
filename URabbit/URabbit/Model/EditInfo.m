//
//  EditInfo.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "EditInfo.h"
#import "AnimationObject.h"

@implementation EditInfo
-(instancetype)initWithDictinary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        NSArray *rangeArray = [dic objectForKey:@"range"];
        NSInteger fromFrame = [[rangeArray objectAtIndex:0] integerValue];
        NSInteger toFrame = [[rangeArray objectAtIndex:1] integerValue];
        _range = NSMakeRange(fromFrame, toFrame - fromFrame);
        NSString *editImageName = [dic objectForKey:@"editImage"];
        _editImage = [AppUtils isNullStr:editImageName] ? nil : editImagePath;
        _editImageCenterXPercent = [[dic objectForKey:@"centerX"] floatValue];
        _editImageCenterYPercent = [[dic objectForKey:@"centerY"] floatValue];
        _filterType = (FilterType)[[dic objectForKey:@"filterType"] integerValue];
        _animationObjects = [NSMutableArray array];
        NSArray *animations = [dic objectForKey:@"animationGroup"];
        if (animations && animations.count > 0) {
            for (NSDictionary *animationDic in animations) {
                AnimationObject *animationObject = [[AnimationObject alloc] initWithDictionary:animationDic];
                [_animationObjects addObject:animationObject];
            }
        }
    }
    return self;
}
@end
