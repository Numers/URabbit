//
//  AnimationInfo.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationInfo : NSObject
@property(nonatomic) NSRange range;
@property(nonatomic) NSMutableArray *animationObjects;
@property(nonatomic) FilterType filterType;
@property(nonatomic) NSInteger axiosIndex;
@end
