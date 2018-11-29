//
//  AnimationForText.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/29.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationForText : NSObject
@property(nonatomic) AnimationType type;
@property(nonatomic, copy) NSString *name;
@property(nonatomic) NSRange range;
@property(nonatomic) CGFloat centerXPercent;
@property(nonatomic) CGFloat centerYPercent;
@property(nonatomic) CGFloat startAngle;
@property(nonatomic) CGFloat endAngle;
@property(nonatomic) CGFloat startRatio;
@property(nonatomic) CGFloat endRatio;
@property(nonatomic) CGPoint startCoordinate;
@property(nonatomic) CGPoint endCoordinate;
@property(nonatomic) CGFloat startBlur;
@property(nonatomic) CGFloat endBlur;

@property(nonatomic) CGFloat fps;

-(instancetype)initWithDictionary:(NSDictionary *)dic startFrame:(NSInteger)startFrame endFrame:(NSInteger)endFrame animationType:(AnimationType)animationType fps:(CGFloat)fps;
@end
