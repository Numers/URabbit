//
//  UTVideoManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTVideoManager.h"
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"
@interface UTVideoManager()
{
    GPUImageMovie *movieFile;
    GPUImageMovieWriter *movieWriter;
}
@end
@implementation UTVideoManager
+(instancetype)shareManager
{
    static UTVideoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTVideoManager alloc] init];
    });
    return manager;
}

//获取视频帧率
-(float)getFpsWithVideoPath:(NSString *)videoPath
{
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:optDict];
    NSArray *videoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *assertTrack = [videoTracks firstObject];
    return assertTrack.nominalFrameRate;
}

//获取视频总帧数
-(int)getTotalFramesWithVideoPath:(NSString *)videoPath
{
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:optDict];
    NSArray *videoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *assertTrack = [videoTracks firstObject];
    CMTime cmtime = videoAsset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    int totalFrames = durationSeconds * assertTrack.nominalFrameRate; //获得视频总帧数
    return totalFrames;
}

#pragma mark ————————— 压缩视频 —————————————
- (void)compressVideo:(NSURL*)url outputUrl:(NSString *)outputUrl{
    NSLog(@"压缩");
    //使用媒体工具(AVFoundation框架下的)
    //Asset 资源可以是图片音频视频
    AVAsset *asset=[AVAsset assetWithURL:url];
    //设置压缩的格式
    AVAssetExportSession
    *session=[AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];//mediumquality:中等质量
    //设置导出路径
    NSString *path = outputUrl;
    //创建文件管理类导出失败,删除已经导出的
    NSFileManager *manager = [[NSFileManager alloc] init];
    //删除已经存在的
    [manager removeItemAtPath:path error:NULL];
    //设置到处路径
    session.outputURL=[NSURL fileURLWithPath:path];
    //设置输出文件的类型
    session.outputFileType = AVFileTypeMPEG4;
    //开辟子线程处理耗时操作
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"导出完成!路径:%@",path);
    }];
}

-(void)filterMovieWithInputUrl:(NSString *)inputUrl outputUrl:(NSString *)outputUrl videoSize:(CGSize)size filter:(GPUImageFilter *)filter completely:(void (^)(BOOL result))callback
{
    NSURL *inputURL = [NSURL fileURLWithPath:inputUrl];
    movieFile = [[GPUImageMovie alloc] initWithURL:inputURL];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = NO;
    [movieFile addTarget:filter];
    
    unlink([outputUrl UTF8String]);
    if([[NSFileManager defaultManager] fileExistsAtPath:outputUrl])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outputUrl error:nil];
    }
    NSURL *outputURL = [NSURL fileURLWithPath:outputUrl];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:outputURL size:size];
    [filter addTarget:movieWriter];
    
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    __weak typeof(movieWriter) weakWriter = movieWriter;
    [movieWriter setCompletionBlock:^{
        [filter removeTarget:weakWriter];
        [weakWriter finishRecording];
        callback(YES);
    }];
    
    [movieWriter setFailureBlock:^(NSError *error) {
        NSLog(@"合成失败 error=%@",error.description);
        [filter removeTarget:weakWriter];
        [weakWriter finishRecording];
        callback(NO);
    }];
}

-(void)mergeMovie:(NSString *)moviePath withAudio:(NSString *)audioPath output:(NSString *)outputPath completely:(void (^)(void))callback
{
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    // 时间起点
    CMTime nextClistartTime = kCMTimeZero;
    // 创建可变的音视频组合
    AVMutableComposition *comosition = [AVMutableComposition composition];
    // 视频采集
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:movieURL options:nil];
    // 视频时间范围
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
    AVMutableCompositionTrack *videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // 视频采集通道
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    //  把采集轨道数据加入到可变轨道之中
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
    // 声音采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    // 因为视频短这里就直接用视频长度了,如果自动化需要自己写判断
    CMTimeRange audioTimeRange = videoTimeRange;
    // 音频通道
    AVMutableCompositionTrack *audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // 音频采集通道
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    // 加入合成轨道之中
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];

    AVAssetExportSession
    *session=[AVAssetExportSession exportSessionWithAsset:comosition presetName:AVAssetExportPresetMediumQuality];//mediumquality:中等质量
    unlink([outputPath UTF8String]);
    if([[NSFileManager defaultManager] fileExistsAtPath:outputPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    //设置到处路径
    session.outputURL = outputURL;
    //设置输出文件的类型
    session.outputFileType = AVFileTypeMPEG4;
    //开辟子线程处理耗时操作
    [session exportAsynchronouslyWithCompletionHandler:^{
        callback();
    }];
}
@end
