//
//  ComposeAnimation.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeAnimation.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "UTImageHanderManager.h"
#import "GPUImage.h"
#import "Resource.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "AnimationForMedia.h"
#import "AnimationManager.h"
#import "SwitchAnimationManager.h"
#import "AnimationSwitch.h"

//https://developer.apple.com/documentation/quartzcore/calayer/1410901-filters  layer添加滤镜
@implementation ComposeAnimation
-(instancetype)initWithResource:(Resource *)resource snapshots:(NSMutableArray *)snapshots movieUrl:(NSString *)movieUrl
{
    self = [super init];
    if (self) {
        currentResource = resource;
        currentMovieUrl = movieUrl;
        currentSnapshots = [NSMutableArray arrayWithArray:snapshots];
    }
    return self;
}

-(void)addAnimationCompletionHandler:(void (^)(NSString* outPutURL, int code))handler{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVAsset *videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:currentMovieUrl] options:opts];
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *errorVideo = [NSError new];
    AVAssetTrack *assetVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo]firstObject];
    CMTime endTime = assetVideoTrack.asset.duration;
    BOOL bl = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, assetVideoTrack.asset.duration)
                                  ofTrack:assetVideoTrack
                                   atTime:kCMTimeZero error:&errorVideo];
    videoTrack.preferredTransform = assetVideoTrack.preferredTransform;
    NSLog(@"errorVideo:%ld%d",errorVideo.code,bl);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *outPutFileName = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",outPutFileName]];
    NSURL* outPutVideoUrl = [NSURL fileURLWithPath:myPathDocs];
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs]) {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    
    CGSize videoSize = [videoTrack naturalSize];
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    CALayer *frontLayer = [CALayer layer];
    CALayer *backLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    frontLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    backLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:frontLayer];
    [parentLayer addSublayer:backLayer];
    
    for (Snapshot *snapshot in currentSnapshots) {
        for (SnapshotMedia *media in snapshot.mediaList) {
            if (media.animationForMediaList.count > 0) {
                CALayer *imageLayer = [CALayer layer];
                imageLayer.contents = (id)media.resultImage.CGImage;
                CGFloat width = currentResource.videoSize.width * media.imageWidthPercent;
                CGFloat height = width * (media.resultImage.size.height / media.resultImage.size.width);
                [imageLayer setFrame:CGRectMake(- width/2, 0, width, height)];
                
                for (AnimationForMedia *animationForMedia in media.animationForMediaList) {
                    
                    CABasicAnimation *animation = [animationForMedia animationForMediaWithSize:currentResource.videoSize];
                    [imageLayer addAnimation:animation forKey:nil];
                }
                [frontLayer addSublayer:imageLayer];
            }
            
            if (media.animationForSwitchList.count > 0) {
                CALayer *imageLayer = [CALayer layer];
                imageLayer.contents = (id)media.resultImage.CGImage;
                CGFloat width = currentResource.videoSize.width * media.imageWidthPercent;
                CGFloat height = width * (media.resultImage.size.height / media.resultImage.size.width);
                [imageLayer setFrame:CGRectMake(- width/2, 0, width, height)];
                for (AnimationSwitch *animationSwitch in media.animationForSwitchList) {
                    NSMutableArray *animations = [[SwitchAnimationManager shareManager] animationsWithSwitchAnimationType:animationSwitch.type startTime:animationSwitch.range.location/currentResource.fps duration:animationSwitch.range.length / currentResource.fps size:currentResource.videoSize];
                    for (CABasicAnimation *basicAnimation in animations) {
                        [imageLayer addAnimation:basicAnimation forKey:nil];
                    }
                }
                [backLayer addSublayer:imageLayer];
            }
        }
    }
    
//    for (AxiosInfo *axios in currentAxiosInfos) {
//        CALayer *imageLayer = [CALayer layer];
//        imageLayer.contents = (id)axios.filterImage.CGImage;
//        [imageLayer setFrame:CGRectMake(-axios.imageWith, 0, axios.imageWith, axios.imageHeight)];
//        for (AnimationObject *animationObj in axios.animationObjects) {
//            CABasicAnimation *animation = [animationObj generateAnimation];
//            if (animation) {
//                [imageLayer addAnimation:animation forKey:nil];
//            }
//        }
//        [frontLayer addSublayer:imageLayer];
//    }
//
//    for (AnimationInfo *info in currentAnimationInfos) {
//        AxiosInfo *axiosInfo = [currentAxiosInfos objectAtIndex:info.axiosIndex];
//        GPUImageFilter *filter = [[UTImageHanderManager shareManager] filterWithFilterType:info.filterType];
//        [filter useNextFrameForImageCapture];
//        UIImage *filterImage = [filter imageByFilteringImage:axiosInfo.image];
//        CALayer *imageLayer = [CALayer layer];
//        imageLayer.contents = (id)filterImage.CGImage;
//        [imageLayer setFrame:CGRectMake(axiosInfo.imageWith + videoSize.width, 0, axiosInfo.imageWith, axiosInfo.imageHeight)];
//        for (AnimationObject *animationObj in info.animationObjects) {
//            CABasicAnimation *animation = [animationObj generateAnimation];
//            if (animation) {
//                [imageLayer addAnimation:animation forKey:nil];
//            }
//        }
//        [backLayer addSublayer:imageLayer];
//    }
//
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
//    parentLayer.geometryFlipped = true;
    videoComp.frameDuration = CMTimeMake(1, currentResource.fps);
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    AVMutableVideoCompositionInstruction* instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, endTime);
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObjects:layerInstruction, nil];
    videoComp.instructions = [NSArray arrayWithObject: instruction];
    
    
    AVAssetExportSession* exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=outPutVideoUrl;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComp;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            NSLog(@"输出视频地址:%@ andCode:%@",myPathDocs,exporter.error);
            handler(myPathDocs,(int)exporter.error.code);
        });
    }];
}

-(void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animation did stop");
}
@end
