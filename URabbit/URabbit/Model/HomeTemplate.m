//
//  HomeTemplate.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "HomeTemplate.h"
#import "Author.h"

@implementation HomeTemplate
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _templateId = [[dic objectForKey:@"id"] longValue];
        _title = [dic objectForKey:@"title"];
        _coverUrl = [dic objectForKey:@"coverUrl"];
        _latestVersion = [dic objectForKey:@"iosVersion"];
        _templateVersion = [dic objectForKey:@"version"];
        if (_templateVersion == nil) {
            _templateVersion = @"NoVersion";
        }
        _isVip = [[dic objectForKey:@"isVip"] boolValue];
        _duration = [[dic objectForKey:@"duration"] doubleValue];
        _fps = [[dic objectForKey:@"frameRate"] doubleValue];
        _totalFrame = floor(_duration * _fps);
        _style = (TemplateStyle)[[dic objectForKey:@"style"] integerValue];
        NSInteger width = [[dic objectForKey:@"width"] integerValue];
        NSInteger height = [[dic objectForKey:@"height"] integerValue];
        _videoSize = CGSizeMake(width, height);
        
        _summary = [dic objectForKey:@"summary"];
        _demoUrl = [dic objectForKey:@"demoUrl"];
        id downloadSize = [dic objectForKey:@"downloadSize"];
        if (downloadSize) {
            _downloadSize =  [downloadSize doubleValue];
        }
        
        _downloadUrl = [dic objectForKey:@"downloadUrl"];
        id favoriteCount = [dic objectForKey:@"favoriteCount"];
        if (favoriteCount) {
            _favoriteCount = [favoriteCount integerValue];
        }
        
        NSDictionary *authorDic = [dic objectForKey:@"author"];
        if (authorDic) {
            _author = [[Author alloc] initWithDictionary:authorDic];
        }
    }
    return self;
}
@end
