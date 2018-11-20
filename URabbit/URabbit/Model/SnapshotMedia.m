//
//  SnapshotMedia.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "SnapshotMedia.h"
#import "Custom.h"

@implementation SnapshotMedia
-(instancetype)initWithDictionary:(NSDictionary *)dic basePath:(NSString *)basePath withCustom:(Custom *)custom
{
    self = [super init];
    if (self) {
        _centerXPercent = [[dic objectForKey:@"centreX"] floatValue];
        _centerYPercent = [[dic objectForKey:@"centreY"] floatValue];
        _scaleWidth = [[dic objectForKey:@"width"] floatValue];
        NSString *demoImage = [dic objectForKey:@"demoImage"];
        if (demoImage) {
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",basePath,demoImage];
            _demoImage = [UIImage imageWithContentsOfFile:imagePath];
        }else{
            
        }
        NSString *mediaName = [dic objectForKey:@"name"];
        if (mediaName) {
            _mediaName = mediaName;
            _media = [self filterMediaWithName:mediaName inArray:custom.mediaList];
        }
        
        _animationForMediaList = [NSMutableArray array];
        _animationForSwitchList = [NSMutableArray array];
    }
    return self;
}

-(Media *)filterMediaWithName:(NSString *)name inArray:(NSArray *)array
{
    Media *media = nil;
    NSArray *filterArray = [AppUtils fiterArray:array fieldName:@"mediaName" value:name];
    if (filterArray && filterArray.count > 0) {
        media = [filterArray objectAtIndex:0];
    }
    return media;
}
@end
