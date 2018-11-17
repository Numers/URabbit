//
//  ComposeAnimationOperation.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeAnimationOperation.h"
#import "UIImage+FixImage.h"
#import "GPUImage.h"
#import "AxiosInfo.h"
#import "UTImageHanderManager.h"
@interface ComposeAnimationOperation()
{
    GPUImageFilter *filter;
}
@end
@implementation ComposeAnimationOperation
-(instancetype)initWithFrame:(NSInteger)frame axiosInfo:(AxiosInfo *)axiosInfo pixelSize:(CGSize)pixelSize
{
    self = [super init];
    if (self) {
        currentFrame = frame;
        currentPixelSize = pixelSize;
        currentAxiosInfo = axiosInfo;
        filter = [[UTImageHanderManager shareManager] filterWithFilterType:axiosInfo.filterType];
    }
    return self;
}

-(void)main
{
    @autoreleasepool {
        UIImage *whiteImage = [self imageWithColor:[UIColor whiteColor]];
        if (whiteImage) {
            if (filter) {
                [filter useNextFrameForImageCapture];
                currentAxiosInfo.filterImage = [filter imageByFilteringImage:currentAxiosInfo.image];
            }else{
                currentAxiosInfo.filterImage = currentAxiosInfo.image;
            }
            
            CVPixelBufferRef resultPixelBuffer = [[UTImageHanderManager shareManager] pixelBufferAdaptFromImage:whiteImage size:currentPixelSize];
            if ([self.delegate respondsToSelector:@selector(sendPixelBufferRef:frame:)]) {
                [self.delegate sendPixelBufferRef:resultPixelBuffer frame:currentFrame];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(sendPixelBufferRef:frame:)]) {
                [self.delegate sendPixelBufferRef:nil frame:currentFrame];
            }
        }
    }
}

-(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, currentPixelSize.width, currentPixelSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
