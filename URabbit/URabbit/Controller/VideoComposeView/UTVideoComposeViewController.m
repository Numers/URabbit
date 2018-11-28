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
#import "UTVideoComposeSuccessViewController.h"

#import "Composition.h"
#import "DraftTemplate.h"
#import "UINavigationController+NavigationBar.h"

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
}
@end

@implementation UTVideoComposeViewController
-(instancetype)initWithResource:(Resource *)m movieUrl:(NSString *)url composition:(Composition *)composition draftTemplate:(DraftTemplate *)draftTemplate
{
    self = [super init];
    if (self) {
        resource = m;
        movieURL = url;
        audioURL = resource.music;
        currentComposition = composition;
        currentDraftTemplate = draftTemplate;
        isInDraft = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#121722"]];
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
        make.bottom.equalTo(playView.top).offset(-23);
        make.top.equalTo(self.view).offset([UIDevice safeAreaTopHeight] + 9);
        make.width.equalTo(imageView.mas_height).multipliedBy(544.0f/960.0f);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

-(void)navigationBarSetting
{
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

-(void)save
{
    [self stopVideo];
    if (movieFile) {
        [movieFile endProcessing];
    }
    [AppUtils showLoadingInView:self.view];
    NSString *tempVideoPath = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId];
    
    [[UTVideoManager shareManager] mergeMovie:movieURL withAudio:audioURL output:tempVideoPath completely:^{
//        if (!isInDraft) {
//            if ([[NSFileManager defaultManager] fileExistsAtPath:movieURL]) {
//                [[NSFileManager defaultManager] removeItemAtPath:movieURL error:nil];
//            }
//        }
        GPUImageOutput<GPUImageInput> *movieFilter = [[UTImageHanderManager shareManager] filterWithFilterType:currentFilterType];
        NSString *videoCompeletelyPath = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId];
        [[UTVideoManager shareManager] filterMovieWithInputUrl:tempVideoPath outputUrl:videoCompeletelyPath videoSize:resource.videoSize filter:movieFilter completely:^(BOOL result) {
            if (result) {
                [AppUtils hiddenLoadingInView:self.view];
                currentComposition.moviePath = videoCompeletelyPath;
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoCompeletelyPath)) {
                    //保存相册核心代码
                    UISaveVideoAtPathToSavedPhotosAlbum(videoCompeletelyPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }
        }];
    }];
}

//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
        [currentComposition bg_save];
        UTVideoComposeSuccessViewController *videoComposeSuccessVC = [[UTVideoComposeSuccessViewController alloc] init];
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
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioURL] error:nil];
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
        info.filterImage = @"recommend";
        info.type = (FilterType)i;
        [filterList addObject:info];
    }
    return filterList;
}

-(NSMutableArray *)requestMusicViewDataSource
{
    NSMutableArray *filterList = [NSMutableArray array];
    NSArray *filterNames = @[@"默认"];
    for (NSInteger i = 0;i < filterNames.count;i++) {
        NSString *name = [filterNames objectAtIndex:i];
        MusicInfo *info = [[MusicInfo alloc] init];
        info.musicName = name;
        info.musicImage = @"recommend";
        info.musicUrl = resource.music;
        [filterList addObject:info];
    }
    return filterList;
}

-(void)didSelectFilter:(FilterInfo *)info
{
    [self changeFilter:info.type];
}

-(void)didSelectMusic:(MusicInfo *)info
{
    [self changeMusic:resource.music];
}
@end
