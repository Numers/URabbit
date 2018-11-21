//
//  Snapshot.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SnapshotMedia,SnapshotText,Custom;
@interface Snapshot : NSObject
@property(nonatomic, copy) NSString *foregroundImage;
@property(nonatomic) CGSize videoSize;
@property(nonatomic, strong) UIImage *snapshotImage;
@property(nonatomic, strong) NSMutableArray<SnapshotMedia *> *mediaList;
@property(nonatomic, strong) NSMutableArray<SnapshotText *> *textList;

-(instancetype)initWithDictionary:(NSDictionary *)dic basePath:(NSString *)basePath custom:(Custom *)custom;
@end
