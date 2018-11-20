//
//  Resource.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Resource.h"

@implementation Resource
-(instancetype)initWithDictionary:(NSDictionary *)dic basePath:(NSString *)basePath
{
    self = [super init];
    if (self) {
        NSString *music = [dic objectForKey:@"music"];
        if (music) {
            _music = [NSString stringWithFormat:@"%@/%@",basePath,music];
        }
        
        NSString *fgVideo = [dic objectForKey:@"fgVideo"];
        if (fgVideo) {
            _fgVideo = [NSString stringWithFormat:@"%@/%@",basePath,fgVideo];
        }
        
        NSString *maskVideo = [dic objectForKey:@"maskVideo"];
        if (maskVideo) {
            _maskVideo = [NSString stringWithFormat:@"%@/%@",basePath,maskVideo];
        }
        
        NSString *fgWebp = [dic objectForKey:@"fgWebp"];
        if (fgWebp) {
            _fgWebp = [NSString stringWithFormat:@"%@/%@",basePath,fgWebp];
        }
        
        NSString *maskBaseImage = [dic objectForKey:@"maskBaseImage"];
        if (maskBaseImage) {
            _maskBaseImage = [NSString stringWithFormat:@"%@/%@",basePath,maskBaseImage];
        }
        
        NSString *bgVideo = [dic objectForKey:@"bgVideo"];
        if (bgVideo) {
            _bgVideo = [NSString stringWithFormat:@"%@/%@",basePath,bgVideo];
        }
    }
    return self;
}
@end
