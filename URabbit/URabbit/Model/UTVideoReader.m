//
//  UTVideoReader.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTVideoReader.h"

@implementation UTVideoReader
-(instancetype)initWithUrl:(NSString *)url pixelFormatType:(OSType)formatType;
{
    self = [super init];
    if (self) {
        [self createVideoReader:url pixelFormatType:formatType];
    }
    return self;
}

-(void)createVideoReader:(NSString *)url pixelFormatType:(OSType)formatType;
{
    if (![AppUtils isNullStr:url]) {
        NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        _asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:url] options:optDict];
        NSError *error;
        _reader = [[AVAssetReader alloc] initWithAsset:_asset error:&error];
        if (error) {
            NSLog(@"video reader create failed");
        }
        NSArray* videoTracks = [_asset tracksWithMediaType:AVMediaTypeVideo];
        _track = [videoTracks firstObject];
        NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:
                                                                    formatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        _output = [[AVAssetReaderTrackOutput alloc] initWithTrack:_track outputSettings:options];
        _output.alwaysCopiesSampleData = NO;
        if ([_reader canAddOutput:_output]) {
            [_reader addOutput:_output];
        }
        [_reader startReading];
    }
}

-(CMSampleBufferRef)readVideoFrames:(int)frame
{
    CMSampleBufferRef imagePixelBuffer = nil;
    if (_reader) {
        if ([_reader status] == AVAssetReaderStatusReading && _track.nominalFrameRate > 0) {
            imagePixelBuffer =  [_output copyNextSampleBuffer];
        }else{
            
            [_reader cancelReading];
        }
    }
    return imagePixelBuffer;
}

-(void)removeVideoReader
{
    if (_output) {
        _output = nil;
    }
    
    if (_track) {
        _track = nil;
    }
    
    if (_reader) {
        [_reader cancelReading];
        _reader = nil;
    }
}
@end
