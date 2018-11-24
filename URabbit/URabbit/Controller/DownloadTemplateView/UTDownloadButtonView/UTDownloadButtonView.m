//
//  UTDownloadButtonView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTDownloadButtonView.h"
#import "UIButton+Gradient.h"

@implementation UTDownloadButtonView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadButton setFrame:CGRectMake(0, 0, frame.size.width - 30, 44)];
        [downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [downloadButton setTitle:@"一键制作" forState:UIControlStateNormal];
//        [downloadButton setBackgroundColor:[UIColor redColor]];
        [downloadButton gradientButtonWithSize:CGSizeMake(frame.size.width - 30, 44) colorArray:@[[UIColor colorFromHexString:@"#FF5756"],[UIColor colorFromHexString:@"#E11F63"]] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromLeftToRight];
        [downloadButton.layer setCornerRadius:22.0f];
        [downloadButton.layer masksToBounds];
        [downloadButton addTarget:self action:@selector(clickDownloadButton) forControlEvents:UIControlEventTouchUpInside];
        [downloadButton setCenter:CGPointMake(frame.size.width / 2.0f, frame.size.height / 2.0f)];
        [self addSubview:downloadButton];
    }
    return self;
}

-(void)clickDownloadButton
{
    if ([self.delegate respondsToSelector:@selector(beginDownload)]) {
        [self.delegate beginDownload];
    }
}

-(void)setProgress:(CGFloat)progress
{
    NSString *percent = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    NSString *buttonTitle = [NSString stringWithFormat:@"%@ 正在下载",percent];
    [downloadButton setTitle:buttonTitle forState:UIControlStateNormal];
}

-(void)setButtonTitle:(NSString *)title
{
    [downloadButton setTitle:title forState:UIControlStateNormal];
}
@end
