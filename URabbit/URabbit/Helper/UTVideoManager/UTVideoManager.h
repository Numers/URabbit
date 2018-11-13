//
//  UTVideoManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GPUImageFilter;
@interface UTVideoManager : NSObject
+(instancetype)shareManager;
/**
 获取视频帧率
 
 @param videoPath 视频路径
 */
-(float)getFpsWithVideoPath:(NSString *)videoPath;


/**
 获取视频尺寸

 @param videoPath 视频路径
 @return 尺寸
 */
-(CGSize)getVideoSizeWithVideoPath:(NSString *)videoPath;
/**
 获取视频总帧数
 
 @param videoPath 视频路径
 @return 总帧数
 */
-(int)getTotalFramesWithVideoPath:(NSString *)videoPath;


/**
 压缩导出视频

 @param url 原视频url
 @param outputUrl 导出视频url
 */
- (void)compressVideo:(NSURL*)url outputUrl:(NSString *)outputUrl;


/**
 视频加滤镜

 @param inputUrl 输入视频url
 @param outputUrl 输出视频url
 @param filter 滤镜
 */
-(void)filterMovieWithInputUrl:(NSString *)inputUrl outputUrl:(NSString *)outputUrl videoSize:(CGSize)size filter:(GPUImageFilter *)filter completely:(void (^)(BOOL result))callback;

- (void)splitVideo:(NSURL *)fileUrl fps:(float)fps splitCompleteBlock:(void(^)(BOOL success, NSMutableArray *splitimgs))splitCompleteBlock ;
/**
 音视频合成

 @param moviePath 视频路径
 @param audioPath 音频路径
 @param callback 回调
 */
-(void)mergeMovie:(NSString *)moviePath withAudio:(NSString *)audioPath output:(NSString *)outputPath completely:(void (^)(void))callback;
@end
