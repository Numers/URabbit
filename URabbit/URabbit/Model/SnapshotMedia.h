//
//  SnapshotMedia.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Media,Custom,AnimationSwitch,AnimationForMedia,UTPictureImageLayerView;
@interface SnapshotMedia : NSObject
@property(nonatomic, strong) Media *media;
@property(nonatomic, copy) NSString *mediaName;
@property(nonatomic) CGFloat centerXPercent;
@property(nonatomic) CGFloat centerYPercent;
@property(nonatomic) CGFloat imageWidthPercent;
@property(nonatomic) UIImage *demoImage;
@property(nonatomic, strong) UTPictureImageLayerView *demoImageView;

@property(nonatomic, strong) UIImage *resultImage;

@property(nonatomic, strong) NSMutableArray<AnimationForMedia *> *animationForMediaList;
@property(nonatomic, strong) NSMutableArray<AnimationSwitch *> *animationForSwitchList;

-(instancetype)initWithDictionary:(NSDictionary *)dic basePath:(NSString *)basePath withCustom:(Custom *)custom;
@end