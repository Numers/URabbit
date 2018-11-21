//
//  ComposeStrategy.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Resource.h"
#import "UTVideoReader.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "Frame.h"

#import "ComposeRotationOperation.h"

#import "UTImageHanderManager.h"

#import "GPUImage.h"

@protocol ComposeStrategyProtocl <NSObject>
@optional
-(void)sendSampleBufferRef:(CMSampleBufferRef)sampleBufferRef frame:(NSInteger)frame;
-(void)sendPixelBufferRef:(CVPixelBufferRef)pixelBuffer frame:(NSInteger)frame;
-(void)sendResultImage:(UIImage *)image frame:(NSInteger)frame;
-(void)didFinishedVideoWriter;
@end
@interface ComposeStrategy : NSObject<ComposeOperationProtocol>
@property(nonatomic, weak) id<ComposeStrategyProtocl> delegate;
@property(nonatomic, strong) Resource *resource;
@property(nonatomic, strong) NSMutableArray *snapshotList;
@property(nonatomic, strong) NSMutableArray<Frame *> *frames;
@property(nonatomic, strong) UTVideoReader *fgVideoReader;
@property(nonatomic, strong) UTVideoReader *maskVideoReader;
@property(nonatomic, strong) UTVideoReader *maskBaseImageReader;
@property(nonatomic, strong) UTVideoReader *bgVideoReader;
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic) CGFloat currentFps;
-(instancetype)initWithResource:(Resource *)m snapshot:(NSMutableArray *)snapshots fps:(float)fps;
-(void)initlizeData;
-(void)createVideoReader;
-(void)readVideoFrames:(int)index;
-(void)cleanMemory;
@end
