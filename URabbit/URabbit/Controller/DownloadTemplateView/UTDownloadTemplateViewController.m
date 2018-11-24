//
//  UTDownloadTemplateViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTDownloadTemplateViewController.h"
#import "HomeTemplate.h"

#import "UTDownloadButtonView.h"
#import "UTVideoInfoView.h"
#import "UTVideoAuthorView.h"

#import "UTPhotoEditViewController.h"
#import "UTDownloadNetworkAPIManager.h"
#import "NetWorkManager.h"

#import "Custom.h"
#import "Resource.h"
#import "AnimationForMedia.h"
#import "AnimationSwitch.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"

#import "Composition.h"
#import "AppStartManager.h"

@interface UTDownloadTemplateViewController ()<UTDownloadButtonViewProtocol>
{
    HomeTemplate *currentHomeTemplate;
    Composition *composition;
    UTDownloadButtonView *makeButtonView;
    UIScrollView *scrollView;
    UTVideoInfoView *videoInfoView;
    UTVideoAuthorView *videoAuthorView;
    
    Resource *resource;
    Custom *custom;
    NSMutableArray *snapshotList;
}
@end

@implementation UTDownloadTemplateViewController
-(instancetype)initWithHomeTemplate:(HomeTemplate *)homeTemplate
{
    self = [super init];
    if (self) {
        currentHomeTemplate = homeTemplate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#121722"]];
    snapshotList = [NSMutableArray array];
    Member *host = [[AppStartManager shareManager] currentMember];
    composition = [[Composition alloc] init];
    if (host) {
        composition.memberId = host.memberId;
    }else{
        composition.memberId = @"";
    }
    composition.templateId = currentHomeTemplate.templateId;
    composition.title = currentHomeTemplate.title;
    composition.coverUrl = currentHomeTemplate.coverUrl;
    composition.duration = currentHomeTemplate.duration;
    composition.summary = currentHomeTemplate.summary;
    composition.videoWidth = currentHomeTemplate.videoSize.width;
    composition.videoHeight = currentHomeTemplate.videoSize.height;
    composition.bg_tableName = CompositionTableName;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scrollView setContentInset:UIEdgeInsetsMake(0, 0, [UIDevice safeAreaBottomHeight], 0)];
    [self.view addSubview:scrollView];
    
    videoInfoView = [[UTVideoInfoView alloc] initWithVideoSize:currentHomeTemplate.videoSize frame:CGRectMake(0,17, SCREEN_WIDTH, 0)];
    [scrollView addSubview:videoInfoView];
    videoAuthorView = [[UTVideoAuthorView alloc] initWithFrame:CGRectMake(0, videoInfoView.frame.origin.y + videoInfoView.frame.size.height, SCREEN_WIDTH, 77)];
    [scrollView addSubview:videoAuthorView];
    
    makeButtonView = [[UTDownloadButtonView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - [UIDevice safeAreaBottomHeight] - 72.0f, SCREEN_WIDTH, 72.0f)];
    makeButtonView.delegate = self;
    [self.view addSubview:makeButtonView];
    
    [self requestTemplateInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationBarSetting
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:currentHomeTemplate.title];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share_button"] style:UIBarButtonItemStylePlain target:self action:@selector(clickShareButton)];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collection_button"] style:UIBarButtonItemStylePlain target:self action:@selector(clickCollectionButton)];
    rightItem2.imageInsets = UIEdgeInsetsMake(0, 15, 0, -10);
    [self.navigationItem setRightBarButtonItems:@[rightItem1,rightItem2]];
    
}

-(void)requestTemplateInfo
{
    [[UTDownloadNetworkAPIManager shareManager] requestTemplateDetailsWithTemplateId:currentHomeTemplate.templateId callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        NSDictionary *resultDic = (NSDictionary *)data;
        if (resultDic) {
            HomeTemplate *template = [[HomeTemplate alloc] initWithDictionary:resultDic];
            [videoInfoView setHomeTemplate:template];
            [videoAuthorView setFrame:CGRectMake(0, videoInfoView.frame.origin.y + videoInfoView.frame.size.height, SCREEN_WIDTH, 77)];
            [videoAuthorView setHomeTemplate:template];
            [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,[UIDevice safeAreaTopHeight] + 17 + videoInfoView.frame.size.height + videoAuthorView.frame.size.height)];
            currentHomeTemplate = template;
        }
    }];
}

-(void)analyzeResource:(NSString *)resourceBaseDirectory
{
    if (snapshotList.count > 0) {
        [snapshotList removeAllObjects];
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"%@/resource.json",resourceBaseDirectory];
    NSString *animationPath = [NSString stringWithFormat:@"%@/animation.json",resourceBaseDirectory];
    NSString *snapshotPath = [NSString stringWithFormat:@"%@/snapshot.json",resourceBaseDirectory];
    NSString *customPath = [NSString stringWithFormat:@"%@/custom.json",resourceBaseDirectory];
    
    NSData *resourceData = [NSData dataWithContentsOfFile:resourcePath];
    NSDictionary *resourceDic = [AppUtils objectWithJsonString:[[NSString alloc] initWithData:resourceData encoding:NSUTF8StringEncoding]];
    resource = [[Resource alloc] initWithDictionary:resourceDic basePath:resourceBaseDirectory];
    resource.videoSize = currentHomeTemplate.videoSize;
    resource.duration = currentHomeTemplate.duration;
    resource.fps = currentHomeTemplate.fps;
    resource.style = currentHomeTemplate.style;
    resource.totalFrame = currentHomeTemplate.totalFrame;
    
    NSData *customData = [NSData dataWithContentsOfFile:customPath];
    NSDictionary *customDic = [AppUtils objectWithJsonString:[[NSString alloc] initWithData:customData encoding:NSUTF8StringEncoding]];
    custom = [[Custom alloc] initWithDictionary:customDic];
    
    NSData *snapshotData = [NSData dataWithContentsOfFile:snapshotPath];
    NSDictionary *snapshotDic = [AppUtils objectWithJsonString:[[NSString alloc] initWithData:snapshotData encoding:NSUTF8StringEncoding]];
    NSArray *snapshotArray = [snapshotDic objectForKey:@"snapshot"];
    if (snapshotArray && snapshotArray.count > 0) {
        for (NSDictionary *snapshotDic in snapshotArray) {
            Snapshot *snapshot = [[Snapshot alloc] initWithDictionary:snapshotDic basePath:resourceBaseDirectory custom:custom];
            snapshot.videoSize = currentHomeTemplate.videoSize;
            [snapshotList addObject:snapshot];
        }
    }
    
    NSData *animationsData = [NSData dataWithContentsOfFile:animationPath];
    NSDictionary *animationsDic = [AppUtils objectWithJsonString:[[NSString alloc] initWithData:animationsData encoding:NSUTF8StringEncoding]];
    NSArray *animations = [animationsDic objectForKey:@"animation"];
    if (animations && animations.count > 0) {
        for (NSDictionary *animationDic in animations) {
            AnimationType type = (AnimationType)[[animationDic objectForKey:@"type"] integerValue];
            NSInteger startFrame = [[animationDic objectForKey:@"startFrame"] integerValue];
            NSInteger endFrame = [[animationDic objectForKey:@"endFrame"] integerValue];
            
            AnimationSwitch *moveInAnimationSwitch = nil;
            id enterTypeObj = [animationDic objectForKey:@"enterType"];
            if (enterTypeObj) {
                NSInteger moveInAnimationStartFrame = [[animationDic objectForKey:@"enterStartFrame"] integerValue];
                NSInteger moveInAnimationEndFrame = [[animationDic objectForKey:@"enterEndFrame"] integerValue];
                NSInteger enterType = [enterTypeObj integerValue];
                NSDictionary *moveInAnimationSwitchDic = [NSDictionary dictionaryWithObjectsAndKeys:@(moveInAnimationEndFrame),@"endFrame",@(moveInAnimationStartFrame),@"startFrame",@(enterType),@"type", nil];
                moveInAnimationSwitch = [[AnimationSwitch alloc] initWithDictionary:moveInAnimationSwitchDic];
            }else{
                NSDictionary *moveInAnimationSwitchDic = [NSDictionary dictionaryWithObjectsAndKeys:@(startFrame + 1),@"endFrame",@(startFrame),@"startFrame",@(0),@"type", nil];
                moveInAnimationSwitch = [[AnimationSwitch alloc] initWithDictionary:moveInAnimationSwitchDic];
            }
            
            id exitTypeObj = [animationDic objectForKey:@"exitType"];
            AnimationSwitch *moveOutAnimationSwitch = nil;
            if (exitTypeObj) {
                NSInteger moveOutAnimationStartFrame = [[animationDic objectForKey:@"exitStartFrame"] integerValue];
                NSInteger moveOutAnimationEndFrame = [[animationDic objectForKey:@"exitEndFrame"] integerValue];
                NSInteger exitType = [[animationDic objectForKey:@"exitType"] integerValue];
                NSDictionary *moveOutAnimationSwitchDic = [NSDictionary dictionaryWithObjectsAndKeys:@(moveOutAnimationEndFrame),@"endFrame",@(moveOutAnimationStartFrame),@"startFrame",@(exitType),@"type", nil];
                moveOutAnimationSwitch = [[AnimationSwitch alloc] initWithDictionary:moveOutAnimationSwitchDic];
            }else{
                NSDictionary *moveOutAnimationSwitchDic = [NSDictionary dictionaryWithObjectsAndKeys:@(startFrame + 1),@"endFrame",@(startFrame),@"startFrame",@(0),@"type", nil];
                moveOutAnimationSwitch = [[AnimationSwitch alloc] initWithDictionary:moveOutAnimationSwitchDic];
            }
            
            NSArray *medias = [animationDic objectForKey:@"media"];
            if (medias && medias.count > 0) {
                for (NSDictionary *mediaDic in medias) {
                    AnimationForMedia *animationForMedia = [[AnimationForMedia alloc] initWithDictionary:mediaDic startFrame:startFrame endFrame:endFrame animationType:type fps:resource.fps];
                    SnapshotMedia *snapshotMedia = [self filterArray:snapshotList withMediaName:animationForMedia.name];
                    if (snapshotMedia) {
                        [snapshotMedia.animationForMediaList addObject:animationForMedia];
                        [snapshotMedia.animationForSwitchList addObject:moveInAnimationSwitch];
                        [snapshotMedia.animationForSwitchList addObject:moveOutAnimationSwitch];
                    }
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UTPhotoEditViewController *photoEditVC = [[UTPhotoEditViewController alloc] initWithResource:resource snapshots:snapshotList compositon:composition];
        [self.navigationController pushViewController:photoEditVC animated:YES];
    });
}

-(BOOL)unzipFile:(NSString *)zipFile directory:(NSString *)directory
{
    NSString *unzipFileName = [NSString stringWithFormat:@"unzip-%ld",currentHomeTemplate.templateId];
    return [AppUtils unzipWithFilePath:zipFile destinationPath:directory unzipFileName:unzipFileName];
}

-(SnapshotMedia *)filterArray:(NSArray *)array withMediaName:(NSString *)name
{
    SnapshotMedia *media = nil;
    for (Snapshot *snapshot in array) {
        NSArray *snapshotMedias = [AppUtils fiterArray:snapshot.mediaList fieldName:@"mediaName" value:name];
        if (snapshotMedias && snapshotMedias.count > 0) {
            media = [snapshotMedias objectAtIndex:0];
            break;
        }
    }
    return media;
}

-(void)clickShareButton
{
    
}

-(void)clickCollectionButton
{
    
}

-(BOOL)isDownloadResource
{
    NSString *videoDic = [AppUtils createDirectoryWithUniqueIndex:currentHomeTemplate.templateId];
    NSString *zipPath = [NSString stringWithFormat:@"%@/resource-%ld.zip",videoDic,currentHomeTemplate.templateId];
    return [[NSFileManager defaultManager] fileExistsAtPath:zipPath];
}

#pragma -mark UTDownloadButtonViewProtocol
-(void)beginDownload
{
    NSString *videoDic = [AppUtils createDirectoryWithUniqueIndex:currentHomeTemplate.templateId];
    NSString *zipPath = [NSString stringWithFormat:@"%@/resource-%ld.zip",videoDic,currentHomeTemplate.templateId];
    NSString *unzipFileDirectory = [NSString stringWithFormat:@"%@/unzip-%ld",videoDic,currentHomeTemplate.templateId];
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
        [self analyzeResource:unzipFileDirectory];
    }else{
        [[NetWorkManager defaultManager] downloadFileWithOption:nil withInferface:currentHomeTemplate.downloadUrl savedPath:zipPath downloadSuccess:^(NSURL *filePath) {
            [makeButtonView setButtonTitle:@"一键制作"];
            BOOL result = [self unzipFile:zipPath directory:videoDic];
            if (result) {
                [self analyzeResource:unzipFileDirectory];
            }
        } downloadFailure:^(NSError *error) {
            [AppUtils showInfo:@"下载失败"];
            [makeButtonView setButtonTitle:@"一键制作"];
        } progress:^(NSProgress *downloadProgress) {
            NSLog(@"下载了%lf",[downloadProgress fractionCompleted]);
            [makeButtonView setProgress:[downloadProgress fractionCompleted]];
        }];
    }
    
//    [self generateMaterial];
//    if (materia.materialType == MaterialMask) {
//        EditInfo *info = [[EditInfo alloc] init];
//        info.editImage = @"template1";
//        info.editScreenShotImage = [UIImage imageNamed:info.editImage];
//        info.originSize = materia.videoSize;
//        info.editImageCenterXPercent = 0.5;
//        info.editImageCenterYPercent = (544.0f/2)/960.0f;
//        info.range = NSMakeRange(0, 375);
//        info.filterType = FilterAddBlend;
//        [editInfoList addObject:info];
//    }
//
//    if (materia.materialType == MaterialAnimation) {
//        NSData *animationData = [NSData dataWithContentsOfFile:materia.animationFile];
//        NSString *jsonString = [[NSString alloc] initWithData:animationData encoding:NSUTF8StringEncoding];
//        NSDictionary *animationDic = [AppUtils objectWithJsonString:jsonString];
//        NSArray *editInfos = [animationDic objectForKey:@"editInfo"];
//        for (NSDictionary *dic in editInfos) {
//            EditInfo *info = [[EditInfo alloc] initWithDictinary:dic fps:materia.fps];
//            info.originSize = materia.videoSize;
//            [editInfoList addObject:info];
//        }
//
//        NSArray *animationInfos = [animationDic objectForKey:@"animationInfo"];
//        for (NSDictionary *infoDic in animationInfos) {
//            AnimationInfo *info = [[AnimationInfo alloc] initWithDictionary:infoDic fps:materia.fps];
//            [animationInfoList addObject:info];
//        }
//    }
}
@end
