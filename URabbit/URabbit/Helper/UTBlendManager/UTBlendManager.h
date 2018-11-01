//
//  UTBlendManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTBlendManager : NSObject
+(instancetype)shareManager;

-(UIImage *)imageRefWithView:(UIView *)view;
@end
