//
//  ComposeNormalOperation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/9.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComposeRotationOperation.h"

@interface ComposeNormalOperation : NSOperation
-(instancetype)initWithSampleBufferRef:(CMSampleBufferRef)sampleBufferRef;
@property(nonatomic,weak) id<ComposeOperationProtocol> delegate;
@end
