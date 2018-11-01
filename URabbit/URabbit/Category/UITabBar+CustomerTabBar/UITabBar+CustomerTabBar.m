//
//  UITabBar+CustomerTabBar.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/6/6.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UITabBar+CustomerTabBar.h"
#define BadgeViewWidthAndHeight 14.0f

@implementation UITabBar (CustomerTabBar)
//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5.0;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    NSInteger itemsCount = self.items.count;
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / itemsCount;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10.0, 10.0);//圆形大小为10
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}

- (void)showBadgeValue:(NSString *)value OnItemIndex:(NSInteger)index
{
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    NSInteger itemsCount = self.items.count;
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / itemsCount;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, BadgeViewWidthAndHeight, BadgeViewWidthAndHeight);//圆形大小为10
    badgeView.layer.cornerRadius = BadgeViewWidthAndHeight / 2.0f;//圆形
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
    
    UILabel *lblValue = [[UILabel alloc] init];
    [lblValue setText:value];
    [lblValue setTextColor:[UIColor whiteColor]];
    [lblValue setFont:[UIFont systemFontOfSize:8.0f]];
    [lblValue sizeToFit];
    [lblValue setCenter:CGPointMake(badgeView.frame.size.width / 2.0f, badgeView.frame.size.height / 2.0f)];
    [badgeView addSubview:lblValue];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
