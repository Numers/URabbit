//
//  URLoginViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URLoginViewController.h"
#import "URLoginNetworkAPIManager.h"
#import "UIButton+Gradient.h"
#import "Member.h"
#import "AppStartManager.h"
#import "URUMShareManager.h"
@interface URLoginViewController ()
{
    NSTimer *timer;
    NSInteger currentTime;
}
@property(nonatomic, strong) IBOutlet UITextField *mobieTextField;
@property(nonatomic, strong) IBOutlet UITextField *validateCodeTextField;
@property(nonatomic, strong) IBOutlet UIButton *validateCodeButton;
@property(nonatomic, strong) IBOutlet UIButton *loginButton;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *layoutConstrait;

@property(nonatomic, strong) IBOutlet UILabel *loginLabel;
@property(nonatomic, strong) IBOutlet UIButton *button1;
@property(nonatomic, strong) IBOutlet UILabel *label1;

@property(nonatomic, strong) IBOutlet UIButton *button2;
@property(nonatomic, strong) IBOutlet UILabel *label2;

@property(nonatomic, strong) IBOutlet UIButton *button3;
@property(nonatomic, strong) IBOutlet UILabel *label3;
@end

@implementation URLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_loginButton.layer setCornerRadius:22];
    [_loginButton.layer setMasksToBounds:YES];
    [_loginButton setEnabled:NO];
    
    _layoutConstrait.constant = 99 + [UIDevice safeAreaTopHeight];
    
    NSInteger i = 0;
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession])
    {
        if (i == 0) {
            [_button1 setHidden:NO];
            [_label1 setHidden:NO];
            [_button1 setImage:[UIImage imageNamed:@"wechatImage"] forState:UIControlStateNormal];
            [_button1 addTarget:self action:@selector(clickLoginWithWeixin) forControlEvents:UIControlEventTouchUpInside];
            [_label1 setText:@"微信登录"];
        }else if (i == 1){
            [_button2 setHidden:NO];
            [_label2 setHidden:NO];
            [_button2 setImage:[UIImage imageNamed:@"wechatImage"] forState:UIControlStateNormal];
            [_button2 addTarget:self action:@selector(clickLoginWithWeixin) forControlEvents:UIControlEventTouchUpInside];
            [_label2 setText:@"微信登录"];
        }else if (i == 2){
            [_button3 setHidden:NO];
            [_label3 setHidden:NO];
            [_button3 setImage:[UIImage imageNamed:@"wechatImage"] forState:UIControlStateNormal];
            [_button3 addTarget:self action:@selector(clickLoginWithWeixin) forControlEvents:UIControlEventTouchUpInside];
            [_label3 setText:@"微信登录"];
        }
        i++;
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ])
    {
        if (i == 0) {
            [_button1 setHidden:NO];
            [_label1 setHidden:NO];
            [_button1 setImage:[UIImage imageNamed:@"qqImage"] forState:UIControlStateNormal];
            [_button1 addTarget:self action:@selector(clickLoginWithQQ) forControlEvents:UIControlEventTouchUpInside];
            [_label1 setText:@"QQ登录"];
        }else if (i == 1){
            [_button2 setHidden:NO];
            [_label2 setHidden:NO];
            [_button2 setImage:[UIImage imageNamed:@"qqImage"] forState:UIControlStateNormal];
            [_button2 addTarget:self action:@selector(clickLoginWithQQ) forControlEvents:UIControlEventTouchUpInside];
            [_label2 setText:@"QQ登录"];
        }else if (i == 2){
            [_button3 setHidden:NO];
            [_label3 setHidden:NO];
            [_button3 setImage:[UIImage imageNamed:@"qqImage"] forState:UIControlStateNormal];
            [_button3 addTarget:self action:@selector(clickLoginWithQQ) forControlEvents:UIControlEventTouchUpInside];
            [_label3 setText:@"QQ登录"];
        }
        i++;
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]) {
        if (i == 0) {
            [_button1 setHidden:NO];
            [_label1 setHidden:NO];
            [_button1 setImage:[UIImage imageNamed:@"weiboImage"] forState:UIControlStateNormal];
            [_button1 addTarget:self action:@selector(clickLoginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
            [_label1 setText:@"微博登录"];
        }else if (i == 1){
            [_button2 setHidden:NO];
            [_label2 setHidden:NO];
            [_button2 setImage:[UIImage imageNamed:@"weiboImage"] forState:UIControlStateNormal];
            [_button2 addTarget:self action:@selector(clickLoginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
            [_label2 setText:@"微博登录"];
        }else if (i == 2){
            [_button3 setHidden:NO];
            [_label3 setHidden:NO];
            [_button3 setImage:[UIImage imageNamed:@"weiboImage"] forState:UIControlStateNormal];
            [_button3 addTarget:self action:@selector(clickLoginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
            [_label3 setText:@"微博登录"];
        }
        i++;
    }
    
    if (i == 0) {
        [_loginLabel setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginTimer
{
    currentTime = 60;
    [self stopTimer];
    
    [_validateCodeButton setEnabled:NO];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(beginCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}

-(void)stopTimer
{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
}

-(void)beginCount
{
    NSString *title = [NSString stringWithFormat:@"还剩%ld秒",currentTime];
    [_validateCodeButton setTitle:title forState:UIControlStateNormal];
    currentTime --;
    if (currentTime == 0) {
        [self stopTimer];
        [_validateCodeButton setEnabled:YES];
        [_validateCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

-(void)addTextFieldNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textDidChange:(NSNotification *)notify
{
    if (![AppUtils isNullStr:_mobieTextField.text] && ![AppUtils isNullStr:_validateCodeTextField.text]) {
        [_loginButton setTitleColor:[UIColor colorFromHexString:@"#333333"] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor clearColor]];
        [_loginButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - 30, 44) colorArray:@[[UIColor colorFromHexString:@"#FED546"],[UIColor colorFromHexString:@"#FEBD43"]] percentageArray:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
        [_loginButton setEnabled:YES];
    }else{
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor colorFromHexString:@"#D0D0D0"]];
        [_loginButton setEnabled:NO];
    }
}

-(void)removeTextFieldNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)clickValidateCodeBtn:(id)sender
{
    if ([AppUtils isNullStr:_mobieTextField.text]) {
        [AppUtils showInfo:@"请先输入手机号"];
        return;
    }
    
    if (![AppUtils isMobile:_mobieTextField.text]) {
        [AppUtils showInfo:@"请输入合法的手机号"];
        return;
    }
    [[URLoginNetworkAPIManager shareManager] sendValidateCodeWithMobile:_mobieTextField.text callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if ([code integerValue] == 200) {
            [self beginTimer];
        }
    }];
}

-(IBAction)clickLoginBtn:(id)sender
{
    [AppUtils showGIFHudProgress:@"" forView:self.view];
    [[URLoginNetworkAPIManager shareManager] loginWithMobile:_mobieTextField.text checkCode:_validateCodeTextField.text callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        [AppUtils hiddenGIFHud:self.view];
        if (data) {
            NSDictionary *memberInfo = (NSDictionary *)data;
            Member *member = [[Member alloc] initWithDictionary:memberInfo];
            [[AppStartManager shareManager] setMember:member];
            [AppUtils localUserDefaultsValue:@"1" forKey:KMY_AutoLogin];
            if ([self.delegate respondsToSelector:@selector(loginsuccess)]) {
                [self.delegate loginsuccess];
            }
        }
    }];
}

-(void)loginWithLoginPlatform:(LoginPlatform)type UMSocialUserInfoResponse:(UMSocialUserInfoResponse *)result
{
    NSString *oid = result.uid;
    NSString *nickName = result.name;
    NSString *portrait = result.iconurl;
    SexType sexType = UnknownSex;
    if ([@"男" isEqualToString:result.gender]) {
        sexType = Male;
    }
    
    if ([@"女" isEqualToString:result.gender]) {
        sexType = Female;
    }
    [AppUtils showGIFHudProgress:@"" forView:self.view];
    [[URLoginNetworkAPIManager shareManager] loginPlatformWithOid:oid type:type nickName:nickName portrait:portrait gender:sexType callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        [AppUtils hiddenGIFHud:self.view];
        if (data) {
            NSDictionary *memberInfo = (NSDictionary *)data;
            Member *member = [[Member alloc] initWithDictionary:memberInfo];
            [[AppStartManager shareManager] setMember:member];
            [AppUtils localUserDefaultsValue:@"1" forKey:KMY_AutoLogin];
            if ([self.delegate respondsToSelector:@selector(loginsuccess)]) {
                [self.delegate loginsuccess];
            }
        }
    }];
}

-(IBAction)clickProtocolBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gotoProtocolView)]) {
        [self.delegate gotoProtocolView];
    }
}

-(void)clickLoginWithWeixin
{
    [[URUMShareManager shareManager] getUserInfoForPlatform:UMSocialPlatformType_WechatSession complete:^(UMSocialUserInfoResponse *result) {
        [self loginWithLoginPlatform:LoginPlatformWechat UMSocialUserInfoResponse:result];
    }];
}

-(void)clickLoginWithQQ
{
    [[URUMShareManager shareManager] getUserInfoForPlatform:UMSocialPlatformType_QQ complete:^(UMSocialUserInfoResponse *result) {
        [self loginWithLoginPlatform:LoginPlatformQQ UMSocialUserInfoResponse:result];
    }];
}

-(void)clickLoginWithWeibo
{
    [[URUMShareManager shareManager] getUserInfoForPlatform:UMSocialPlatformType_Sina complete:^(UMSocialUserInfoResponse *result) {
        [self loginWithLoginPlatform:LoginPlatformWeibo UMSocialUserInfoResponse:result];
    }];
}
@end
