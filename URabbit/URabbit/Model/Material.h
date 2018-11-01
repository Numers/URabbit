//
//  Material.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Material : NSObject
@property(nonatomic) NSInteger totalFrames;
@property(nonatomic, copy) NSString *templateVideo;
@property(nonatomic, copy) NSString *videoMusic;
@property(nonatomic, strong) NSMutableArray *maskVideos;
@property(nonatomic, copy) NSString *templateImage;
@property(nonatomic, copy) NSString *axiosInfoFile;

-(instancetype)initWithFileUrl:(NSString *)fileUrl;
@end
