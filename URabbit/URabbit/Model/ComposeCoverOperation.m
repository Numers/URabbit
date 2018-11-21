//
//  ComposeCoverOperation.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeCoverOperation.h"
#import "Snapshot.h"
#import "GPUImage.h"
#import "UTImageHanderManager.h"
@interface ComposeCoverOperation()
{
    GPUImageTwoInputFilter *filter;
}
@end
@implementation ComposeCoverOperation
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef Frame:(NSInteger)frame snapshot:(Snapshot *)snapshot pixelSize:(CGSize)pixelSize
{
    self = [super init];
    if (self) {
        currentSnapshot = snapshot;
        currentTemplateSampleBufferRef = templateSampleBufferRef;
        currentFrame = frame;
        currentPixelSize = pixelSize;
        filter = [[GPUImageTwoInputFilter alloc] init];
    }
    return self;
}

-(void)main
{
    @autoreleasepool {
        if (currentTemplateSampleBufferRef) {
            void *templatePixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:currentTemplateSampleBufferRef];
            UIImage *templateImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:templatePixelBuffer size:currentPixelSize];
            GPUImagePicture *tempPic1 = [[GPUImagePicture alloc] initWithImage:templateImage];
            [tempPic1 addTarget:filter];
            [tempPic1 processImage];
            
            UIImage *resultImage = [filter imageByFilteringImage:currentSnapshot.snapshotImage];
            
            CVPixelBufferRef resultPixelBuffer = [[UTImageHanderManager shareManager] pixelBufferFromImage:resultImage size:currentPixelSize];
            void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
            memcpy(templatePixelBuffer, resultBaseAddress, 4*currentPixelSize.width*currentPixelSize.height);
            [tempPic1 removeTarget:filter];
            [filter removeOutputFramebuffer];
            
            if ([self.delegate respondsToSelector:@selector(sendSampleBufferRef:frame:)]) {
                [self.delegate sendSampleBufferRef:currentTemplateSampleBufferRef frame:currentFrame];
            }
            
        }else{
            if ([self.delegate respondsToSelector:@selector(sendSampleBufferRef:frame:)]) {
                [self.delegate sendSampleBufferRef:currentTemplateSampleBufferRef frame:currentFrame];
            }
        }
    }
}
@end
