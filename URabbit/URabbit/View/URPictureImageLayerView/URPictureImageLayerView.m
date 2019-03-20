//
//  URPictureImageLayerView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URPictureImageLayerView.h"

@implementation URPictureImageLayerView
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    
    if ([self.delegate respondsToSelector:@selector(selectPictureWithMediaName:)]) {
        [self.delegate selectPictureWithMediaName:_mediaName];
    }
}
@end
