//
//  UTPhotoEditNotMoveView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditNotMoveView.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "SnapshotText.h"
#import "Text.h"
#import "UTPictureImageLayerView.h"
#import "UTTplImageLayerView.h"
@implementation UTPhotoEditNotMoveView
-(instancetype)initWithSnapshot:(Snapshot *)snapshot frame:(CGRect)frame
{
    self = [super initWithSnapshot:snapshot frame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        for (SnapshotMedia *media in snapshot.mediaList) {
            CGFloat width = self.frame.size.width * media.imageWidthPercent;
            CGFloat height = width * media.demoImage.size.height / media.demoImage.size.width;
            [media.demoImageView setFrame:CGRectMake(0, 0, width, height)];
            CGPoint currentCenterPoint = CGPointMake(frame.size.width * media.centerXPercent, frame.size.height * media.centerYPercent);
            [media.demoImageView setImage:media.demoImage];
            [media.demoImageView setCenter:currentCenterPoint];
            [self addSubview:media.demoImageView];
        }
        
        for(SnapshotText *snapshotText in snapshot.textList){
            
        }
    }
    return self;
}
@end
