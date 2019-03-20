//
//  UTMemberCompositionInfoView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "Composition.h"
@interface UTMemberCompositionInfoView : UIView
{
    SelVideoPlayer *playView;
    UILabel *videoNameLabel;
    UILabel *videoDurationLabel;
    UILabel *videoDescLabel;
}

-(instancetype)initWithVideoSize:(CGSize)size frame:(CGRect)frame;
-(void)setupViewWithComposition:(Composition *)composition;
-(void)pausePlayView;
-(void)destroyPlayView;
@end
