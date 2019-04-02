//
//  URVideoInfoView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
@class HomeTemplate;
@interface URVideoInfoView : UIView
{
//    AVPlayer *player;
//    AVPlayerItem *playerItem;
    SelVideoPlayer *playView;
    UILabel *videoNameLabel;
    UILabel *videoDurationLabel;
    UILabel *videoDescLabel;
    HomeTemplate *currentHomeTemplate;
}

-(instancetype)initWithVideoSize:(CGSize)size frame:(CGRect)frame;
-(void)setHomeTemplate:(HomeTemplate *)homeTemplate;
-(void)pausePlayView;
@end
