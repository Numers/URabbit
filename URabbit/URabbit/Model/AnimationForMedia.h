//
//  AnimationForMedia.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentMediaAnimation.h"

@interface AnimationForMedia : NSObject
@property(nonatomic) AnimationType type;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) ParentMediaAnimation *parentMediaAnimation;
@property(nonatomic) NSRange range;
@property(nonatomic) CGFloat centerXPercent; //动画中心点X
@property(nonatomic) CGFloat centerYPercent; //动画中心点Y
@property(nonatomic) CGFloat locationCenterXPercent; //位置中心点X
@property(nonatomic) CGFloat locationCenterYPercent; //位置中心点Y
@property(nonatomic) CGFloat widthPercent;
@property(nonatomic) CGFloat heightPercent;
@property(nonatomic) CGFloat startAngle;
@property(nonatomic) CGFloat endAngle;
@property(nonatomic) CGFloat startAlpha;
@property(nonatomic) CGFloat endAlpha;
@property(nonatomic) CGFloat startRatio;
@property(nonatomic) CGFloat endRatio;
@property(nonatomic) CGPoint startCoordinate;
@property(nonatomic) CGPoint endCoordinate;
@property(nonatomic) CGFloat startBlur;
@property(nonatomic) CGFloat endBlur;

@property(nonatomic) CGFloat fps;

-(instancetype)initWithDictionary:(NSDictionary *)dic startFrame:(NSInteger)startFrame endFrame:(NSInteger)endFrame fps:(CGFloat)fps parentDic:(NSDictionary *)parentDic;
-(CABasicAnimation *)animationForMediaWithSize:(CGSize)size;
@end
