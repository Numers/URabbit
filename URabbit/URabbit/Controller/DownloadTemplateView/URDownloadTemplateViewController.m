//
//  URDownloadTemplateViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URDownloadTemplateViewController.h"
#import "HomeTemplate.h"

#import "URDownloadButtonView.h"
#import "URVideoInfoView.h"
#import "URVideoAuthorView.h"

#import "URPhotoEditViewController.h"
#import "URDownloadNetworkAPIManager.h"
#import "NetWorkManager.h"
#import "GeneralManager.h"

#import "Custom.h"
#import "Resource.h"
#import "Text.h"
#import "AnimationForMedia.h"
#import "AnimationSwitch.h"
#import "AnimationForText.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "SnapshotText.h"

#import "Composition.h"
#import "LoadedTemplate.h"
#import "AppStartManager.h"
#import "URUserSaveNetworkAPIManager.h"
#import "UINavigationController+NavigationBar.h"
#import "URLoginScrollViewController.h"
//#import "URMemberScrollViewController.h"
#import "URDownloadAlertView.h"
#import "URShareViewController.h"
#import "URUMShareManager.h"
#import "URVideoManager.h"

@interface URDownloadTemplateViewController ()<URDownloadButtonViewProtocol,URDownloadAlertViewProtocl,URVideoAuthorViewProtocol,UTShareViewProtocol>
{
    HomeTemplate *currentHomeTemplate;
    Composition *composition;
    LoadedTemplate *loadedTemplate;
    URDownloadButtonView *makeButtonView;
    UIScrollView *scrollView;
    URVideoInfoView *videoInfoView;
    URVideoAuthorView *videoAuthorView;
    
    URDownloadAlertView *downloadAlertView;
    
    Resource *resource;
    Custom *custom;
    NSMutableArray *snapshotList;
    
    BOOL isSaved;
}
@end

@implementation URDownloadTemplateViewController
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
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#FFFFFF"]];
    snapshotList = [NSMutableArray array];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scrollView setContentInset:UIEdgeInsetsMake(0, 0, [UIDevice safeAreaBottomHeight], 0)];
    [self.view addSubview:scrollView];
    
    makeButtonView = [[URDownloadButtonView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - [UIDevice safeAreaBottomHeight] - 44.0f, SCREEN_WIDTH, 44.0f)];
    makeButtonView.delegate = self;
    [self.view addSubview:makeButtonView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetting];
    if ([currentHomeTemplate isVip]) {
        Member *host = [[AppStartManager shareManager] currentMember];
        if (!host.isVip) {
            [makeButtonView setTitle:@"VIP专属" isShowVipLabel:YES];
        }else{
            [makeButtonView setTitle:@"一键制作" isShowVipLabel:NO];
        }
    }else{
        [makeButtonView setTitle:@"一键制作" isShowVipLabel:NO];
    }
    [self requestTemplateInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (videoInfoView) {
        [videoInfoView pausePlayView];
    }
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        
        //当前视图控制器在栈中，故为push操作
        
        NSLog(@"push");
        
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        
        //当前视图控制器不在栈中，故为pop操作
        NSLog(@"pop");
        NSString *videoDic = [AppUtils createDirectoryWithUniqueIndex:currentHomeTemplate.templateId];
        NSString *unzipFileDirectory = [NSString stringWithFormat:@"%@/unzip-%ld",videoDic,currentHomeTemplate.templateId];
        if ([[NSFileManager defaultManager] fileExistsAtPath:unzipFileDirectory]){
            [[NSFileManager defaultManager] removeItemAtPath:unzipFileDirectory error:nil];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationViewColor:[UIColor colorFromHexString:@"#FFDE44"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationBarSetting
{
    [self.navigationController setNavigationBarHidden:NO];
     [self.navigationController setNavigationViewColor:[UIColor colorFromHexString:@"#FFDE44"]];
    [self.navigationItem setTitle:currentHomeTemplate.title];
   
    [self setRightItems];
}

-(void)setRightItems
{
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickShareButton)];
    
    UIBarButtonItem *rightItem2;
    Member *host = [[AppStartManager shareManager] currentMember];
    if (host && [host.saveTemplates containsObject:@(currentHomeTemplate.templateId)]) {
        rightItem2 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"collectionImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickCollectionButton)];
        rightItem2.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        isSaved = YES;
    }else{
        rightItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"unCollectionImage"] style:UIBarButtonItemStylePlain target:self action:@selector(clickCollectionButton)];
        rightItem2.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        isSaved = NO;
    }
    [self.navigationItem setRightBarButtonItems:@[rightItem1,rightItem2]];
}

-(void)requestTemplateInfo
{
    [[URDownloadNetworkAPIManager shareManager] requestTemplateDetailsWithTemplateId:currentHomeTemplate.templateId callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        NSDictionary *resultDic = (NSDictionary *)data;
        if (resultDic) {
            HomeTemplate *template = [[HomeTemplate alloc] initWithDictionary:resultDic];
            
            if (videoInfoView && videoAuthorView) {
                
            }else{
                videoInfoView = [[URVideoInfoView alloc] initWithVideoSize:template.videoSize frame:CGRectMake(0,17, SCREEN_WIDTH, 0)];
                [scrollView addSubview:videoInfoView];
                videoAuthorView = [[URVideoAuthorView alloc] initWithFrame:CGRectMake(0, videoInfoView.frame.origin.y + videoInfoView.frame.size.height, SCREEN_WIDTH, 77)];
                videoAuthorView.delegate = self;
                [scrollView addSubview:videoAuthorView];
            }
            
            [videoInfoView setHomeTemplate:template];
            if ([[GeneralManager defaultManager] isAuditSucess]){
//                [videoAuthorView setFrame:CGRectMake(0, videoInfoView.frame.origin.y + videoInfoView.frame.size.height, SCREEN_WIDTH, 77)];
                [videoAuthorView setHidden:YES];
                [videoAuthorView setFrame:CGRectMake(0, videoInfoView.frame.origin.y + videoInfoView.frame.size.height, SCREEN_WIDTH, 0)];
            }else{
                [videoAuthorView setHidden:YES];
                [videoAuthorView setFrame:CGRectMake(0, videoInfoView.frame.origin.y + videoInfoView.frame.size.height, SCREEN_WIDTH, 0)];
            }
            
            [videoAuthorView setHomeTemplate:template];
            [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 17 + videoInfoView.frame.size.height + videoAuthorView.frame.size.height + makeButtonView.frame.size.height)];
            currentHomeTemplate = template;
            [self initlizedDatabase];
        }
    }];
}

-(void)initlizedDatabase
{
    Member *host = [[AppStartManager shareManager] currentMember];
    composition = [[Composition alloc] init];
    loadedTemplate = [[LoadedTemplate alloc] init];
    if (host) {
        composition.memberId = host.memberId;
        loadedTemplate.memberId = host.memberId;
    }else{
        composition.memberId = NOUSERMemberID;
        loadedTemplate.memberId = NOUSERMemberID;
    }
    composition.templateId = currentHomeTemplate.templateId;
    composition.title = currentHomeTemplate.title;
    composition.coverUrl = currentHomeTemplate.coverUrl;
    composition.duration = currentHomeTemplate.duration;
    composition.summary = currentHomeTemplate.summary;
    composition.videoWidth = currentHomeTemplate.videoSize.width;
    composition.videoHeight = currentHomeTemplate.videoSize.height;
    composition.bg_tableName = CompositionTableName;
    
    
    loadedTemplate.templateId = currentHomeTemplate.templateId;
    loadedTemplate.title = currentHomeTemplate.title;
    loadedTemplate.coverUrl = currentHomeTemplate.coverUrl;
    loadedTemplate.duration = currentHomeTemplate.duration;
    loadedTemplate.summary = currentHomeTemplate.summary;
    loadedTemplate.videoWidth = currentHomeTemplate.videoSize.width;
    loadedTemplate.videoHeight = currentHomeTemplate.videoSize.height;
    loadedTemplate.bg_tableName = LoadedTableName;
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
    if (resource.fgVideo) {
        resource.fps = [[URVideoManager shareManager] getFpsWithVideoPath:resource.fgVideo];
        resource.totalFrame = [[URVideoManager shareManager] getTotalFramesWithVideoPath:resource.fgVideo];
    }else if (resource.bgVideo){
        resource.fps = [[URVideoManager shareManager] getFpsWithVideoPath:resource.bgVideo];
        resource.totalFrame = [[URVideoManager shareManager] getTotalFramesWithVideoPath:resource.bgVideo];
    }else{
        resource.fps = currentHomeTemplate.fps;
        resource.totalFrame = currentHomeTemplate.totalFrame;
    }
    resource.style = currentHomeTemplate.style;
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
            if (currentHomeTemplate.totalFrame < startFrame) {
                continue;
            }
            AnimationSwitch *moveInAnimationSwitch = nil;
            id enterTypeObj = [animationDic objectForKey:@"enterType"];
            if (enterTypeObj) {
                NSInteger moveInAnimationStartFrame = [[animationDic objectForKey:@"enterStartFrame"] integerValue];
                NSInteger moveInAnimationEndFrame = [[animationDic objectForKey:@"enterEndFrame"] integerValue];
                NSInteger enterType = [enterTypeObj integerValue];
                NSDictionary *moveInAnimationSwitchDic = [NSDictionary dictionaryWithObjectsAndKeys:@(moveInAnimationEndFrame),@"endFrame",@(moveInAnimationStartFrame),@"startFrame",@(enterType),@"type", nil];
                moveInAnimationSwitch = [[AnimationSwitch alloc] initWithDictionary:moveInAnimationSwitchDic];
            }else{
                NSDictionary *moveInAnimationSwitchDic = [NSDictionary dictionaryWithObjectsAndKeys:@(startFrame + 1),@"endFrame",@(startFrame),@"startFrame",@(SwitchAnimationNoneIn),@"type", nil];
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
                NSDictionary *moveOutAnimationSwitchDic = [NSDictionary dictionaryWithObjectsAndKeys:@(endFrame),@"endFrame",@(endFrame - 1),@"startFrame",@(SwitchAnimationNoneOut),@"type", nil];
                moveOutAnimationSwitch = [[AnimationSwitch alloc] initWithDictionary:moveOutAnimationSwitchDic];
            }
            
            NSArray *medias = [animationDic objectForKey:@"media"];
            if (medias && medias.count > 0) {
                for (NSDictionary *mediaDic in medias) {
                    AnimationForMedia *animationForMedia = [[AnimationForMedia alloc] initWithDictionary:mediaDic startFrame:startFrame endFrame:endFrame fps:resource.fps parentDic:animationDic];
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
    
    NSArray *textAnimations = [animationsDic objectForKey:@"textAnimation"];
    if (textAnimations && textAnimations.count > 0) {
        for (NSDictionary *animationDic in textAnimations) {
            AnimationType type = (AnimationType)[[animationDic objectForKey:@"type"] integerValue];
            NSInteger startFrame = [[animationDic objectForKey:@"startFrame"] integerValue];
            NSInteger endFrame = [[animationDic objectForKey:@"endFrame"] integerValue];
            
            NSArray *texts = [animationDic objectForKey:@"text"];
            if (texts && texts.count > 0) {
                for (NSDictionary *textDic in texts) {
                    AnimationForText *animationForText = [[AnimationForText alloc] initWithDictionary:textDic startFrame:startFrame endFrame:endFrame animationType:type fps:resource.fps];
                    SnapshotText *snapshotText = [self filterArray:snapshotList withTextName:animationForText.name];
                    if (snapshotText) {
                        [snapshotText.animationForTextList addObject:animationForText];
                    }
                }
            }
        }
    }
    
    [self downloadFontFile:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            URPhotoEditViewController *photoEditVC = [[URPhotoEditViewController alloc] initWithResource:resource snapshots:snapshotList compositon:composition];
            [self.navigationController pushViewController:photoEditVC animated:YES];
        });
    }];
}

-(void)downloadFontFile:(void (^)(void))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(custom.textList.count > 0){
            NSString *fontDirectory = [AppUtils createDirectory:@"UTFont"];
            for (Text *text in custom.textList) {
                NSString *relativeFontFileDirectiory = [AppUtils getMd5_32Bit:text.fontUrl];
                NSString *fontFileDirectoryPath = [NSString stringWithFormat:@"%@/%@",fontDirectory,relativeFontFileDirectiory];
                if (![[NSFileManager defaultManager] fileExistsAtPath:fontFileDirectoryPath]) {
                    
                    [AppUtils showHudProgress:@"下载字体" forView:self.view];
                    NSString *zipFile = [NSString stringWithFormat:@"%@/%@",fontDirectory,@"fontzip.zip"];
                    NSURL *fileUrl = [NSURL URLWithString:text.fontUrl];
                    NSData *zipData = [NSData dataWithContentsOfURL:fileUrl];
                    [zipData writeToFile:zipFile atomically:NO];
                    BOOL result = [AppUtils unzipWithFilePath:zipFile destinationPath:fontDirectory unzipFileName:relativeFontFileDirectiory];
                    if (result) {
                        NSLog(@"解压字体文件成功");
                        [[NSFileManager defaultManager] removeItemAtPath:zipFile error:nil];
                    }
                    [AppUtils hidenHudProgressForView:self.view];
                }
            }
            callback();
        }else{
            callback();
        }
   });
}

-(BOOL)unzipFile:(NSString *)zipFile directory:(NSString *)directory
{
    [AppUtils showHudProgress:@"解压资源" forView:self.view];
    NSString *unzipFileName = [NSString stringWithFormat:@"unzip-%ld-%@",currentHomeTemplate.templateId,currentHomeTemplate.templateVersion];
    BOOL result =  [AppUtils unzipWithFilePath:zipFile destinationPath:directory unzipFileName:unzipFileName];
    [AppUtils hidenHudProgressForView:self.view];
    return result;
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

-(SnapshotText *)filterArray:(NSArray *)array withTextName:(NSString *)name
{
    SnapshotText *text = nil;
    for (Snapshot *snapshot in array) {
        NSArray *snapshotTexts = [AppUtils fiterArray:snapshot.textList fieldName:@"textName" value:name];
        if (snapshotTexts && snapshotTexts.count > 0) {
            text = [snapshotTexts objectAtIndex:0];
            break;
        }
    }
    return text;
}

-(void)clickShareButton
{
    URShareViewController *shareVC = [[URShareViewController alloc] init];
    shareVC.delegate = self;
    [self presentViewController:shareVC animated:YES completion:^{
        
    }];
}

-(void)clickCollectionButton
{
    Member *host = [[AppStartManager shareManager] currentMember];
    if (host == nil) {
        URLoginScrollViewController *loginScrollVC = [[URLoginScrollViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginScrollVC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    if (isSaved) {
        [[URUserSaveNetworkAPIManager shareManager] deleteTemplateWithTemplateId:currentHomeTemplate.templateId callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
            if ([code integerValue] == 200) {
                [AppUtils showInfo:@"取消成功"];
                isSaved = NO;
                [host.saveTemplates removeObject:@(currentHomeTemplate.templateId)];
                [[AppStartManager shareManager] setMember:host];
                [self setRightItems];
            }
        }];
    }else{
        [[URUserSaveNetworkAPIManager shareManager] saveTemplateWithTemplateId:currentHomeTemplate.templateId callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
            if ([code integerValue] == 200) {
                [AppUtils showInfo:@"收藏成功"];
                isSaved = YES;
                [host.saveTemplates addObject:@(currentHomeTemplate.templateId)];
                [[AppStartManager shareManager] setMember:host];
                [self setRightItems];
            }
        }];
    }
}

-(BOOL)isDownloadResource
{
    NSString *videoDic = [AppUtils createDirectoryWithUniqueIndex:currentHomeTemplate.templateId];
    NSString *zipPath = [NSString stringWithFormat:@"%@/resource-%ld.zip",videoDic,currentHomeTemplate.templateId];
    return [[NSFileManager defaultManager] fileExistsAtPath:zipPath];
}

-(void)sendShareWithPlatform:(UMSocialPlatformType)type
{
    NSString *coverUrl = [NSString stringWithFormat:@"%@?x-oss-process=image/crop,h_200,w_200,g_center/format,png",currentHomeTemplate.coverUrl];
    NSString *shareUrl = [NSString stringWithFormat:@"https://www.utsdk.com/templet.html?id=%ld",currentHomeTemplate.templateId];
    NSData *coverData = [NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]];
    [[URUMShareManager shareManager] shareWebPageToPlatformType:type title:currentHomeTemplate.title description:currentHomeTemplate.summary thumImage:coverData webpageUrl:shareUrl callback:^(id response) {
        
    }];
}
#pragma -mark URDownloadButtonViewProtocol
-(void)beginDownload
{
    [AppUtils trackMTAEventNo:@"4" pageNo:@"2" parameters:@{@"templetId":[NSString stringWithFormat:@"%ld",currentHomeTemplate.templateId]}];
    if ([AppUtils compareVersion:currentHomeTemplate.latestVersion greatThan:[AppUtils appVersion]] > 0) {
        downloadAlertView = [[URDownloadAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [downloadAlertView setDesctiption:@"该模板需要更新app才能使用\n确定前往更新吗？"];
        downloadAlertView.delegate = self;
        [downloadAlertView alert];
        return;
    }
    
    Member *host = [[AppStartManager shareManager] currentMember];
    if (host == nil) {
        URLoginScrollViewController *loginScrollVC = [[URLoginScrollViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginScrollVC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    if (currentHomeTemplate.isVip) {
        if (!host.isVip) {
            downloadAlertView = [[URDownloadAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [downloadAlertView setDesctiption:@"该模板需要更新app才能使用\n确定前往更新吗？"];
            downloadAlertView.delegate = self;
            [downloadAlertView alert];
            return;
        }
    }
    
    NSString *videoDic = [AppUtils createDirectoryWithUniqueIndex:currentHomeTemplate.templateId];
    NSString *zipPath = [NSString stringWithFormat:@"%@/resource-%ld-%@.zip",videoDic,currentHomeTemplate.templateId,currentHomeTemplate.templateVersion];
    NSString *unzipFileDirectory = [NSString stringWithFormat:@"%@/unzip-%ld-%@",videoDic,currentHomeTemplate.templateId,currentHomeTemplate.templateVersion];
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([[NSFileManager defaultManager] fileExistsAtPath:unzipFileDirectory]) {
                [self analyzeResource:unzipFileDirectory];
            }else{
                BOOL result = [self unzipFile:zipPath directory:videoDic];
                if (result) {
                    [self analyzeResource:unzipFileDirectory];
                }
            }
        });
    }else{
        [AppUtils showGIFHudProgress:@"" forView:self.view];
        [[NetWorkManager defaultManager] downloadFileWithOption:nil withInferface:currentHomeTemplate.downloadUrl savedPath:zipPath downloadSuccess:^(NSURL *filePath) {
            [AppUtils hiddenGIFHud:self.view];
            [makeButtonView setButtonTitle:@"一键制作" enable:YES];
            [loadedTemplate bg_saveOrUpdate];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL result = [self unzipFile:zipPath directory:videoDic];
                if (result) {
                    [self analyzeResource:unzipFileDirectory];
                }
            });
        } downloadFailure:^(NSError *error) {
            [AppUtils hiddenGIFHud:self.view];
            [AppUtils showInfo:@"下载失败"];
            [makeButtonView setButtonTitle:@"一键制作" enable:YES];
        } progress:^(NSProgress *downloadProgress) {
            NSLog(@"下载了%lf",[downloadProgress fractionCompleted]);
//            [makeButtonView setButtonTitle:@"下载中..." enable:NO];
            [makeButtonView setProgress:[downloadProgress fractionCompleted]];
        }];
    }
}

#pragma -mark URDownloadAlertViewProtocl
-(void)didComfirm
{
    if (downloadAlertView) {
        [downloadAlertView dismiss:^{
            dispatch_async(dispatch_get_main_queue(), ^{
//                URMemberScrollViewController *memberScrollVC = [[URMemberScrollViewController alloc] initWithTransitionMethod:NO];
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:memberScrollVC];
//                [self presentViewController:nav animated:YES completion:nil];
                [[GeneralManager defaultManager] jumpToDownloadHtml];
            });
        }];
    }
}

#pragma -mark UTShareViewProtocol
-(void)sendShareToWeixin
{
    [self sendShareWithPlatform:UMSocialPlatformType_WechatSession];
}

-(void)sendShareToFriend
{
    [self sendShareWithPlatform:UMSocialPlatformType_WechatTimeLine];
}

-(void)sendShareToQQ
{
    [self sendShareWithPlatform:UMSocialPlatformType_QQ];
}

-(void)sendShareToWeibo
{
    [self sendShareWithPlatform:UMSocialPlatformType_Sina];
}
@end
