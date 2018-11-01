//
//  ComposeStrategyManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeStrategyManager.h"
@implementation ComposeStrategyManager
+(instancetype)shareInstance
{
    static ComposeStrategyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ComposeStrategyManager alloc] init];
    });
    return manager;
}

-(void)mixMaskAlphaWithImageBuffer:(void *)imageBuffer1 secondImageBuffer:(void *)imageBuffer2 size:(CGSize)size algorithm:(MaskAlgorithmType)type
{
    unsigned long pixelNum = size.width * size.height;
    uint32_t* pCurPtr = imageBuffer2;
    uint32_t* bCurPtr = imageBuffer1;
    if (type == MaskAlgorithmMix) {
        for (unsigned long i = 0; i < pixelNum; i++, pCurPtr++,bCurPtr++)
        {
            int pAlpha = ((*pCurPtr >> 24) & 0xff) ;
            int bAlpha = ((*bCurPtr >> 24) & 0xff) ;
            uint8_t* btr = (uint8_t*)bCurPtr;
            btr[0] = pAlpha & bAlpha;
        }
    }
}

-(void)attachAlphaToImageBuffer:(void *)imageBuffer withMaskBuffer:(void *)maskBuffer size:(CGSize)size
{
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    unsigned long pixelNum = size.width * size.height;
    uint32_t* pCurPtr = maskBuffer;
    uint32_t* bCurPtr = imageBuffer;
    for (unsigned long i = 0; i < pixelNum; i++, pCurPtr++,bCurPtr++)
    {
        int alpha = ((*pCurPtr >> 24) & 0xff) ;
//        NSLog(@"alpha is %d",alpha);
        uint8_t* btr = (uint8_t*)bCurPtr;
        btr[0] = alpha;
//        NSLog(@"b is %d, g is %d, r is %d, a is %d",btr[0], btr[1],btr[2],btr[3]);
    }
}
@end
