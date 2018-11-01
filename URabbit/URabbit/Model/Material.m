//
//  Material.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Material.h"

@implementation Material
-(instancetype)initWithFileUrl:(NSString *)fileUrl
{
    self  = [super init];
    if (self) {
        _totalFrames = 374;
        NSString *maskVideoPath = [[NSBundle mainBundle] pathForResource:@"video-2281" ofType:@"mp4"];
        _templateVideo = [[NSBundle mainBundle] pathForResource:@"video-2280" ofType:@"mp4"];
        _videoMusic = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
        _maskVideos = [NSMutableArray arrayWithObject:maskVideoPath];
    }
    return self;
}
@end
