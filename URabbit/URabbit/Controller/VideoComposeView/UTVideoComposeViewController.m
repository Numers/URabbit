//
//  UTVideoComposeViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTVideoComposeViewController.h"
#import "Resource.h"
#import "FilterInfo.h"
#import "MusicInfo.h"
#import "GPUImage.h"

#import "UTPlayView.h"
#import "UTSelectView.h"
#import "UTSegmentView.h"

#import "UTVideoManager.h"
#import "UTImageHanderManager.h"
#import "UTVideoComposeNetworkAPIManager.h"
#import "NetWorkManager.h"
#import "UTVideoComposeSuccessViewController.h"

#import "Composition.h"
#import "DraftTemplate.h"
#import "UINavigationController+NavigationBar.h"

#import <Photos/PHPhotoLibrary.h>
#import <LGAlertView/LGAlertView.h>

@interface UTVideoComposeViewController ()<UTPlaySubViewProtocol,UTSelectViewProtocol>
{
    Resource *resource;
    NSString *movieURL;
    NSString *audioURL;
    Composition *currentComposition;
    DraftTemplate *currentDraftTemplate;
    
    GPUImageView *imageView;
    GPUImageMovie *movieFile;
    AVPlayer *player;
    GPUImageOutput<GPUImageInput> *filter;
    FilterType currentFilterType;
    
    AVAudioPlayer *audioPlayer;
    
    UTPlayView *playView;
    UTSelectView *selectView;
    UTSegmentView *segmentView;
    CMTime pausedTime;
    float duration;
    
    BOOL isInDraft;
    BOOL isInCompositon;
    
    BOOL isSaving;
}
@end

@implementation UTVideoComposeViewController
-(instancetype)initWithResource:(Resource *)m movieUrl:(NSString *)url composition:(Composition *)composition draftTemplate:(DraftTemplate *)draftTemplate isFromDraft:(BOOL)fromDraft
{
    self = [super init];
    if (self) {
        resource = m;
        movieURL = url;
        audioURL = resource.music;
        currentComposition = composition;
        currentDraftTemplate = draftTemplate;
        isInDraft = fromDraft;
        isSaving = NO;
        isInCompositon = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#121722"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    selectView = [[UTSelectView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - [UIDevice safeAreaBottomHeight] - 106, SCREEN_WIDTH, 106)];
    selectView.delegate = self;
    [self.view addSubview:selectView];
    
    segmentView = [[UTSegmentView alloc] init];
    [segmentView setEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 0)];
    __weak typeof(selectView) weakSelectView = selectView;
    [segmentView setSelectIndexBlock:^(NSInteger index) {
        [weakSelectView showViewWithIndex:index];
    }];
    [self.view addSubview:segmentView];
    [segmentView addTitles:@[@"滤镜",@"音乐"]];
    
    playView = [[UTPlayView alloc] init];
    playView.delegate = self;
    [self.view addSubview:playView];
    
    imageView = [[GPUImageView alloc] init];
    [self.view addSubview:imageView];
    [self makeConstraints];
    
    [self setCurrentFilterType:FilterNormal];
    [self filterProcessingBlock];
    pausedTime = CMTimeMake(0, resource.fps);
    
    [self splitImages];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetting];
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
        if (!isInDraft) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:movieURL]) {
                [[NSFileManager defaultManager] removeItemAtPath:movieURL error:nil];
            }
        }
        
        if (!isInCompositon) {
            if (currentComposition.moviePath) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:currentComposition.moviePath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:currentComposition.moviePath error:nil];
                }
            }
        }
        
        if (player && player.rate != 0.0f ) {
            player.rate = 0.0f;
            player = nil;
        }
        
        if (movieFile) {
            [movieFile cancelProcessing];
            movieFile = nil;
        }
        
        if (audioPlayer && [audioPlayer isPlaying]) {
            [audioPlayer stop];
            audioPlayer = nil;
        }
    }
}

-(void)makeConstraints
{
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(selectView.top);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@(39));
    }];
    
    [playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(segmentView.top).offset(-11);
        make.height.equalTo(@(53));
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([UIDevice safeAreaTopHeight] + 9);
        make.bottom.equalTo(playView.top).offset(-23).priorityHigh();
        make.width.equalTo(imageView.mas_height).multipliedBy(resource.videoSize.width / resource.videoSize.height);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (imageView.frame.size.width > SCREEN_WIDTH) {
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset([UIDevice safeAreaTopHeight] + 9);
            make.bottom.equalTo(playView.top).offset(-23).priorityHigh();
            make.centerX.equalTo(self.view.mas_centerX);
            make.leading.equalTo(self.view).offset(5);
        }];
        [imageView updateConstraintsIfNeeded];
    }
}

-(void)navigationBarSetting
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setTranslucentView];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [rightItem1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"存草稿" style:UIBarButtonItemStylePlain target:self action:@selector(saveInDraft)];
    [rightItem2 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#999999"]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItems:@[rightItem1,rightItem2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (isSaving) {
        return;
    } else {
        isSaving = YES;
    }
    [self stopVideo];
    if (movieFile) {
        [movieFile endProcessing];
    }
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        [self alertPhotoAuthorization];
        return;
    }
    [NSThread sleepForTimeInterval:0.2];
    [AppUtils trackMTAEventNo:@"5" pageNo:@"2" parameters:@{@"templetId":[NSString stringWithFormat:@"\"%ld\"",currentComposition.templateId]}];
    [AppUtils showGIFHudProgress:@"" forView:self.view];
    if (audioURL) {
        NSString *tempVideoPath = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId identify:@"merge"];
        
        [[UTVideoManager shareManager] mergeMovie:movieURL withAudio:audioURL output:tempVideoPath completely:^{
            GPUImageOutput<GPUImageInput> *movieFilter = [[UTImageHanderManager shareManager] filterWithFilterType:currentFilterType];
            NSString *videoCompeletelyPath = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId identify:@"complete"];
            [[UTVideoManager shareManager] filterMovieWithInputUrl:tempVideoPath outputUrl:videoCompeletelyPath videoSize:resource.videoSize filter:movieFilter completely:^(BOOL result) {
                if (result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [AppUtils hiddenGIFHud:self.view];
                        currentComposition.moviePath = videoCompeletelyPath;
                        isSaving = NO;
                        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoCompeletelyPath)) {
                            //保存相册核心代码
                            UISaveVideoAtPathToSavedPhotosAlbum(videoCompeletelyPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                        }
                    });
                }
            }];
        }];
    }else{
        GPUImageOutput<GPUImageInput> *movieFilter = [[UTImageHanderManager shareManager] filterWithFilterType:currentFilterType];
        NSString *videoCompeletelyPath = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId identify:@"complete"];
        [[UTVideoManager shareManager] filterMovieWithInputUrl:movieURL outputUrl:videoCompeletelyPath videoSize:resource.videoSize filter:movieFilter completely:^(BOOL result) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AppUtils hiddenGIFHud:self.view];
                    currentComposition.moviePath = videoCompeletelyPath;
                    isSaving = NO;
                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoCompeletelyPath)) {
                        //保存相册核心代码
                        UISaveVideoAtPathToSavedPhotosAlbum(videoCompeletelyPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                    }
                });
            }
        }];
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
        UTVideoComposeSuccessViewController *videoComposeSuccessVC = [[UTVideoComposeSuccessViewController alloc] initWithVideoURL:[NSURL fileURLWithPath:videoPath] templateId:currentComposition.templateId];
        [self.navigationController pushViewController:videoComposeSuccessVC animated:YES];
    }
}

-(void)saveInDraft
{
    currentDraftTemplate.movieUrl = movieURL;
    [currentDraftTemplate bg_saveAsync:^(BOOL isSuccess) {
        if (isSuccess) {
            [AppUtils showInfo:@"保存成功"];
            isInDraft = YES;
        }else{
            [AppUtils showInfo:@"保存失败"];
            isInDraft = NO;
        }
    }];
}

-(void)splitImages
{
    [[UTVideoManager shareManager] splitVideo:[NSURL fileURLWithPath:movieURL] fps:resource.fps splitCompleteBlock:^(BOOL success, NSMutableArray *splitimgs) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [playView setDatasource:splitimgs];
                [self startVideo];
            });
        }
        
    }];
}

-(void)setCurrentFilterType:(FilterType)type
{
    currentFilterType = type;
    filter = [[UTImageHanderManager shareManager] filterWithFilterType:type];
}

-(void)setupVideo
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:movieURL]];
    player = [AVPlayer playerWithPlayerItem:playItem];
    movieFile = [[GPUImageMovie alloc] initWithPlayerItem:playItem];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = YES;
    
    [movieFile addTarget:filter];
    [filter addTarget:imageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:playItem];
    
    
    if (audioURL) {
        NSError *error = nil;
        NSData *audioData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:audioURL]];
        audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        if (error) {
            NSLog(@"%@",error.description);
        }
    }else{
        audioPlayer = nil;
    }
}

-(void)stopVideo
{
    if (player.rate == 0.0f) {
        return;
    }
    if (CMTimeCompare(player.currentTime, player.currentItem.asset.duration)) {
        pausedTime = player.currentTime;
    }else{
        pausedTime = CMTimeMake(0, resource.fps);
    }
    
//    [movieFile cancelProcessing];
    [player setRate:0.0f];
    [audioPlayer pause];
    [playView playFinished];
}

-(void)moviePlayFinished
{
    pausedTime = CMTimeMake(0, resource.fps);
    [playView playFinished];
    [audioPlayer stop];
}

-(void)startVideo
{
    [self setupVideo];
    if (movieFile ) {
        [movieFile startProcessing];
        [player setRate:1.0f];
        [player seekToTime:pausedTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [player play];
    }
    
    if (audioPlayer) {
        [audioPlayer setVolume:1.0f];
        NSTimeInterval time = CMTimeGetSeconds(pausedTime);
        [audioPlayer setCurrentTime:time];
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }
}

-(void)seekToTime:(CMTime)time
{
    if (player.rate != 0.0f) {
        [self stopVideo];
    }
    
    pausedTime = time;
    [player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

    NSTimeInterval tempTime = CMTimeGetSeconds(time);
    [audioPlayer setCurrentTime:tempTime];
}

-(void)filterProcessingBlock
{
    __weak typeof(playView) weakPlayView = playView;
    [filter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (player.rate != 0.0f) {
                CGFloat percent = (time.value * 1.0 / time.timescale) / CMTimeGetSeconds(player.currentItem.duration);
                NSLog(@"percent %f",percent);
                [weakPlayView scrollToOffsetPercent:percent];
            }
        });
    }];
}

-(void)changeFilter:(FilterType)type
{
    [self stopVideo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (filter) {
            [filter removeAllTargets];
            filter = nil;
        }
        [self setCurrentFilterType:type];
        [self filterProcessingBlock];
        [movieFile removeAllTargets];
        [movieFile addTarget:filter];
        [filter addTarget:imageView];
        
        [self startVideo];
    });
}

-(void)changeMusic:(NSString *)url
{
    [self stopVideo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        audioURL = url;
        pausedTime = CMTimeMake(0, resource.fps);
        [self startVideo];
    });
}
#pragma -mark UTPlayViewProtocol
-(void)dragScrollPercentage:(CGFloat)percent
{
    NSTimeInterval currentTime = CMTimeGetSeconds(player.currentItem.duration) * percent;
    CMTime seekTime = CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC);
    [self seekToTime:seekTime];
}

-(void)playStatusChanged:(BOOL)isPlaying
{
    if (isPlaying) {
        [self startVideo];
    }else{
        [self stopVideo];
    }
}

#pragma -mark UTSelectViewProtocol
-(NSMutableArray *)requestFilterViewDataSource
{
    NSMutableArray *filterList = [NSMutableArray array];
    NSArray *filterNames = @[@"无",@"美颜",@"怀旧",@"黑白",@"素描",@"卡通"];
    for (NSInteger i = 0;i < filterNames.count;i++) {
        NSString *name = [filterNames objectAtIndex:i];
        FilterInfo *info = [[FilterInfo alloc] init];
        info.filterName = name;
        info.filterImage = @"defaultFilterImage";
        info.type = (FilterType)i;
        [filterList addObject:info];
    }
    return filterList;
}

-(NSMutableArray *)requestMusicViewDataSource
{
    NSMutableArray *filterList = [NSMutableArray array];
    MusicInfo *noMusicInfo = [[MusicInfo alloc] init];
    noMusicInfo.musicName = @"无音乐";
    noMusicInfo.musicImage = nil;
    noMusicInfo.musicUrl = nil;
    [filterList addObject:noMusicInfo];
    
    MusicInfo *info = [[MusicInfo alloc] init];
    info.musicName = @"默认";
    info.musicImage = nil;
    info.musicUrl = resource.music;
    [filterList addObject:info];
    [[UTVideoComposeNetworkAPIManager shareManager] requestRecommendMusicWithTemplateId:currentComposition.templateId Callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        NSArray *dataArray = (NSArray *)data;
        if (dataArray && dataArray.count > 0) {
            for (NSDictionary *dic in dataArray) {
                MusicInfo *info = [[MusicInfo alloc] initWithDictionary:dic];
                [filterList addObject:info];
            }
        }
        [selectView setMusicList:filterList];
    }];
    return filterList;
}

-(void)didSelectFilter:(FilterInfo *)info
{
    [self changeFilter:info.type];
}

-(void)didSelectMusic:(MusicInfo *)info
{
    if ([info.musicUrl isEqualToString:resource.music]) {
        [self changeMusic:resource.music];
    }else if(info.musicUrl == nil){
        [self changeMusic:nil];
    }else{
        NSString *fileName = [AppUtils getMd5_32Bit:info.musicUrl];
        NSString *directory  = [AppUtils createDirectoryWithUniqueIndex:currentComposition.templateId];
        NSString *path = [NSString stringWithFormat:@"%@/%@.%@",directory,fileName,[info.musicUrl pathExtension]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [self changeMusic:path];
        }else{
            [AppUtils showHudProgress:@"下载音乐" forView:self.view];
            [[NetWorkManager defaultManager] downloadFileWithOption:nil withInferface:info.musicUrl savedPath:path downloadSuccess:^(NSURL *filePath) {
                [AppUtils hidenHudProgressForView:self.view];
                [self changeMusic:path];
            } downloadFailure:^(NSError *error) {
                [AppUtils hidenHudProgressForView:self.view];
                [AppUtils showInfo:@"下载失败"];
            } progress:^(NSProgress *downloadProgress) {
                
            }];
        }
    }
}
@end
