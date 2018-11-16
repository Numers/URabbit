//
//  Protocol.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#ifndef Protocol_h
#define Protocol_h
#import <AVFoundation/AVFoundation.h>
@protocol ComposeOperationProtocol <NSObject>
-(void)sendSampleBufferRef:(CMSampleBufferRef)sampleBufferRef frame:(NSInteger)frame;
-(void)sendPixelBufferRef:(CVPixelBufferRef)pixelBuffer frame:(NSInteger)frame;
-(void)sendImage:(UIImage *)image frame:(NSInteger)frame;
@end

#endif /* Protocol_h */
