//
//  AnimationForText.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/29.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "AnimationForText.h"

@implementation AnimationForText
-(instancetype)initWithDictionary:(NSDictionary *)dic startFrame:(NSInteger)startFrame endFrame:(NSInteger)endFrame animationType:(AnimationType)animationType fps:(CGFloat)fps
{
    self = [super init];
    if (self) {
        _type = animationType;
        _range = NSMakeRange(startFrame, endFrame - startFrame + 1);
        _name = [dic objectForKey:@"name"];
        _fps = fps;
        id centerX = [dic objectForKey:@"centreX"];
        if (centerX) {
            _centerXPercent = [centerX floatValue];
        }
        
        id centerY = [dic objectForKey:@"centreY"];
        if (centerY) {
            _centerYPercent = [centerY floatValue];
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
    }
    return self;
}
@end
