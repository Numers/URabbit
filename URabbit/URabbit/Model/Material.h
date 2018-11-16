//
//  Material.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    MaterialMask = 1,
    MaterialAnimation,
} MaterialType;
@interface Material : NSObject
@property(nonatomic) NSInteger totalFrames;
@property(nonatomic) CGSize videoSize;
@property(nonatomic, copy) NSString *templateVideo;
@property(nonatomic, copy) NSString *videoMusic;
@property(nonatomic) float fps;
@property(nonatomic) float seconds;
@property(nonatomic, strong) NSMutableArray *maskVideos;
@property(nonatomic, copy) NSString *templateImage;
@property(nonatomic) MaterialType materialType;
@property(nonatomic, copy) NSString *animationFile;
@property(nonatomic, copy) NSString *materialDirectoryPath;

-(instancetype)initWithFileUrl:(NSString *)fileUrl;
@end
