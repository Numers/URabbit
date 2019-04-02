//
//  URSegmentView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectIndexBlock)(NSInteger index);
@interface URSegmentView : UIView
{
    UIScrollView *scrollView;
    UIView *lineView;
    UIView *bottomLineView;
    NSInteger selectedIndex;
}
@property(nonatomic, strong) NSMutableArray *buttons;
@property(nonatomic, strong) NSMutableArray *titleList;
@property(nonatomic) UIEdgeInsets edgeInsets;
@property(nonatomic) SelectIndexBlock selectIndexBlock;
-(void)addTitles:(NSArray *)titles;
@end
