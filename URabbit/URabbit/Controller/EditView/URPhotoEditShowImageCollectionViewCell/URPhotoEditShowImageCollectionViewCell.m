//
//  URPhotoEditShowImageCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URPhotoEditShowImageCollectionViewCell.h"
#import "Snapshot.h"

@implementation URPhotoEditShowImageCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:1.0f];
        [self.layer setMasksToBounds:YES];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0.5, frame.size.width - 1, frame.size.height - 1)];
        [self addSubview:imageView];
        indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 16, 0, 16, 11)];
        [indexLabel setBackgroundColor:[UIColor colorFromHexString:@"#FFDE44"]];
        [indexLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [indexLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [indexLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:indexLabel];
    }
    return self;
}

-(void)setupCellWithSnapshot:(Snapshot *)info index:(NSInteger)index
{
    snapshot = info;
//    UIImage *image = [UIImage imageWithContentsOfFile:info.foregroundImage];
//    [imageView setImage:image];
    NSString *indexString = [NSString stringWithFormat:@"%ld",index];
    [indexLabel setText:indexString];
}

-(void)setPictureImage:(UIImage *)image
{
    if (image) {
        [imageView setImage:image];
    }
}

-(void)setIsSelected:(BOOL)selected
{
    isSelected = selected;
    if (isSelected) {
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorFromHexString:@"#FFDE44"].CGColor;
    }else{
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorFromHexString:@"#F5F5F5"].CGColor;
    }
    [self setNeedsDisplay];
}
@end
