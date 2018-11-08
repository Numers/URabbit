//
//  ComposeStrategy.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class Material, UTVideoReader, AxiosInfo, Frame;
@protocol ComposeStrategyProtocl <NSObject>
-(void)composeImage:(UIImage *)image;
@end
@interface ComposeStrategy : NSObject
@property(nonatomic, weak) id<ComposeStrategyProtocl> delegate;
@property(nonatomic, strong) Material *material;
@property(nonatomic, strong) NSMutableArray<Frame *> *frames;
@property(nonatomic, strong) NSMutableArray<AxiosInfo *> *axiosInfos;
@property(nonatomic, strong) UTVideoReader *templateVideoReader;
@property(nonatomic, strong) NSMutableArray<UTVideoReader *> *maskVideoReaders;
-(instancetype)initWithMaterial:(Material *)m axiosInfos:(NSMutableArray *)axiosInfoList fps:(float)fps;
-(void)createVideoReader;
-(CMSampleBufferRef)readVideoFrames:(int)index;
-(void)cleanMemory;
-(void)removeVideoReader;
@end
