//
//  ComposeAnimationOperation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.h"
@interface ComposeAnimationOperation : NSOperation
{
    NSInteger currentFrame;
    CGSize currentPixelSize;
}
@property(nonatomic,weak) id<ComposeOperationProtocol> delegate;
-(instancetype)initWithFrame:(NSInteger)frame pixelSize:(CGSize)pixelSize;
@end
