//
//  Frame.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SnapshotMedia,SnapshotText;
@interface Frame : NSObject
@property(nonatomic, strong) NSMutableArray *snapshotMedias;
@property(nonatomic, strong) NSMutableArray *snapshotTexts;
@end
