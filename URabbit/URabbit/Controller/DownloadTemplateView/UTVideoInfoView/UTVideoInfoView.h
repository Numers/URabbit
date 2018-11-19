//
//  UTVideoInfoView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class HomeTemplate;
@interface UTVideoInfoView : UIView
{
//    AVPlayer *player;
//    AVPlayerItem *playerItem;
    MPMoviePlayerController *playerController;
    UILabel *videoNameLabel;
    UILabel *videoDurationLabel;
    UILabel *videoDescLabel;
    
    UITableViewCell *cell;
}

-(instancetype)initWithVideoSize:(CGSize)size frame:(CGRect)frame;
-(void)setHomeTemplate:(HomeTemplate *)homeTemplate;
@end
