//
//  UTFilterView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/8.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterInfo;
@protocol UTFilterViewProtocol <NSObject>
-(void)selectFilter:(FilterInfo *)info;
@end
@interface UTFilterView : UIView
@property(nonatomic, weak) id<UTFilterViewProtocol> delegate;
-(void)setFilterList:(NSMutableArray *)list;
@end
