//
//  ComposeNomalOperation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.h"
@interface ComposeNomalOperation : NSOperation
{
    CMSampleBufferRef currentTemplateSampleBufferRef;
    NSInteger currentFrame;
}
@property(nonatomic,weak) id<ComposeOperationProtocol> delegate;
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef frame:(NSInteger)frame;
@end
