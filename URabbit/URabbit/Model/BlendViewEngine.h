//
//  BlendViewEngine.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface BlendViewEngine : GPUImageUIElement
{
    GPUImageOutput<GPUImageInput> *filter;
}
-(instancetype)initWithView:(UIView *)inputView;

-(CGImageRef)imageFromCurrentFramebuffer;
@end
