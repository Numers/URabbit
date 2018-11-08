//
//  UTVideoInfoView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTVideoInfoView.h"
#import "HomeTemplate.h"

@implementation UTVideoInfoView
-(instancetype)initWithHomeTemplate:(HomeTemplate *)homeTemplate frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat playerWidth = SCREEN_WIDTH - 74 * 2;
        CGFloat playerHeight = playerWidth * (960.0f / 544.0f);
//        CGFloat playerHeight = 384.0f;
        NSString *templateVideo = [[NSBundle mainBundle] pathForResource:@"video-2280" ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:templateVideo];
//        playerItem = [[AVPlayerItem alloc] initWithURL:url];
//        player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
//        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        [playerLayer setFrame:CGRectMake(74, 0, playerWidth, playerHeight)];
//        [self.layer addSublayer:playerLayer];
        
        playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        playerController.controlStyle = MPMovieControlStyleDefault;
        playerController.shouldAutoplay = YES;
        playerController.scalingMode = MPMovieScalingModeAspectFit;
        [playerController.view setFrame:CGRectMake(74, 0, playerWidth, playerHeight)];
        [self addSubview:playerController.view];
        [playerController prepareToPlay];
        
        videoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, playerHeight + 26, frame.size.width - 70, 22)];
        [videoNameLabel setTextAlignment:NSTextAlignmentLeft];
        [videoNameLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [videoNameLabel setTextColor:[UIColor whiteColor]];
        [videoNameLabel setText:homeTemplate.name];
        [self addSubview:videoNameLabel];
        
        videoDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 55, playerHeight + 26, 40, 22)];
        [videoDurationLabel setTextAlignment:NSTextAlignmentRight];
        [videoDurationLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [videoDurationLabel setTextColor:[UIColor whiteColor]];
        [videoDurationLabel setText:@"00:15"];
        [self addSubview:videoDurationLabel];
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0]};
        CGSize size = [homeTemplate.desc boundingRectWithSize:CGSizeMake(frame.size.width - 30, 36) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
        videoDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, videoNameLabel.frame.origin.y + videoNameLabel.frame.size.height + 10, frame.size.width - 30, size.height)];
        [videoDescLabel setNumberOfLines:0];
        [videoDescLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [videoDescLabel setTextColor:[UIColor whiteColor]];
        [videoDescLabel setText:homeTemplate.desc];
        [self addSubview:videoDescLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, videoDescLabel.frame.origin.y + videoDescLabel.frame.size.height + 18, frame.size.width - 30, 0.5)];
        [AppUtils drawDashLine:lineView lineLength:frame.size.width - 30 lineSpacing:0 lineColor:[UIColor whiteColor]];
        [self addSubview:lineView];
        
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, lineView.frame.origin.y + lineView.frame.size.height)];
    }
    return self;
}

@end
