//
//  UTMemberCompositionInfoView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTMemberCompositionInfoView.h"

@implementation UTMemberCompositionInfoView
-(instancetype)initWithVideoSize:(CGSize)size frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        CGFloat playerWidth = frame.size.width - 57 * 2;
        CGFloat playerHeight = playerWidth * (size.height / size.width);
        
        playerController = [[MPMoviePlayerController alloc] init];
        playerController.controlStyle = MPMovieControlStyleDefault;
        playerController.shouldAutoplay = YES;
        playerController.scalingMode = MPMovieScalingModeAspectFit;
        [playerController.view setFrame:CGRectMake(57, 0, playerWidth, playerHeight)];
        [self addSubview:playerController.view];
        
        videoNameLabel = [[UILabel alloc] init];
        [videoNameLabel setTextAlignment:NSTextAlignmentCenter];
        [videoNameLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [videoNameLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:videoNameLabel];
        
        videoDurationLabel = [[UILabel alloc] init];
        [videoDurationLabel setTextAlignment:NSTextAlignmentCenter];
        [videoDurationLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [videoDurationLabel setTextColor:[UIColor whiteColor]];
        [videoDurationLabel setText:@"00:15"];
        [self addSubview:videoDurationLabel];
        
        
        videoDescLabel = [[UILabel alloc] init];
        [videoDescLabel setNumberOfLines:0];
        [videoDescLabel setTextAlignment:NSTextAlignmentCenter];
        [videoDescLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [videoDescLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:videoDescLabel];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(playerController.view.bottom).offset(31);
        make.centerX.equalTo(self.centerX);
        make.height.equalTo(@(22));
    }];
    
    [videoDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(videoNameLabel.bottom).offset(5);
        make.centerX.equalTo(self.centerX);
        make.height.equalTo(@(20));
    }];
    
    [videoDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(videoDurationLabel.bottom).offset(15);
        make.centerX.equalTo(self.centerX);
        make.leading.equalTo(@(70));
    }];
}

-(void)setupViewWithComposition:(Composition *)composition
{
    [playerController setContentURL:[NSURL fileURLWithPath:composition.moviePath]];
    [playerController prepareToPlay];
    [videoNameLabel setText:[NSString stringWithFormat:@"【%@】",composition.title]];
    [videoDurationLabel setText:[AppUtils getMMSSFromSS:composition.duration]];
    [videoDescLabel setText:composition.summary];
    [videoDescLabel sizeToFit];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0]};
    CGSize size = [composition.summary boundingRectWithSize:CGSizeMake(self.frame.size.width - 140, 36) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, playerController.view.frame.size.height + 93 + size.height + 5)];
}
@end
