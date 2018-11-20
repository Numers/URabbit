//
//  Text.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Text : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *fontUrl;
@property(nonatomic) CGFloat fontSize;
@property(nonatomic, copy) NSString *fontColor;
@property(nonatomic) NSInteger wordLimit;
@property(nonatomic) TextHorizontalAlignType horizontalAlignType;
@property(nonatomic) TextVerticalAlignType verticalAlignType;
@property(nonatomic) NSInteger rowLimit;
@property(nonatomic) NSInteger direction;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
