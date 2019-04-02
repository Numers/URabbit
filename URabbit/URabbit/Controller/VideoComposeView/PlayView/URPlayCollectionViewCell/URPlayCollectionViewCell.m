//
//  URPlayCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URPlayCollectionViewCell.h"

@implementation URPlayCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, frame.size.height - 10)];
        [self addSubview:imageView];
    }
    return self;
}

-(void)setupCellWithImage:(UIImage *)image
{
    [imageView setImage:image];
}
@end
