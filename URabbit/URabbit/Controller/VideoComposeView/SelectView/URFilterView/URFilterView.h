//
//  URFilterView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/8.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterInfo;
@protocol URFilterViewProtocol <NSObject>
-(void)selectFilter:(FilterInfo *)info;
@end
@interface URFilterView : UIView
@property(nonatomic) BOOL isLoadData;
@property(nonatomic, weak) id<URFilterViewProtocol> delegate;
-(void)setFilterList:(NSMutableArray *)list;
@end
