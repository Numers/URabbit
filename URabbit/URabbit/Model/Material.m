//
//  Material.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Material.h"
#import "UTVideoManager.h"

@implementation Material
-(instancetype)initWithFileUrl:(NSString *)fileUrl
{
    self  = [super init];
    if (self) {
//        NSString *maskVideoPath = [[NSBundle mainBundle] pathForResource:@"video-2281" ofType:@"mp4"];
//        _templateVideo = [[NSBundle mainBundle] pathForResource:@"video-2280" ofType:@"mp4"];
        _videoSize = CGSizeMake(544, 960);
        _fps = 25.0f;
//        _totalFrames = [[UTVideoManager shareManager] getTotalFramesWithVideoPath:_templateVideo];
        _totalFrames = 375;
        _seconds = _totalFrames / _fps;
        _videoMusic = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
//        _maskVideos = [NSMutableArray arrayWithObject:maskVideoPath];
        _animationFile = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"txt"];
        _materialType = MaterialAnimation;
    }
    return self;
}
@end
