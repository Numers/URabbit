//
//  UTDownloadAlertView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTDownloadAlertView.h"
#import "UIButton+Gradient.h"

@implementation UTDownloadAlertView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 265)];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        [backgroundView.layer setCornerRadius:5];
        [backgroundView.layer setMasksToBounds:YES];
        [backgroundView setCenter:CGPointMake(frame.size.width / 2.0f, frame.size.height / 2.0f)];
        [self addSubview:backgroundView];
        
        vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertVipImage"]];
        [backgroundView addSubview:vipImageView];
        
        descLabel = [[UILabel alloc] init];
        [descLabel setTextAlignment:NSTextAlignmentCenter];
        [descLabel setNumberOfLines:0];
        [self setDesctiption:@"该模板需要升级为VIP会员才能使用\n确定前往升级吗？"];
        [backgroundView addSubview:descLabel];
        
        comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [comfirmButton addTarget:self action:@selector(clickComfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString *comfirmTitle = [AppUtils generateAttriuteStringWithStr:@"确定" WithColor:[UIColor colorFromHexString:@"#333333"] WithFont:[UIFont systemFontOfSize:14.0f]];
        [comfirmButton setAttributedTitle:comfirmTitle forState:UIControlStateNormal];
        [comfirmButton gradientButtonWithSize:CGSizeMake(frame.size.width - 30, 44) colorArray:@[[UIColor colorFromHexString:@"#FED546"],[UIColor colorFromHexString:@"#FEBD43"]] percentageArray:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
        [comfirmButton.layer setCornerRadius:22.0f];
        [comfirmButton.layer setMasksToBounds:YES];
        [backgroundView addSubview:comfirmButton];
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setImage:[UIImage imageNamed:@"alertCloseImage"] forState:UIControlStateNormal];
        [backgroundView addSubview:closeButton];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(backgroundView);
        make.top.equalTo(backgroundView);
        make.width.equalTo(@(45));
        make.height.equalTo(@(45));
    }];
    
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(23);
        make.centerX.equalTo(backgroundView.mas_centerX);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vipImageView.bottom).offset(20);
        make.centerX.equalTo(backgroundView.mas_centerX);
    }];
    
    [comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-24);
        make.height.equalTo(@(44));
        make.leading.equalTo(backgroundView.leading).offset(27);
        make.trailing.equalTo(backgroundView.trailing).offset(-27);
    }];
}

-(void)setDesctiption:(NSString *)description
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 14.0f;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,[UIFont systemFontOfSize:14.0f],NSFontAttributeName,[UIColor colorFromHexString:@"#333333"],NSForegroundColorAttributeName, nil];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:description attributes:attributeDic];
    [descLabel setAttributedText:attributeString];
}

-(void)alert
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    backgroundView.layer.position = self.center;
    backgroundView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        backgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]];
    }];
}

-(void)createHiddenAnimation:(void (^)(void))callback
{
    backgroundView.layer.position = self.center;
    backgroundView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        backgroundView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [self removeFromSuperview];
        callback();
    }];
}

-(void)dismiss:(void (^)(void))callback
{
    [self createHiddenAnimation:callback];
}

-(void)clickComfirmBtn
{
    if ([self.delegate respondsToSelector:@selector(didComfirm)]) {
        [self.delegate didComfirm];
    }
}

-(void)clickCloseButton
{
    [self dismiss:^{
        
    }];
}
@end
