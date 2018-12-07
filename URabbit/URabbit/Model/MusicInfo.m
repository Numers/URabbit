//
//  MusicInfo.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "MusicInfo.h"

@implementation MusicInfo
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _musicName = [dic objectForKey:@"name"];
        _musicImage = [dic objectForKey:@"coverUrl"];
        _musicUrl = [dic objectForKey:@"audioUrl"];
        _size = [[dic objectForKey:@"size"] integerValue];
        _duration = [[dic objectForKey:@"duration"] floatValue];
    }
    return self;
}
@end
