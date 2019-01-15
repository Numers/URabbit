//
//  HomeTemplate.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Author;
@interface HomeTemplate : NSObject
@property(nonatomic) long templateId;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *coverUrl;
@property(nonatomic) double duration;
@property(nonatomic) CGSize videoSize;
@property(nonatomic) double fps;
@property(nonatomic, copy) NSString *latestVersion;
@property(nonatomic, copy) NSString *templateVersion;
@property(nonatomic) BOOL isVip;
@property(nonatomic) NSInteger totalFrame;
@property(nonatomic) TemplateStyle style;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic, copy) NSString *demoUrl;
@property(nonatomic) double downloadSize;
@property(nonatomic, copy) NSString *downloadUrl;
@property(nonatomic) NSInteger favoriteCount;
@property(nonatomic, strong) Author *author;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
