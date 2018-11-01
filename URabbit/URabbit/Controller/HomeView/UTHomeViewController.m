//
//  UTHomeViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTHomeViewController.h"
#import "Material.h"
#import "ComposeStrategy.h"
#import "UTVideoManager.h"
#import "VideoComposeTest.h"

#import <MediaPlayer/MediaPlayer.h>

@interface UTHomeViewController ()<VideoComposeTestProtocol>
{
    Material *material;
    ComposeStrategy *strategy;
    NSMutableArray *imageList;
    VideoComposeTest *compose;
    NSString *videoPath;
    
    AVAssetWriterInput *assetVideoWriterInput;
    int totalFrames;
}
@property(nonatomic,strong) MPMoviePlayerController *playerController;
@end

@implementation UTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    material = [[Material alloc] initWithFileUrl:@""];
    totalFrames = [[UTVideoManager shareManager] getTotalFramesWithVideoPath:material.templateVideo];
    imageList = [NSMutableArray array];
    
    NSString *videoDic = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    videoPath = [NSString stringWithFormat:@"%@/video.mp4",videoDic];
    
    strategy = [[ComposeStrategy alloc] initWithMaterial:material];
    [strategy createVideoReader];
    
    float fps = [[UTVideoManager shareManager] getFpsWithVideoPath:material.templateVideo];
    compose = [[VideoComposeTest alloc] initWithVideoUrl:videoPath videoSize:CGSizeMake(544, 960) fps:fps];
    compose.delegate = self;
    [compose readNextFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *)readNextPixelBuffer:(int)frame
{
    if (frame == totalFrames-1) {
        return nil;
    }
    UIImage * image = [strategy readVideoFrames:frame];
    return image;
}

-(void)videoWriteDidFinished:(BOOL)success hasNextFrame:(BOOL)hasNextFrame
{
    if (success) {
        if (hasNextFrame) {
            [compose readNextFrame];
        }else{
            [strategy removeVideoReader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playerController =[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
                self.playerController.view.frame = CGRectMake(0, 80, SCREEN_WIDTH, 300);
                [self.view addSubview: self.playerController.view];
                [self.playerController  prepareToPlay];
            });
        }
    }
}
@end
