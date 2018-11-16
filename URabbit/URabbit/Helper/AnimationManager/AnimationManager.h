//
//  AnimationManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
@interface AnimationManager : NSObject
+(instancetype)shareManager;
-(CAAnimationGroup *)groupAnimationWithAnimations:(NSArray *)animations Duration:(CGFloat)duration repeatCount:(int)repeatCount;
-(CABasicAnimation *)translateLineAnimation:(NSString *)timingFunction fromCenter:(CGPoint)fromCenter toCenter:(CGPoint)toCenter startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

-(CABasicAnimation *)translateLineAnimation:(NSString *)timingFunction fromRect:(CGRect)fromRect toRect:(CGRect)toRect startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

-(CABasicAnimation *)translateZLineAnimation:(NSString *)timingFunction fromCenter:(CGFloat)fromCenter toCenter:(CGFloat)toCenter startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

//参考https://easings.net/zh-cn#
-(CABasicAnimation *)translateLineAnimationWithControlPoints:(CGFloat)point1 point2:(CGFloat)point2 point3:(CGFloat)point3 point4:(CGFloat)point4 fromCenter:(CGPoint)fromCenter toCenter:(CGPoint)toCenter startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

-(CABasicAnimation *)rotationYAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

-(CABasicAnimation *)rotationXAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

-(CABasicAnimation *)rotationZAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

-(CABasicAnimation *)scaleAnimationWithStartScale:(CGFloat)startScale endScale:(CGFloat)endScale startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

-(CABasicAnimation *)scaleWidthAnimationWithStartScale:(CGFloat)startScale endScale:(CGFloat)endScale startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;

-(CABasicAnimation *)scaleHeightAnimationWithStartScale:(CGFloat)startScale endScale:(CGFloat)endScale startTime:(CGFloat)startTime duration:(CGFloat)duration removeOnComplete:(BOOL)isRemoved delegate:(id<CAAnimationDelegate>)animationObj;
@end
