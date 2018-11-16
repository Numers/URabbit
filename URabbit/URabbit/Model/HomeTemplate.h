//
//  HomeTemplate.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EditInfo;
@interface HomeTemplate : NSObject
@property(nonatomic, copy) UIImage *image;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *materialPath;
@property(nonatomic) CGSize videoSize;
@property(nonatomic) CGFloat seconds;
@end
