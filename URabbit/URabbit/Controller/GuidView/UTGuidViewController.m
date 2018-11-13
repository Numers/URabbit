//
//  UTGuidViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTGuidViewController.h"
#import "Material.h"
#import "ComposeStrategy.h"
#import "UTVideoManager.h"
#import "VideoCompose.h"
#import "GPUImage.h"
#import <MediaPlayer/MediaPlayer.h>


@interface UTGuidViewController ()<VideoComposeProtocol>
{
    Material *material;
    ComposeStrategy *strategy;
    NSMutableArray *imageList;
    VideoCompose *compose;
    NSString *videoPath;
    NSString *audioPath;
    
    AVAssetWriterInput *assetVideoWriterInput;
    int totalFrames;
}
@property(nonatomic,strong) MPMoviePlayerController *playerController;
@property(nonatomic, strong) GPUImageView *resultImageView;
@end

@implementation UTGuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundColor];
    
    _resultImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_resultImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:_resultImageView];

    material = [[Material alloc] initWithFileUrl:@""];
    totalFrames = [[UTVideoManager shareManager] getTotalFramesWithVideoPath:material.templateVideo];
    imageList = [NSMutableArray array];
    
    NSString *videoDic = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    videoPath = [NSString stringWithFormat:@"%@/video.mp4",videoDic];
    
//    strategy = [[ComposeStrategy alloc] initWithMaterial:material];
//    [strategy createVideoReader];

    float fps = [[UTVideoManager shareManager] getFpsWithVideoPath:material.templateVideo];
    compose = [[VideoCompose alloc] initWithVideoUrl:videoPath videoSize:CGSizeMake(544, 960) fps:fps totalFrames:material.totalFrames];
    compose.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"内存警告");
}

//-(CMSampleBufferRef)readNextPixelBuffer:(int)frame
//{
//    if (frame == totalFrames-1) {
//        return nil;
//    }
//    CMSampleBufferRef sampleBufferRef = [strategy readVideoFrames:frame];
//    return sampleBufferRef;
//}

-(void)didWriteToMovie:(int)frame
{
    [strategy cleanMemory];
}

-(void)videoWriteDidFinished:(BOOL)success
{
    if (success) {
        [strategy cleanMemory];
        NSLog(@"finishWriter");
        NSString *videoDic = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *movieOutputUrl = [NSString stringWithFormat:@"%@/videoaudio.mp4",videoDic];
        [[UTVideoManager shareManager] mergeMovie:videoPath withAudio:material.videoMusic output:movieOutputUrl completely:^{
            NSLog(@"合成完成");
            NSString *filterMovieOutputUrl = [NSString stringWithFormat:@"%@/videofilter.mp4",videoDic];
            GPUImageToonFilter *toonFilter = [[GPUImageToonFilter alloc] init];
            [toonFilter addTarget:_resultImageView];
            [[UTVideoManager shareManager] filterMovieWithInputUrl:movieOutputUrl outputUrl:filterMovieOutputUrl videoSize:CGSizeMake(544, 960) filter:toonFilter completely:^(BOOL result) {
                if (result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.playerController =[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filterMovieOutputUrl]];
                        self.playerController.view.frame = CGRectMake(0, 80, SCREEN_WIDTH, 300);
                        [self.view addSubview: self.playerController.view];
                        [self.playerController  prepareToPlay];
                    });
                }
            }];
        }];
        
//        NSString *filterMovieOutputUrl = [NSString stringWithFormat:@"%@/videofilter.mp4",videoDic];
//        GPUImageToonFilter *toonFilter = [[GPUImageToonFilter alloc] init];
//        [[UTVideoManager shareManager] filterMovieWithInputUrl:videoPath outputUrl:filterMovieOutputUrl videoSize:CGSizeMake(544, 960) filter:toonFilter completely:^(BOOL result) {
//            if (result) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.playerController =[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filterMovieOutputUrl]];
//                    self.playerController.view.frame = CGRectMake(0, 80, SCREEN_WIDTH, 300);
//                    [self.view addSubview: self.playerController.view];
//                    [self.playerController  prepareToPlay];
//                });
//            }
//        }];
    }
}
@end
