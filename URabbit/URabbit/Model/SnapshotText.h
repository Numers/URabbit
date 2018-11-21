//
//  SnapshotText.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Text,Custom,UTTextLabel;
@interface SnapshotText : NSObject
@property(nonatomic, strong) Text *text;
@property(nonatomic, copy) NSString *textName;
@property(nonatomic) CGFloat centerXPercent;
@property(nonatomic) CGFloat centerYPercent;
@property(nonatomic) CGFloat widthPercent;
@property(nonatomic) CGFloat heightPercent;
@property(nonatomic) CGFloat angle;
@property(nonatomic) CGFloat opacity;

@property(nonatomic, strong) UTTextLabel *textLabel;

-(void)changeText:(NSString *)text;
-(instancetype)initWithDictionary:(NSDictionary *)dic withCustom:(Custom *)custom;
@end
