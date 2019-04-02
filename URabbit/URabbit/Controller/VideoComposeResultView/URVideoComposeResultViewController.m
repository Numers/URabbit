//
//  URVideoComposeResultViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2019/3/20.
//  Copyright © 2019 鲍利成. All rights reserved.
//

#import "URVideoComposeResultViewController.h"
#import "Composition.h"
#import "DraftTemplate.h"
#import "Resource.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>
#import <LGAlertView/LGAlertView.h>
#import "URDownloadAlertView.h"
#import "URUMShareManager.h"

#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "UIButton+Gradient.h"

@interface URVideoComposeResultViewController ()<URDownloadAlertViewProtocl>
{
    Resource *resource;
    NSString *movieURL;
    Composition *currentComposition;
    DraftTemplate *currentDraftTemplate;
    
    BOOL isInDraft;
    BOOL isInCompositon;
    
    URDownloadAlertView *shareAlertView;
}

@property(nonatomic, strong) UIButton *saveToPhotoButton;
@property(nonatomic, strong) UIButton *shareButton;
@property(nonatomic, strong) SelVideoPlayer *playView;
@end

@implementation URVideoComposeResultViewController
-(instancetype)initWithResource:(Resource *)m movieUrl:(NSString *)url composition:(Composition *)composition draftTemplate:(DraftTemplate *)draftTemplate isFromDraft:(BOOL)fromDraft
{
    self = [super init];
    if (self) {
        resource = m;
        movieURL = url;
        currentComposition = composition;
        currentDraftTemplate = draftTemplate;
        isInDraft = fromDraft;
        isInCompositon = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _saveToPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [_saveToPhotoButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [_saveToPhotoButton setTitleColor:[UIColor colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [_saveToPhotoButton setTitle:@"保存相册" forState:UIControlStateNormal];
    [_saveToPhotoButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_saveToPhotoButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, 44) colorArray:@[[UIColor colorFromHexString:@"#FED546"],[UIColor colorFromHexString:@"#FEBD43"]] percentageArray:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
    [self.view addSubview:_saveToPhotoButton];
    
    
    CGFloat playerHeight = SCREEN_HEIGHT -  ([UIDevice safeAreaBottomHeight] + 15 + 44 + 10 + 44 + 23 + [UIDevice safeAreaTopHeight] + 9);
    CGFloat playerWidth = playerHeight * resource.videoSize.width / resource.videoSize.height;
    if (playerWidth > SCREEN_WIDTH) {
        playerWidth = SCREEN_WIDTH - 10;
    }
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;
    configuration.supportedDoubleTap = YES;
    configuration.shouldAutorotate = YES;
    configuration.repeatPlay = NO;
    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
    configuration.videoGravity = SelVideoGravityResizeAspect;
    _playView = [[SelVideoPlayer alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - playerWidth)/2.0f, [UIDevice safeAreaTopHeight] + 9, playerWidth, playerHeight) configuration:configuration];
    [_playView.layer setCornerRadius:5.0f];
    [_playView.layer setMasksToBounds:YES];
    [self.view addSubview:_playView];
    
    [_playView setMovieUrl:[NSURL fileURLWithPath:movieURL]];
    
    [self makeConstraints];
}

-(void)makeConstraints
{
    [_saveToPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-[UIDevice safeAreaBottomHeight] - 15);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetting];
}

-(void)navigationBarSetting
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    [self.navigationItem setRightBarButtonItem:item];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        
        //当前视图控制器在栈中，故为push操作
        
        NSLog(@"push");
        
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        
        //当前视图控制器不在栈中，故为pop操作
        NSLog(@"pop");
        if (_playView) {
            [_playView _deallocPlayer];
        }
        
        if (!isInDraft && !isInCompositon) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:movieURL]) {
                [[NSFileManager defaultManager] removeItemAtPath:movieURL error:nil];
            }
        }
    }
}

-(void)alertPhotoAuthorization
{
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:@"有兔没有权限访问您的相册，请在“设置>隐私>照片>有兔>”中开启访问权限" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 10.0,*)) {
            if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }else{
            [[UIApplication sharedApplication] openURL:settingURL];
        }
        
    } cancelHandler:^(LGAlertView *alertView) {
        
    } destructiveHandler:^(LGAlertView *alertView) {
        
    }];
    [alertView setMessageFont:[UIFont systemFontOfSize:14]];
    [alertView setMessageTextColor:[UIColor colorFromHexString:@"#333333"]];
    [alertView setButtonsFont:[UIFont systemFontOfSize:14]];
    [alertView setButtonsTitleColor:[UIColor colorFromHexString:@"#333333"]];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:14]];
    [alertView setCancelButtonTitleColor:[UIColor colorFromHexString:@"#999999"]];
    [alertView showAnimated:YES completionHandler:^{
        
    }];
}

-(void)save
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        [self alertPhotoAuthorization];
        return;
    }
    [NSThread sleepForTimeInterval:0.2];
    [AppUtils trackMTAEventNo:@"5" pageNo:@"2" parameters:@{@"templetId":[NSString stringWithFormat:@"%ld",currentComposition.templateId]}];
    currentComposition.moviePath = movieURL;
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(movieURL)) {
        //保存相册核心代码
        UISaveVideoAtPathToSavedPhotosAlbum(movieURL, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
        [AppUtils showInfo:@"保存失败，请再试一次"];
    }
    else {
        NSLog(@"保存视频成功");
        [currentComposition bg_save];
        isInCompositon = YES;
        
        shareAlertView = [[URDownloadAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [shareAlertView setDesctiption:@"保存成功\n已保存到本地相册"];
        [shareAlertView setButtonTitle:@"立即分享"];
        [shareAlertView setContainerViewFrame:CGRectMake(0, 0, 280, 320)];
        [shareAlertView setLogoImage:[UIImage imageNamed:@"MovieImage"]];
        shareAlertView.delegate = self;
        [shareAlertView alert];
    }
}

#pragma -mark URDownloadAlertViewProtocl
-(void)didComfirm
{
    if (shareAlertView) {
        [shareAlertView dismiss:^{
            shareAlertView = nil;
            [self share];
        }];
    }
}

-(void)share{
    [AppUtils trackMTAEventNo:@"6" pageNo:@"2" parameters:@{@"templetId":[NSString stringWithFormat:@"%ld",currentComposition.templateId]}];
    if (![AppUtils isNullStr:movieURL]) {
        [[URUMShareManager shareManager] indirectShareVideo:[NSURL fileURLWithPath:movieURL]];
    }
}
@end
