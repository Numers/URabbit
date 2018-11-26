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
-(instancetype)initWithVideoSize:(CGSize)size frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat playerWidth = SCREEN_WIDTH - 74 * 2;
        CGFloat playerHeight = playerWidth * (size.height / size.width);
        SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
        configuration.shouldAutoPlay = YES;
        configuration.supportedDoubleTap = YES;
        configuration.shouldAutorotate = YES;
        configuration.repeatPlay = NO;
        configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
        configuration.videoGravity = SelVideoGravityResizeAspect;
        playView = [[SelVideoPlayer alloc] initWithFrame:CGRectMake(74, 0, playerWidth, playerHeight) configuration:configuration];
        [self addSubview:playView];
        
        videoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, playerHeight + 26, frame.size.width - 70, 22)];
        [videoNameLabel setTextAlignment:NSTextAlignmentLeft];
        [videoNameLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [videoNameLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:videoNameLabel];
        
        videoDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 55, playerHeight + 26, 40, 22)];
        [videoDurationLabel setTextAlignment:NSTextAlignmentRight];
        [videoDurationLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [videoDurationLabel setTextColor:[UIColor whiteColor]];
        [videoDurationLabel setText:@"00:15"];
        [self addSubview:videoDurationLabel];
        
        
        videoDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, videoNameLabel.frame.origin.y + videoNameLabel.frame.size.height + 10, frame.size.width - 30, 0)];
        [videoDescLabel setNumberOfLines:0];
        [videoDescLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [videoDescLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:videoDescLabel];
    }
    return self;
}

-(void)setHomeTemplate:(HomeTemplate *)homeTemplate
{
    [playView setMovieUrl:[NSURL URLWithString:homeTemplate.demoUrl]];
    
    [videoNameLabel setText:homeTemplate.title];
    [videoDurationLabel setText:[AppUtils getMMSSFromSS:homeTemplate.duration]];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0]};
    CGSize size = [homeTemplate.summary boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, 36) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
    [videoDescLabel setText:homeTemplate.summary];
    [videoDescLabel setFrame:CGRectMake(15, videoNameLabel.frame.origin.y + videoNameLabel.frame.size.height + 10, self.frame.size.width - 30, size.height)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, videoDescLabel.frame.origin.y + videoDescLabel.frame.size.height + 18, self.frame.size.width - 30, 0.5)];
    [AppUtils drawDashLine:lineView lineLength:self.frame.size.width - 30 lineSpacing:0 lineColor:[UIColor whiteColor]];
    [self addSubview:lineView];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, lineView.frame.origin.y + lineView.frame.size.height)];
}

-(void)pausePlayView
{
    [playView _pauseVideo];
}
@end
