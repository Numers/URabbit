//
//  Frame.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Frame.h"

@implementation Frame
-(instancetype)init
{
    self = [super init];
    if (self) {
        _snapshotMedias = [NSMutableArray array];
        _snapshotTexts = [NSMutableArray array];
    }
    return self;
}
@end
