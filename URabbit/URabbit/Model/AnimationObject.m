//
//  AnimationObject.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/16.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "AnimationObject.h"
#import "AnimationManager.h"

@implementation AnimationObject
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _animationType = (AnimationType)[[dic objectForKey:@"animationType"] integerValue];
        _category = [[dic objectForKey:@"category"] integerValue];
        _duration = [[dic objectForKey:@"duration"] floatValue];
        _beginTime = [[dic objectForKey:@"beginTime"] floatValue];
        _fromValue = [dic objectForKey:@"fromValue"];
        _toValue = [dic objectForKey:@"toValue"];
        _isRemoved = [[dic objectForKey:@"isRemoved"] boolValue];
    }
    return self;
}

-(CABasicAnimation *)generateAnimation
{
    CABasicAnimation *animation = nil;
    switch (_animationType) {
        case AnimationRotation:
        {
            if (_category == 1) {
                animation = [[AnimationManager shareManager] rotationXAnimationWithStartAngle:[_fromValue floatValue] endAngle:[_toValue floatValue] startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }else if (_category == 2){
                animation = [[AnimationManager shareManager] rotationYAnimationWithStartAngle:[_fromValue floatValue] endAngle:[_toValue floatValue] startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }else if (_category == 3){
                animation = [[AnimationManager shareManager] rotationZAnimationWithStartAngle:[_fromValue floatValue] endAngle:[_toValue floatValue] startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }
            
        }
            break;
        case AnimationScale:
        {
            if (_category == 1) {
                animation = [[AnimationManager shareManager] scaleAnimationWithStartScale:[_fromValue floatValue] endScale:[_toValue floatValue] startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }else if (_category == 2){
                animation = [[AnimationManager shareManager] scaleWidthAnimationWithStartScale:[_fromValue floatValue] endScale:[_toValue floatValue] startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }else if (_category == 3){
                animation = [[AnimationManager shareManager] scaleHeightAnimationWithStartScale:[_fromValue floatValue] endScale:[_toValue floatValue] startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }
        }
            break;
        case AnimationTransform:
        {
            NSArray *fromValues = _fromValue;
            NSArray *toValues = _toValue;
            if (_category == 1) {
                CGPoint fromCenter = CGPointMake([[fromValues objectAtIndex:0] floatValue], [[fromValues objectAtIndex:1] floatValue]);
                CGPoint toCenter = CGPointMake([[toValues objectAtIndex:0] floatValue], [[toValues objectAtIndex:1] floatValue]);
                animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionEaseIn fromCenter:fromCenter toCenter:toCenter startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }else if (_category == 2){
                CGFloat fromAxios = [[fromValues objectAtIndex:0] floatValue];
                CGFloat toAxios = [[toValues objectAtIndex:1] floatValue];
                animation = [[AnimationManager shareManager] translateZLineAnimation:kCAMediaTimingFunctionLinear fromCenter:fromAxios toCenter:toAxios startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }else if (_category == 3){
                CGPoint fromCenter = CGPointMake([[fromValues objectAtIndex:0] floatValue], [[fromValues objectAtIndex:1] floatValue]);
                CGPoint toCenter = CGPointMake([[toValues objectAtIndex:0] floatValue], [[toValues objectAtIndex:1] floatValue]);
                animation = [[AnimationManager shareManager] translateLineAnimationWithControlPoints:[[fromValues objectAtIndex:0] floatValue] point2:[[fromValues objectAtIndex:1] floatValue] point3:[[fromValues objectAtIndex:2] floatValue] point4:[[fromValues objectAtIndex:3] floatValue] fromCenter:fromCenter toCenter:toCenter startTime:_beginTime duration:_duration removeOnComplete:_isRemoved delegate:nil];
            }
        }
            break;
        default:
            break;
    }
    return animation;
}
@end
