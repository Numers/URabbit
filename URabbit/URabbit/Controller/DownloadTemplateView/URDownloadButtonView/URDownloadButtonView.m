//
//  URDownloadButtonView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URDownloadButtonView.h"
#import "UIButton+Gradient.h"

@implementation URDownloadButtonView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        vipDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 18)];
        [vipDescLabel setTextAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString *vipDesc = [AppUtils generateAttriuteStringWithStr:@"开通vip" WithColor:[UIColor colorFromHexString:ThemeHexColor] WithFont:[UIFont systemFontOfSize:13.0f]];
        NSAttributedString *appendString = [AppUtils generateAttriuteStringWithStr:@" 可免费制作会员专属模版" WithColor:[UIColor whiteColor] WithFont:[UIFont systemFontOfSize:13.0f]];
        [vipDesc appendAttributedString:appendString];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        [vipDesc addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, vipDesc.length)];
        [vipDescLabel setAttributedText:vipDesc];
        [vipDescLabel setCenter:CGPointMake(frame.size.width / 2.0f, 9)];
        [vipDescLabel setHidden:YES];
        [self addSubview:vipDescLabel];
        
        downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadButton setFrame:CGRectMake(0, 0, frame.size.width, 44)];
        [downloadButton setTitleColor:[UIColor colorFromHexString:@"#333333"] forState:UIControlStateNormal];
        [downloadButton setTitle:@"一键制作" forState:UIControlStateNormal];
        [downloadButton gradientButtonWithSize:CGSizeMake(frame.size.width, 44) colorArray:@[[UIColor colorFromHexString:@"#FED546"],[UIColor colorFromHexString:@"#FEBD43"]] percentageArray:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [downloadButton setEnabled:NO];
        NSString *percent = [NSString stringWithFormat:@"%.0f%%",progress * 100];
        NSString *buttonTitle = [NSString stringWithFormat:@"正在下载：%@ ",percent];
        [downloadButton setTitle:buttonTitle forState:UIControlStateNormal];
    });
}

-(void)setTitle:(NSString *)title isShowVipLabel:(BOOL)isShow
{
    [downloadButton setTitle:title forState:UIControlStateNormal];
    [vipDescLabel setHidden:!isShow];
}

-(void)setButtonTitle:(NSString *)title enable:(BOOL)enable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [downloadButton setEnabled:enable];
        [downloadButton setTitle:title forState:UIControlStateNormal];
    });
}
@end
