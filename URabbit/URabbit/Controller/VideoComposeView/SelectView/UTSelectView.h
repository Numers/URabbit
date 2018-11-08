//
//  UTSelectView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTFilterView.h"
@protocol UTSelectViewProtocol <NSObject>
-(NSMutableArray *)requestFilterViewDataSource;
-(void)didSelectFilter:(FilterInfo *)info;
@end
@interface UTSelectView : UIView<UTFilterViewProtocol>
{
    UTFilterView *filterView;
}
@property(nonatomic, weak) id<UTSelectViewProtocol> delegate;
-(void)showViewWithIndex:(NSInteger)index;
@end
