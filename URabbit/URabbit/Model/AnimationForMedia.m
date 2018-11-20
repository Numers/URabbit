//
//  AnimationForMedia.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "AnimationForMedia.h"

@implementation AnimationForMedia
-(instancetype)initWithDictionary:(NSDictionary *)dic startFrame:(NSInteger)startFrame endFrame:(NSInteger)endFrame animationType:(AnimationType)animationType
{
    self = [super init];
    if (self) {
        _type = animationType;
        _range = NSMakeRange(startFrame, endFrame - startFrame + 1);
        _name = [dic objectForKey:@"name"];
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
        
        id startCoordinate = [dic objectForKey:@"startCoordinate"];
        if (startCoordinate) {
            _startCoordinate = [startCoordinate floatValue];
        }
        
        id endCoordinate = [dic objectForKey:@"endCoordinate"];
        if (endCoordinate) {
            _endCoordinate = [endCoordinate floatValue];
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
