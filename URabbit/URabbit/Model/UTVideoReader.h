//
//  UTVideoReader.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface UTVideoReader : NSObject
@property(nonatomic,retain) AVAssetReader *reader;
@property(nonatomic, retain) AVAssetTrack *track;
@property(nonatomic, retain) AVAsset *asset;
@property(nonatomic, retain) AVAssetReaderOutput *output;
-(instancetype)initWithUrl:(NSString *)url pixelFormatType:(OSType)formatType;;
-(CMSampleBufferRef)readVideoFrames:(int)frame;
-(void)removeVideoReader;
@end
