//
//  Custom.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Custom.h"
#import "Media.h"
#import "Text.h"

@implementation Custom
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _mediaList = [NSMutableArray array];
        NSArray *mediaArray = [dic objectForKey:@"media"];
        if (mediaArray && mediaArray.count > 0) {
            for (NSDictionary *mediaDic in mediaArray) {
                Media *media = [[Media alloc] initWithDictionary:mediaDic];
                [_mediaList addObject:media];
            }
        }
        
        _textList = [NSMutableArray array];
        NSArray *textArray = [dic objectForKey:@"text"];
        if (textArray && textArray.count > 0) {
            for (NSDictionary *textDic in textArray) {
                Text *text = [[Text alloc] initWithDictionary:textDic];
                [_textList addObject:text];
            }
        }
    }
    return self;
}
@end
