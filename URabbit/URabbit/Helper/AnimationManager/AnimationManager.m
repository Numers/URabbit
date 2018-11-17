//
//  AnimationManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "AnimationManager.h"

@implementation AnimationManager
+(instancetype)shareManager
{
    static AnimationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AnimationManager alloc] init];
    });
    return manager;
}

-(CAAnimationGroup *)groupAnimationWithAnimations:(NSArray *)animations Duration:(CGFloat)duration repeatCount:(int)repeatCount
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    if (animations && animations.count > 0) {
        group.animations = animations;
        group.duration = duration;
        group.repeatCount = repeatCount;
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
    }
    return group;
}

-(CABasicAnimation *)translateLineAnimation:(NSString *)timingFunction fromCenter:(CGPoint)fromCenter toCenter:(CGPoint)toCenter startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    // 设定动画起始帧和结束帧
    animation.fromValue = [NSValue valueWithCGPoint:fromCenter]; // 起始点
    animation.toValue = [NSValue valueWithCGPoint:toCenter]; // 终了点
    animation.duration = duration;
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)translateZLineAnimation:(NSString *)timingFunction fromCenter:(CGFloat)fromCenter toCenter:(CGFloat)toCenter startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"zposition"];
    // 设定动画起始帧和结束帧
    animation.fromValue = @(fromCenter); // 起始点
    animation.toValue = @(toCenter); // 终了点
    animation.duration = duration;
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)translateLineAnimation:(NSString *)timingFunction fromRect:(CGRect)fromRect toRect:(CGRect)toRect startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    // 设定动画起始帧和结束帧
    animation.fromValue = [NSValue valueWithCGRect:fromRect]; // 起始点
    animation.toValue = [NSValue valueWithCGRect:toRect]; // 终了点
    animation.duration = duration;
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)translateLineAnimationWithControlPoints:(CGFloat)point1 point2:(CGFloat)point2 point3:(CGFloat)point3 point4:(CGFloat)point4 fromCenter:(CGPoint)fromCenter toCenter:(CGPoint)toCenter startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    // 设定动画起始帧和结束帧
    animation.fromValue = [NSValue valueWithCGPoint:fromCenter]; // 起始点
    animation.toValue = [NSValue valueWithCGPoint:toCenter]; // 终了点
    animation.duration = duration;
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:point1 :point2 :point3 :point4];
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)rotationYAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    // 设定动画选项
    animation.duration = duration;
//    animation.repeatCount = HUGE_VALF; // 重复次数
    animation.repeatCount = 1; // 重复次数
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:startAngle * M_PI / 180.0f]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:endAngle * M_PI / 180.0f]; // 终止角度
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)rotationXAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    // 设定动画选项
    animation.duration = duration;
    animation.repeatCount = 1; // 重复次数
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:startAngle * M_PI / 180.0f]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:endAngle * M_PI / 180.0f]; // 终止角度
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)rotationZAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 设定动画选项
    animation.duration = duration;
    animation.repeatCount = 1; // 重复次数
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:startAngle * M_PI / 180.0f]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:endAngle * M_PI / 180.0f]; // 终止角度
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)scaleAnimationWithStartScale:(CGFloat)startScale endScale:(CGFloat)endScale startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = duration;
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:startScale]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:endScale]; // 结束时的倍率
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)scaleWidthAnimationWithStartScale:(CGFloat)startScale endScale:(CGFloat)endScale startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    
    // 动画选项设定
    animation.duration = duration;
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:startScale]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:endScale]; // 结束时的倍率
    animation.delegate = animationObj;
    return animation;
}

-(CABasicAnimation *)scaleHeightAnimationWithStartScale:(CGFloat)startScale endScale:(CGFloat)endScale startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    
    // 动画选项设定
    animation.duration = duration;
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    animation.beginTime = AVCoreAnimationBeginTimeAtZero + startTime;
    animation.removedOnCompletion = isRemoved;
    if (!isRemoved) {
        animation.fillMode = kCAFillModeForwards;
    }
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:startScale]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:endScale]; // 结束时的倍率
    animation.delegate = animationObj;
    return animation;
}
@end
