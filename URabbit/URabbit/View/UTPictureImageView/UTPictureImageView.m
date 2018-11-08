//
//  UTPictureImageView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPictureImageView.h"

@implementation UTPictureImageView
-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self setUserInteractionEnabled:NO];
        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:NO];
    }
    return self;
}
@end
