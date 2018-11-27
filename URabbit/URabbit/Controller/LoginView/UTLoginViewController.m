//
//  UTLoginViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTLoginViewController.h"
#import "UTLoginNetworkAPIManager.h"
#import "Member.h"
#import "AppStartManager.h"
#import "UTUMShareManager.h"
@interface UTLoginViewController ()
{
    NSTimer *timer;
    NSInteger currentTime;
}
@property(nonatomic, strong) IBOutlet UITextField *mobieTextField;
@property(nonatomic, strong) IBOutlet UITextField *validateCodeTextField;
@property(nonatomic, strong) IBOutlet UIButton *validateCodeButton;
@property(nonatomic, strong) IBOutlet UIButton *loginButton;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *layoutConstrait;
@end

@implementation UTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_loginButton.layer setCornerRadius:22];
    [_loginButton.layer setMasksToBounds:YES];
    [_loginButton setEnabled:NO];
    
    _layoutConstrait.constant = 99 + [UIDevice safeAreaTopHeight];
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
        [_loginButton setBackgroundColor:[UIColor colorFromHexString:@"#FF5756"]];
        [_loginButton setEnabled:YES];
    }else{
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
    [[UTLoginNetworkAPIManager shareManager] sendValidateCodeWithMobile:_mobieTextField.text callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if ([code integerValue] == 200) {
            [self beginTimer];
        }
    }];
}

-(IBAction)clickLoginBtn:(id)sender
{
    [AppUtils showLoadingInView:self.view];
    [[UTLoginNetworkAPIManager shareManager] checkValidateCodeWithMobile:_mobieTextField.text code:_validateCodeTextField.text callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if ([code integerValue] == 200) {
            [[UTLoginNetworkAPIManager shareManager] loginWithMobile:_mobieTextField.text checkCode:_validateCodeTextField.text callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
                [AppUtils hiddenLoadingInView:self.view];
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
        }else{
            [AppUtils hiddenLoadingInView:self.view];
        }
    }];
}

-(IBAction)clickLoginWithWeixin:(id)sender
{
    [[UTUMShareManager shareManager] getUserInfoForPlatform:UMSocialPlatformType_WechatSession complete:^(UMSocialUserInfoResponse *result) {
        
    }];
}

-(IBAction)clickLoginWithQQ:(id)sender
{
    [[UTUMShareManager shareManager] getUserInfoForPlatform:UMSocialPlatformType_QQ complete:^(UMSocialUserInfoResponse *result) {
        
    }];
}

-(IBAction)clickLoginWithWeibo:(id)sender
{
    [[UTUMShareManager shareManager] getUserInfoForPlatform:UMSocialPlatformType_Sina complete:^(UMSocialUserInfoResponse *result) {
        NSString *oid = result.uid;
        NSString *nickName = result.name;
        LoginPlatform type = LoginPlatformWeibo;
        NSString *portrait = result.iconurl;
        SexType sexType = UnknownSex;
        if ([@"男" isEqualToString:result.gender]) {
            sexType = Male;
        }
        
        if ([@"女" isEqualToString:result.gender]) {
            sexType = Female;
        }
        [AppUtils showLoadingInView:self.view];
        [[UTLoginNetworkAPIManager shareManager] loginPlatformWithOid:oid type:type nickName:nickName portrait:portrait gender:sexType callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
            [AppUtils hiddenLoadingInView:self.view];
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
    }];
}
@end
