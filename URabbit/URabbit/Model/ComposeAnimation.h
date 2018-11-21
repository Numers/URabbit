//
//  ComposeAnimation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Resource;
@interface ComposeAnimation : NSObject<CAAnimationDelegate>
{
    Resource *currentResource;
    NSMutableArray *currentSnapshots;
    NSString *currentMovieUrl;
}
-(instancetype)initWithResource:(Resource *)resource snapshots:(NSMutableArray *)snapshots movieUrl:(NSString *)movieUrl;
-(void)addAnimationCompletionHandler:(void (^)(NSString* outPutURL, int code))handler;
@end
