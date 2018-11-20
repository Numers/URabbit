//
//  Snapshot.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "SnapshotText.h"

@implementation Snapshot
-(instancetype)initWithDictionary:(NSDictionary *)dic basePath:(NSString *)basePath custom:(Custom *)custom
{
    self = [super init];
    if (self) {
        NSString *foreGroundImage = [dic objectForKey:@"foregroundImage"];
        if (foreGroundImage) {
            _foregroundImage = [NSString stringWithFormat:@"%@/%@",basePath,foreGroundImage];
        }
        
        _mediaList = [NSMutableArray array];
        NSArray *mediaArray = [dic objectForKey:@"media"];
        if (mediaArray && mediaArray.count > 0) {
            for (NSDictionary *mediaDic in mediaArray) {
                SnapshotMedia *snapshotMedia = [[SnapshotMedia alloc] initWithDictionary:mediaDic basePath:basePath withCustom:custom];
                [_mediaList addObject:snapshotMedia];
            }
        }
        
        _textList = [NSMutableArray array];
        NSArray *textArray = [dic objectForKey:@"text"];
        if (textArray && textArray.count > 0) {
            for (NSDictionary *textDic in textArray) {
                SnapshotText *text = [[SnapshotText alloc] initWithDictionary:textDic withCustom:custom];
                [_textList addObject:text];
            }
        }
        
    }
    return self;
}
@end
