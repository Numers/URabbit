//
//  SwitchAnimationManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchAnimationManager : NSObject
+(instancetype)shareManager;
-(NSMutableArray *)animationsWithSwitchAnimationType:(SwitchAnimationType)type startTime:(CGFloat)startTime duration:(CGFloat)duration size:(CGSize)size;
@end
