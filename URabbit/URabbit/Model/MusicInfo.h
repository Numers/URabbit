//
//  MusicInfo.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicInfo : NSObject
@property(nonatomic, copy) NSString *musicName;
@property(nonatomic, copy) NSString *musicImage;
@property(nonatomic, copy) NSString *musicUrl;
@property(nonatomic) NSInteger size;
@property(nonatomic) CGFloat duration;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
