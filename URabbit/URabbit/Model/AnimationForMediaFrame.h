//
//  AnimationForMediaFrame.h
//  URabbit
//
//  Created by 鲍利成 on 2019/1/13.
//  Copyright © 2019年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationForMediaFrame : NSObject
@property(nonatomic) CGFloat locationCenterXPercent; //位置中心点X
@property(nonatomic) CGFloat locationCenterYPercent; //位置中心点Y
@property(nonatomic) CGFloat widthPercent;
@property(nonatomic) CGFloat heightPercent;
@property(nonatomic) CGFloat angle;
@property(nonatomic) CGFloat alpha;
@property(nonatomic) CGFloat blur;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
