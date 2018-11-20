//
//  Custom.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Media,Text;
@interface Custom : NSObject
@property(nonatomic, strong) NSMutableArray<Media *> *mediaList;
@property(nonatomic, strong) NSMutableArray<Text *> *textList;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
