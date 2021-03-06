//
//  ComposeCoverOperation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.h"
@class Snapshot;
@interface ComposeCoverOperation : NSOperation
{
    CMSampleBufferRef currentTemplateSampleBufferRef;
    NSInteger currentFrame;
    CGSize currentPixelSize;
    size_t bytesPerRow;
    Snapshot *currentSnapshot;
    UIImage *currentMaskImage;
}
@property(nonatomic,weak) id<ComposeOperationProtocol> delegate;
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef maskImage:(UIImage *)maskImage Frame:(NSInteger)frame snapshot:(Snapshot *)snapshot pixelSize:(CGSize)pixelSize;
@end
