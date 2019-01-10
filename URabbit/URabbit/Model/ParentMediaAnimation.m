//
//  ParentMediaAnimation.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ParentMediaAnimation.h"

@implementation ParentMediaAnimation
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        id animationType = [dic objectForKey:@"type"];
        if (animationType) {
            _type = (AnimationType)[animationType integerValue];
        }else{
            _type = AnimationNone;
        }
        
        id animationCenterX = [dic objectForKey:@"centreX"];
        if (animationCenterX) {
            _centerXPercent = [animationCenterX floatValue];
        }else{
            _centerXPercent = 0.5f;
        }
        id animationCenterY = [dic objectForKey:@"centreY"];
        if (animationCenterY) {
            _centerYPercent = [animationCenterY floatValue];
        }else{
            _centerYPercent = 0.5f;
        }
        
        
        id startAngle = [dic objectForKey:@"startAngle"];
        if (startAngle) {
            _startAngle = [startAngle floatValue];
        }
        
        id endAngle = [dic objectForKey:@"endAngle"];
        if (endAngle) {
            _endAngle = [endAngle floatValue];
        }
        
        id startRatio = [dic objectForKey:@"startRatio"];
        if (startRatio) {
            _startRatio = [startRatio floatValue];
        }
        
        id endRatio = [dic objectForKey:@"endRatio"];
        if (endRatio) {
            _endRatio = [endRatio floatValue];
        }
        
        NSString *startCoordinate = [dic objectForKey:@"startCoordinate"];
        if (startCoordinate) {
            NSArray *startAxios = [startCoordinate componentsSeparatedByString:@"_"];
            if (startAxios && startAxios.count > 1) {
                _startCoordinate = CGPointMake([[startAxios objectAtIndex:0] floatValue], [[startAxios objectAtIndex:1] floatValue]);
            }
        }
        
        NSString *endCoordinate = [dic objectForKey:@"endCoordinate"];
        if (endCoordinate) {
            NSArray *endAxios = [endCoordinate componentsSeparatedByString:@"_"];
            if (endAxios && endAxios.count > 1) {
                _endCoordinate = CGPointMake([[endAxios objectAtIndex:0] floatValue], [[endAxios objectAtIndex:1] floatValue]);
            }
        }
        
        id startBlur = [dic objectForKey:@"startBlur"];
        if (startBlur) {
            _startBlur = [startBlur floatValue];
        }
        
        id endBlur = [dic objectForKey:@"endBlur"];
        if (endBlur) {
            _endBlur = [endBlur floatValue];
        }
        
        id startAlpha = [dic objectForKey:@"startAlpha"];
        if (startAlpha) {
            _startAlpha = [startAlpha floatValue];
        }
        
        id endAlpha = [dic objectForKey:@"endAlpha"];
        if (endAlpha) {
            _endAlpha = [endAlpha floatValue];
        }
    }
    return self;
}
@end
