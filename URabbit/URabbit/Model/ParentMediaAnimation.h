//
//  ParentMediaAnimation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParentMediaAnimation : NSObject
@property(nonatomic) AnimationType type;
@property(nonatomic) CGFloat centerXPercent; //动画中心点X
@property(nonatomic) CGFloat centerYPercent; //动画中心点Y
@property(nonatomic) CGFloat startAngle;
@property(nonatomic) CGFloat endAngle;
@property(nonatomic) CGFloat startRatio;
@property(nonatomic) CGFloat endRatio;
@property(nonatomic) CGPoint startCoordinate;
@property(nonatomic) CGPoint endCoordinate;
@property(nonatomic) CGFloat startBlur;
@property(nonatomic) CGFloat endBlur;
@property(nonatomic) CGFloat startAlpha;
@property(nonatomic) CGFloat endAlpha;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
