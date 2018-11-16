//
//  ComposeAnimation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Material;
@interface ComposeAnimation : NSObject<CAAnimationDelegate>
{
    Material *currentMaterial;
    NSMutableArray *animationInfos;
    NSMutableArray *currentAxiosInfos;
    NSString *currentMovieUrl;
}
-(instancetype)initWithMaterial:(Material *)material AxiosInfos:(NSMutableArray *)axiosInfos movieUrl:(NSString *)movieUrl;
-(void)addAnimationCompletionHandler:(void (^)(NSString* outPutURL, int code))handler;
@end
