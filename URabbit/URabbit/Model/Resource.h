//
//  Resource.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resource : NSObject
@property(nonatomic, copy) NSString *music;
@property(nonatomic, copy) NSString *fgVideo;
@property(nonatomic, copy) NSString *maskVideo;
@property(nonatomic, copy) NSString *fgWebp;
@property(nonatomic, copy) NSString *maskBaseImage;
@property(nonatomic, copy) NSString *bgVideo;

@property(nonatomic) double duration;
@property(nonatomic) CGSize videoSize;
@property(nonatomic) double fps;
@property(nonatomic) NSInteger totalFrame;
@property(nonatomic) TemplateStyle style;

-(instancetype)initWithDictionary:(NSDictionary *)dic basePath:(NSString *)basePath;
@end
