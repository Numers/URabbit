//
//  UITabBar+CustomerTabBar.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/6/6.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (CustomerTabBar)
- (void)showBadgeOnItemIndex:(NSInteger)index;   ///<显示小红点
- (void)showBadgeValue:(NSString *)value OnItemIndex:(NSInteger)index;
- (void)hideBadgeOnItemIndex:(NSInteger)index;  ///<隐藏小红点
@end
