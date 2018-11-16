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
#import "GPUImage.h"
#import "Material.h"
#import "AxiosInfo.h"
#import "AnimationInfo.h"
#import "AnimationManager.h"

//https://developer.apple.com/documentation/quartzcore/calayer/1410901-filters  layer添加滤镜
@implementation ComposeAnimation
-(instancetype)initWithMaterial:(Material *)material AxiosInfos:(NSMutableArray *)axiosInfos movieUrl:(NSString *)movieUrl
{
    self = [super init];
    if (self) {
        animationInfos = [NSMutableArray array];
        currentMaterial = material;
        currentMovieUrl = movieUrl;
        currentAxiosInfos = [NSMutableArray arrayWithArray:axiosInfos];
        [self initlizedAnimationInfos];
    }
    return self;
}

-(void)initlizedAnimationInfos
{
//    AnimationInfo *animationInfo = [[AnimationInfo alloc] init];
//    animationInfo.range = NSMakeRange(100, 25);
//    animationInfo.filterType = FilterGrayscale;
//    animationInfo.axiosIndex = 0;
//    animationInfo.animationType = AnimationTransformRight;
//
//    [animationInfos addObject:animationInfo];
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
    formatter.dateFormat = @"yyyyMMdd";
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
    
    for (AxiosInfo *axios in currentAxiosInfos) {
        switch (axios.animationType) {
            case AnimationTransformLeft:
            {
                CALayer *imageLayer = [CALayer layer];
                imageLayer.contents = (id)axios.filterImage.CGImage;
                [imageLayer setFrame:CGRectMake(-axios.imageWith, 0, axios.imageWith, axios.imageHeight)];
                CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(-axios.imageWith / 2 , videoSize.height / 2) toCenter:CGPointMake(videoSize.width / 2, videoSize.height / 2) startTime:axios.range.location / currentMaterial.fps duration:axios.range.length / currentMaterial.fps removeOnComplete:YES delegate:self];
                [imageLayer addAnimation:animation forKey:@"move-left-layer"];
                [parentLayer addSublayer:imageLayer];
            }
                break;
            case AnimationTransformRight:
            {
                CALayer *imageLayer = [CALayer layer];
                imageLayer.contents = (id)axios.filterImage.CGImage;
                [imageLayer setFrame:CGRectMake(axios.imageWith + videoSize.width, 0, axios.imageWith, axios.imageHeight)];
                CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(axios.imageWith / 2 + videoSize.width, videoSize.height / 2) toCenter:CGPointMake(videoSize.width / 2, videoSize.height / 2) startTime:axios.range.location / currentMaterial.fps duration:axios.range.length / currentMaterial.fps removeOnComplete:YES delegate:self];
                [imageLayer addAnimation:animation forKey:@"move-right-layer"];
                [parentLayer addSublayer:imageLayer];
            }
                break;
            case AnimationRotation:
            {
                CALayer *imageLayer = [CALayer layer];
                imageLayer.contents = (id)axios.filterImage.CGImage;
                [imageLayer setFrame:CGRectMake(axios.imageWith + videoSize.width, 0, axios.imageWith, axios.imageHeight)];
                CABasicAnimation *translateAnimation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(axios.imageWith / 2 + videoSize.width, videoSize.height / 2) toCenter:CGPointMake(videoSize.width / 2, videoSize.height / 2) startTime:axios.range.location / currentMaterial.fps duration:0.0 removeOnComplete:YES delegate:self];
                CABasicAnimation *translateMoveoutAnimation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(videoSize.width/2, videoSize.height / 2) toCenter:CGPointMake(axios.imageWith /2 + videoSize.width, videoSize.height / 2) startTime:axios.range.location / currentMaterial.fps + 1.5 duration:0 removeOnComplete:YES delegate:self];
                CABasicAnimation *rotationAnimation = [[AnimationManager shareManager] rotationAnimationWithStartAngle:0 endAngle:360 startTime:axios.range.location / currentMaterial.fps  duration:0 removeOnComplete:YES delegate:self];
                CAAnimationGroup *groupAnimation = [[AnimationManager shareManager] groupAnimationWithAnimations:@[translateAnimation,rotationAnimation,translateMoveoutAnimation] Duration:axios.range.length / currentMaterial.fps repeatCount:1];
                [imageLayer addAnimation:groupAnimation forKey:@"scale-layer"];
                [parentLayer addSublayer:imageLayer];
            }
                break;
            case AnimationScale:
            {
                CALayer *imageLayer = [CALayer layer];
                imageLayer.contents = (id)axios.filterImage.CGImage;
                [imageLayer setFrame:CGRectMake(axios.imageWith / 2 + videoSize.width, 0, axios.imageWith, axios.imageHeight)];
                CABasicAnimation *translateMoveInAnimation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(0, -axios.imageHeight / 2) toCenter:CGPointMake(videoSize.width/2, videoSize.height/2) startTime:axios.range.location / currentMaterial.fps duration:0.0001 removeOnComplete:NO delegate:nil];
                CABasicAnimation *translateMoveoutAnimation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(videoSize.width/2, videoSize.height/2) toCenter:CGPointMake(0, videoSize.height + axios.imageHeight) startTime:axios.range.location / currentMaterial.fps + 1.5 duration:0.0001 removeOnComplete:NO delegate:nil];
//                CABasicAnimation *translateMoveInAnimation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromRect:CGRectMake(-axios.imageWith / 2, 0, axios.imageWith, axios.imageHeight) toRect:CGRectMake(0, 0, axios.imageWith, axios.imageHeight) startTime:axios.range.location / currentMaterial.fps duration:1 removeOnComplete:NO delegate:nil];
//                CABasicAnimation *translateMoveoutAnimation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromRect:CGRectMake(0, 0, axios.imageWith, axios.imageHeight) toRect:CGRectMake(0, 0, axios.imageWith, axios.imageHeight) startTime:axios.range.location / currentMaterial.fps + 1.5 duration:2 removeOnComplete:NO delegate:self];
                CABasicAnimation *scaleAnimation = [[AnimationManager shareManager] scaleAnimationWithStartScale:1.0 endScale:2.0 startTime:axios.range.location / currentMaterial.fps duration:2 removeOnComplete:NO delegate:nil];
                
                [imageLayer addAnimation:translateMoveInAnimation forKey:nil];
                [imageLayer addAnimation:scaleAnimation forKey:nil];
                [imageLayer addAnimation:translateMoveoutAnimation forKey:nil];
                [parentLayer addSublayer:imageLayer];
            }
                break;
            case AnimationTrasformControlPoint:
            {
                CALayer *imageLayer = [CALayer layer];
                imageLayer.contents = (id)axios.filterImage.CGImage;
                [imageLayer setFrame:CGRectMake(axios.imageWith + videoSize.width, 0, axios.imageWith, axios.imageHeight)];
                CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimationWithControlPoints:0.895 point2:0.03 point3:0.685 point4:0.22 fromCenter:CGPointMake(-axios.imageWith/2, axios.imageHeight/2) toCenter:CGPointMake(videoSize.width/2, videoSize.height/2) startTime:axios.range.location / currentMaterial.fps duration:axios.range.length / currentMaterial.fps removeOnComplete:YES delegate:self];
                [imageLayer addAnimation:animation forKey:@"move-controlpoint-layer"];
                [parentLayer addSublayer:imageLayer];
            }
                break;
            default:
                break;
        }
    }
    
    for (AnimationInfo *info in animationInfos) {
        AxiosInfo *axiosInfo = [currentAxiosInfos objectAtIndex:info.axiosIndex];
        CALayer *imageLayer = [CALayer layer];
        imageLayer.contents = (id)axiosInfo.filterImage.CGImage;
        [imageLayer setFrame:CGRectMake(0, 0, axiosInfo.imageWith, axiosInfo.imageHeight)];
        switch (info.animationType) {
            case AnimationTransformRight:
            {
                [imageLayer setFrame:CGRectMake(axiosInfo.imageWith + videoSize.width, 0, axiosInfo.imageWith, axiosInfo.imageHeight)];
                CABasicAnimation *animation = [[AnimationManager shareManager] translateLineAnimation:kCAMediaTimingFunctionLinear fromCenter:CGPointMake(axiosInfo.imageWith / 2 + videoSize.width, videoSize.height / 2) toCenter:CGPointMake(videoSize.width / 2, videoSize.height / 2) startTime:info.range.location / currentMaterial.fps duration:info.range.length / currentMaterial.fps removeOnComplete:YES delegate:self];
                [imageLayer addAnimation:animation forKey:@"move-right-layer"];
                [parentLayer addSublayer:imageLayer];
            }
                break;
                
            default:
                break;
        }
    }
    
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
//    parentLayer.geometryFlipped = true;
    videoComp.frameDuration = CMTimeMake(1, currentMaterial.fps);
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
