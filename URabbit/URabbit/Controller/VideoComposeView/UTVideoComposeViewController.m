//
//  UTVideoComposeViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTVideoComposeViewController.h"
#import "Material.h"
#import "FilterInfo.h"
#import "GPUImage.h"

#import "UTPlayView.h"
#import "UTSelectView.h"
#import "UTSegmentView.h"


@interface UTVideoComposeViewController ()<UTPlaySubViewProtocol,UTSelectViewProtocol>
{
    Material *material;
    NSString *movieURL;
    NSMutableArray *imageList;
    
    GPUImageView *imageView;
    GPUImageMovie *movieFile;
    AVPlayer *player;
    GPUImageFilter *filter;
    
    UTPlayView *playView;
    UTSelectView *selectView;
    UTSegmentView *segmentView;
    CMTime pausedTime;
    float duration;
}
@end

@implementation UTVideoComposeViewController
-(instancetype)initWithMaterial:(Material *)m movieUrl:(NSString *)url images:(NSMutableArray *)images
{
    self = [super init];
    if (self) {
        material = m;
        movieURL = url;
        imageList = [NSMutableArray arrayWithArray:images];
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
    [segmentView setSelectIndexBlock:^(NSInteger index) {
        [selectView showViewWithIndex:index];
    }];
    [self.view addSubview:segmentView];
    [segmentView addTitles:@[@"滤镜",@"音乐"]];
    
    playView = [[UTPlayView alloc] initWithImages:imageList];
    playView.delegate = self;
    [self.view addSubview:playView];
    
    imageView = [[GPUImageView alloc] init];
    [self.view addSubview:imageView];
    [self makeConstraints];
    
    filter = [[GPUImageFilter alloc] init];
    [self filterProcessingBlock];
    pausedTime = CMTimeMake(0, material.fps);
    [self startVideo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetting];
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
    if (player.rate != 0.0f) {
        [self stopVideo];
    }
    pausedTime = CMTimeMake(5, material.fps);
    [player seekToTime:pausedTime];
}

-(void)saveInDraft
{
    if (player.rate == 0.0f) {
        [self startVideo];
    }else{
        [self stopVideo];
    }
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
}

-(void)stopVideo
{
    if (player.rate == 0.0f) {
        return;
    }
    if (CMTimeCompare(player.currentTime, player.currentItem.asset.duration)) {
        pausedTime = player.currentTime;
    }else{
        pausedTime = CMTimeMake(0, material.fps);
    }
    
//    [movieFile cancelProcessing];
    [player setRate:0.0f];
}

-(void)moviePlayFinished
{
    pausedTime = CMTimeMake(0, material.fps);
    [playView playFinished];
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
}

-(void)seekToTime:(CMTime)time
{
    if (player.rate != 0.0f) {
        [self stopVideo];
    }
    pausedTime = time;
    [player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
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
        switch (type) {
            case FilterNormal:
                filter = [[GPUImageFilter alloc] init];
                break;
            case FilterToon:
                filter = [[GPUImageToonFilter alloc] init];
                break;
            case FilterBulgeDistortion:
                filter = [[GPUImageBulgeDistortionFilter alloc] init];
                break;
            case FilterSketch:
                filter = [[GPUImageSketchFilter alloc] init];
                break;
            case FilterGamma:
                filter = [[GPUImageGammaFilter alloc] init];
                break;
            case FilterToneCurve:
                filter = [[GPUImageToneCurveFilter alloc] init];
                break;
            case FilterSepia:
                filter = [[GPUImageSepiaFilter alloc] init];
                break;
            case FilterGrayscale:
                filter = [[GPUImageGrayscaleFilter alloc] init];
                break;
            case FilterHistogram:
                filter = [[GPUImageHistogramFilter alloc] init];
                break;
            default:
                break;
        }
        
        [self filterProcessingBlock];
        [movieFile removeAllTargets];
        [movieFile addTarget:filter];
        [filter addTarget:imageView];
        
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
    NSArray *filterNames = @[@"无",@"卡通",@"凸起",@"素描",@"伽马线",@"色调曲线",@"怀旧",@"灰度",@"色彩直方图"];
    for (NSInteger i = 0;i < filterNames.count;i++) {
        NSString *name = [filterNames objectAtIndex:i];
        FilterInfo *info = [[FilterInfo alloc] init];
        info.filterName = name;
        info.filterImage = @"recommend";
        info.type = i;
        [filterList addObject:info];
    }
    return filterList;
}

-(void)didSelectFilter:(FilterInfo *)info
{
    [self changeFilter:info.type];
}
@end
