//
//  FrameAxios.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/29.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnapshotMedia.h"
#import "SnapshotText.h"
#import "AnimationForMedia.h"
#import "AnimationForText.h"

@interface FrameAxios : NSObject
@property(nonatomic, strong) SnapshotMedia *snapshotMedia;
@property(nonatomic, strong) SnapshotText *snapshotText;
@property(nonatomic, strong) AnimationForMedia *animationForMedia;
@property(nonatomic, strong) AnimationForText *animationForText;
@end
