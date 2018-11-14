//
//  FilterInfo.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/8.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FilterInfo : NSObject
@property(nonatomic, copy) NSString *filterName;
@property(nonatomic, copy) NSString *filterImage;
@property(nonatomic) FilterType type;
@end
