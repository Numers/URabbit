//
//  UTVideoComposeSuccessViewController.m
//  URabbit
//
//  Created by Mac on 2018/11/17.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTVideoComposeSuccessViewController.h"
#import "UTUMShareManager.h"
#import "UIButton+Gradient.h"

@interface UTVideoComposeSuccessViewController ()
{
    UIButton *shareButton;
    UIImageView *movieImageView;
    UILabel *successLabel;
    UILabel *saveLabel;
    
    NSURL *videoUrl;
    long currentTemplateId;
}
@end

@implementation UTVideoComposeSuccessViewController
-(instancetype)initWithVideoURL:(NSURL *)videoURL templateId:(long)templateId
{
    self = [super init];
    if (self) {
        videoUrl = videoURL;
        currentTemplateId = templateId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#121722"]];
    movieImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MovieImage"]];
    [self.view addSubview:movieImageView];
    successLabel = [[UILabel alloc] init];
    [successLabel setText:@"制作成功"];
    [successLabel setTextColor:[UIColor whiteColor]];
    [successLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [self.view addSubview:successLabel];
    
    saveLabel = [[UILabel alloc] init];
    [saveLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
    [saveLabel setText:@"已保存到本地相册"];
    [saveLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.view addSubview:saveLabel];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *titleString = [AppUtils generateAttriuteStringWithStr:@"立即分享" WithColor:[UIColor colorFromHexString:@"#333333"] WithFont:[UIFont systemFontOfSize:16]];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setAttributedTitle:titleString forState:UIControlStateNormal];
    [shareButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - 30, 44) colorArray:@[[UIColor colorFromHexString:@"#FED546"],[UIColor colorFromHexString:@"#FEBD43"]] percentageArray:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
    [shareButton.layer setCornerRadius:22.0f];
    [shareButton.layer setMasksToBounds:YES];
    [self.view addSubview:shareButton];
    [self makeConstraints];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetting];
}

-(void)navigationBarSetting
{
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    [rightItem1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem1];
}

-(void)makeConstraints
{
    [movieImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(-120);
    }];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(25));
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(movieImageView.bottom).offset(20);
    }];
    
    [saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.height.equalTo(@(20));
        make.top.equalTo(successLabel.bottom).offset(8);
    }];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-15);
        make.leading.equalTo(self.view).offset(15);
        make.height.equalTo(@(44));
        make.top.equalTo(saveLabel.bottom).offset([UIDevice adaptHeightWithIphone6Length:159.0f]);
    }];
}

-(void)complete{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)share{
    [AppUtils trackMTAEventNo:@"6" pageNo:@"2" parameters:@{@"templetId":[NSString stringWithFormat:@"\"%ld\"",currentTemplateId]}];
    [[UTUMShareManager shareManager] indirectShareVideo:videoUrl];
}
@end
