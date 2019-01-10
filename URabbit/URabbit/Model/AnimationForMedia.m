//
//  AnimationForMedia.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "AnimationForMedia.h"
#import "AnimationManager.h"

@implementation AnimationForMedia
-(instancetype)initWithDictionary:(NSDictionary *)dic startFrame:(NSInteger)startFrame endFrame:(NSInteger)endFrame fps:(CGFloat)fps parentDic:(NSDictionary *)parentDic
{
    self = [super init];
    if (self) {
        id animationType = [dic objectForKey:@"type"];
        if (animationType) {
            _type = (AnimationType)[animationType integerValue];
        }else{
            _type = AnimationNone;
        }
        _range = NSMakeRange(startFrame, endFrame - startFrame + 1);
        _name = [dic objectForKey:@"name"];
        _fps = fps;
        id locationCenterX = [dic objectForKey:@"locationCentreX"];
        if (locationCenterX) {
            _locationCenterXPercent = [locationCenterX floatValue];
        }else{
            _locationCenterXPercent = 0.5;
        }
        
        id locationCenterY = [dic objectForKey:@"locationCentreY"];
        if (locationCenterY) {
            _locationCenterYPercent = [locationCenterY floatValue];
        }else{
            _locationCenterYPercent = 0.5;
        }
        
        id animationCenterX = [dic objectForKey:@"centreX"];
        if (animationCenterX) {
            _centerXPercent = [animationCenterX floatValue];
        }else{
            _centerXPercent = 0;
        }
        id animationCenterY = [dic objectForKey:@"centreY"];
        if (animationCenterY) {
            _centerYPercent = [animationCenterY floatValue];
        }else{
            _centerYPercent = 1;
        }
        
        
        id width = [dic objectForKey:@"width"];
        if (width) {
            _widthPercent = [width floatValue];
        }else{
            _widthPercent = 1.0f;
        }
        
        id height = [dic objectForKey:@"height"];
        if (height) {
            _heightPercent = [height floatValue];
        }else{
            _heightPercent = 1.0f;
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
        
        _parentMediaAnimation = [[ParentMediaAnimation alloc] initWithDictionary:parentDic];
    }
    return self;
}

-(CABasicAnimation *)animationForMediaWithSize:(CGSize)size
{
    CABasicAnimation *animation = nil;
    switch (_type) {
        case AnimationNone:
            
            break;
        case AnimationTransform:
        {
            animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width * _startCoordinate.x, size.height * _startCoordinate.y) toCenter:CGPointMake(size.width * _endCoordinate.x, size.height * _endCoordinate.y) startTime:_range.location / _fps + 0.001 duration:_range.length / _fps - 0.002 removeOnComplete:NO delegate:nil];
        }
            break;
        case AnimationScale:
        {
            animation = [[AnimationManager shareManager] scaleAnimationWithStartScale:_startRatio endScale:_endRatio startTime:_range.location / _fps duration:_range.length / _fps removeOnComplete:NO delegate:nil];
        }
            break;
        case AnimationBlur:
        {
            animation = [[AnimationManager shareManager] opacityAnimationWithStartOpacity:_startBlur endOpacity:_endBlur startTime:_range.location / _fps duration:_range.length / _fps removeOnComplete:NO delegate:nil];
        }
            break;
        case AnimationRotation:
        {
            animation = [[AnimationManager shareManager] rotationZAnimationWithStartAngle:_startAngle endAngle:_endAngle startTime:_range.location / _fps duration:_range.length / _fps removeOnComplete:NO delegate:nil];
        }
            break;
        default:
            break;
    }
    return animation;
}
@end
