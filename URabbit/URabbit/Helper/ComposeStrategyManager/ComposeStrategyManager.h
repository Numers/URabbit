//
//  ComposeStrategyManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AxiosInfo.h"

@interface ComposeStrategyManager : NSObject
+(instancetype)shareInstance;
-(void)mixMaskAlphaWithImageBuffer:(void *)imageBuffer1 secondImageBuffer:(void *)imageBuffer2 size:(CGSize)size algorithm:(MaskAlgorithmType)type;
-(void)attachAlphaToImageBuffer:(void *)imageBuffer withMaskBuffer:(void *)maskBuffer size:(CGSize)size;
@end
