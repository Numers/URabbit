//
//  BlendImageEngine.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/13.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface BlendImageEngine : GPUImagePicture
{
    GPUImageOutput<GPUImageInput> *filter;
}
-(instancetype)initWithImage:(UIImage *)newImageSource;
-(CGImageRef)imageFromCurrentFramebuffer;
@end
