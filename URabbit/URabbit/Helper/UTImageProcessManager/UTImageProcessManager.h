//
//  UTImageProcessManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/16.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface UTImageProcessManager : NSObject
+(instancetype)shareManager;
-(void *) imagePixelBufferFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
-(void)blendImage:(UIImage *)image1 withOtherImage:(UIImage *)image2;
@end
