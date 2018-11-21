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
#import "UTTextLabel.h"
#import "Text.h"
#import "UTPictureImageLayerView.h"
#import "UTTplImageLayerView.h"

#import "UTKeyboardTextFieldManager.h"
@interface UTPhotoEditNotMoveView()<UTTextLabelProtocol,UTPictureImageLayerViewProtocol>
{
    Snapshot *currentSnapshot;
    NSString *selectMediaName;
}
@end
@implementation UTPhotoEditNotMoveView
-(instancetype)initWithSnapshot:(Snapshot *)snapshot frame:(CGRect)frame
{
    self = [super initWithSnapshot:snapshot frame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        currentSnapshot = snapshot;
        for (SnapshotMedia *media in snapshot.mediaList) {
            CGFloat width = self.frame.size.width * media.imageWidthPercent;
            CGFloat height = width * media.demoImage.size.height / media.demoImage.size.width;
            [media.demoImageView setFrame:CGRectMake(0, 0, width, height)];
            media.demoImageView.delegate = self;
            CGPoint currentCenterPoint = CGPointMake(frame.size.width * media.centerXPercent, frame.size.height * media.centerYPercent);
            [media.demoImageView setImage:media.demoImage];
            [media.demoImageView setCenter:currentCenterPoint];
            if (self.templateImageView) {
                [self insertSubview:media.demoImageView belowSubview:self.templateImageView];
            }else{
                [self addSubview:media.demoImageView];
            }
            
        }
        
        for(SnapshotText *snapshotText in snapshot.textList){
            CGFloat width = frame.size.width * snapshotText.widthPercent;
            CGFloat height = frame.size.height * snapshotText.heightPercent;
            CGPoint center = CGPointMake(frame.size.width * snapshotText.centerXPercent, frame.size.height * snapshotText.centerYPercent);
            [snapshotText.textLabel setFrame:CGRectMake(0, 0, width, height)];
            snapshotText.textLabel.delegate = self;
            CGFloat fontsize = snapshotText.text.fontSize * (frame.size.width / snapshot.videoSize.width);
            [snapshotText.textLabel setFont:[UIFont systemFontOfSize:fontsize]];
            [snapshotText.textLabel setCenter:center];
            if (height < 30) {
                [snapshotText.textLabel setVerticalAlignment:VerticalAlignmentDefault];
            }
            if (self.templateImageView) {
                [self insertSubview:snapshotText.textLabel aboveSubview:self.templateImageView];
            }else{
                [self addSubview:snapshotText.textLabel];
            }
        }
    }
    return self;
}

-(void)setPictureImage:(UIImage *)image
{
    for (SnapshotMedia *media in currentSnapshot.mediaList){
        if ([media.mediaName isEqualToString:selectMediaName]) {
            [media changePicture:image];
        }
    }
}

#pragma -mark UTTextLabelProtocol
-(void)didSelectTextLabelWithName:(NSString *)name content:(NSString *)content
{
    [[UTKeyboardTextFieldManager shareManager] showKeyboardTextFieldWithText:content callback:^(NSString *text) {
        for(SnapshotText *snapshotText in currentSnapshot.textList){
            if ([snapshotText.textName isEqualToString:name]) {
                [snapshotText changeText:text];
            }
        }
    }];
}

#pragma -mark UTPictureImageLayerViewProtocol
-(void)selectPictureWithMediaName:(NSString *)mediaName
{
    selectMediaName = mediaName;
    if ([self.delegate respondsToSelector:@selector(openImagePickerView)]) {
        [self.delegate openImagePickerView];
    }
}
@end
