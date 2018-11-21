//
//  SwitchAnimationManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "SwitchAnimationManager.h"
#import "AnimationManager.h"

@implementation SwitchAnimationManager
+(instancetype)shareManager
{
    static SwitchAnimationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SwitchAnimationManager alloc] init];
    });
    return manager;
}

-(NSMutableArray *)animationsWithSwitchAnimationType:(SwitchAnimationType)type startTime:(CGFloat)startTime duration:(CGFloat)duration size:(CGSize)size
{
    NSMutableArray *animations = [NSMutableArray array];
    switch (type) {
        case SwitchAnimationNone:
            
            break;
        case SwitchAnimationLeftIn:{
            CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(-size.width / 2, size.height / 2) toCenter:CGPointMake(size.width /2, size.height/2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:animation];
        }
            break;
        case SwitchAnimationLeftOut:{
            CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width / 2, size.height / 2) toCenter:CGPointMake(-size.width /2, size.height/2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:animation];
        }
            break;
        case SwitchAnimationRightIn:{
            CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(2 * size.width, size.height / 2) toCenter:CGPointMake(size.width /2, size.height/2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:animation];
        }
            break;
        case SwitchAnimationRightOut:{
            CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width/2, size.height / 2) toCenter:CGPointMake(2 * size.width, size.height/2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:animation];
        }
            break;
        case SwitchAnimationTopIn:{
            CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width/2, 2*size.height) toCenter:CGPointMake(size.width /2, size.height/2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:animation];
        }
            break;
        case SwitchAnimationTopOut:{
            CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width/2, size.height / 2) toCenter:CGPointMake(size.width /2, size.height*2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:animation];
        }
            break;
        case SwitchAnimationBottomIn:{
            CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width/2, -size.height / 2) toCenter:CGPointMake(size.width /2, size.height/2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:animation];
        }
            break;
        case SwitchAnimationBottomOut:{
            CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width/2, size.height / 2) toCenter:CGPointMake(size.width /2, -size.height/2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:animation];
        }
            break;
        case SwitchAnimationOpacity:{
            CABasicAnimation *moveInAnimation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width / 2, size.height / 2) toCenter:CGPointMake(-size.width /2, size.height/2) startTime:startTime duration:0.001 removeOnComplete:NO delegate:nil];
            CABasicAnimation *opacityAnimationIn = [[AnimationManager shareManager] opacityAnimationWithStartOpacity:0.0f endOpacity:1.0f startTime:startTime duration:duration/2 removeOnComplete:NO delegate:nil];
            CABasicAnimation *opacityAnimationOut = [[AnimationManager shareManager] opacityAnimationWithStartOpacity:1.0f endOpacity:0.0f startTime:startTime + duration / 2 duration:duration / 2 - 0.001 removeOnComplete:NO delegate:nil];
            CABasicAnimation *moveOutAnimation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(size.width/2, size.height / 2) toCenter:CGPointMake(2 * size.width, size.height/2) startTime:startTime duration:duration removeOnComplete:NO delegate:nil];
            [animations addObject:moveInAnimation];
            [animations addObject:opacityAnimationIn];
            [animations addObject:opacityAnimationOut];
            [animations addObject:moveOutAnimation];
        }
            break;
        default:
            break;
    }
    return animations;
}
@end
