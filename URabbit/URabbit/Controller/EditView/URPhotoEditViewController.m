//
//  URPhotoEditViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URPhotoEditViewController.h"
#import "URPhotoEditShowImageCollectionViewCell.h"
#import "URMiddleEditContainerView.h"
#import "URPhotoEditView.h"
#import "URPhotoEditCanMoveView.h"
#import "URPhotoEditNotMoveView.h"
#import "ComposeRotationStrategy.h"
#import "ComposeAnimationStrategy.h"
#import "ComposeCoverStrategy.h"
#import "VideoCompose.h"
#import "URVideoManager.h"
#import "URImageHanderManager.h"
#import "ComposeAnimation.h"

#import "Resource.h"
#import "Snapshot.h"

#import "UINavigationController+NavigationBar.h"

#import "URVideoComposeViewController.h"
#import "URVideoComposeResultViewController.h"
#import "GeneralManager.h"
#import "PSTCollectionView.h"

#import "Composition.h"
#import "DraftTemplate.h"

#import <DMProgressHUD/DMProgressHUD.h>
#import "LDImagePicker.h"

#define VideoRatio 5
#define WebpRatio 3
#define AnimationRatio 2
typedef enum{
    ComposeStepVideo = 1,
    ComposeStepWebp,
    ComposeStepAnimation
} ComposeStep;

static NSString *photoEditShowImageCollectionViewCellIdentify = @"PhotoEditShowImageCollectionViewCellIdentify";
@interface URPhotoEditViewController ()<PSTCollectionViewDelegateFlowLayout,PSTCollectionViewDelegate,PSTCollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,URMiddleEditContainerViewProtocol,VideoComposeProtocol,ComposeStrategyProtocl,LDImagePickerDelegate>
{
    UIButton *importPhotosButton;
    URMiddleEditContainerView *containerView;
    PSTCollectionView *collectionView;
    URPhotoEditView *currentEditView;
    
    NSInteger selectedRow;
    
    Resource *currentResource;
    NSMutableArray *currentSnapshots;
    
    ComposeStrategy *strategy;
    VideoCompose *compose;
    NSString *videoPath;
    
    NSInteger totalRatio;
    
    CGFloat currentProgress;
    
    BOOL isComposing;
}
@end

@implementation URPhotoEditViewController
-(instancetype)initWithResource:(Resource *)resource snapshots:(NSMutableArray *)snapshots compositon:(Composition *)composition
{
    self = [super init];
    if (self) {
        currentResource = resource;
        currentSnapshots = [NSMutableArray arrayWithArray:snapshots];
        currentComposition = composition;
        isComposing = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    draftTemplate = [[DraftTemplate alloc] init];
    draftTemplate.memberId = currentComposition.memberId;
    draftTemplate.templateId = currentComposition.templateId;
    draftTemplate.title = currentComposition.title;
    draftTemplate.coverUrl = currentComposition.coverUrl;
    draftTemplate.videoWidth = currentComposition.videoWidth;
    draftTemplate.videoHeight = currentComposition.videoHeight;
    draftTemplate.duration = currentComposition.duration;
    draftTemplate.summary = currentComposition.summary;
    draftTemplate.resourceMusic = currentResource.music;
    draftTemplate.resourceFps = currentResource.fps;
    draftTemplate.bg_tableName = DraftTemplateTableName;
    selectedRow = 0;

    [[URImageHanderManager shareManager] setCurrentImageSize:currentResource.videoSize];
    totalRatio = VideoRatio;
    if (currentResource.style == TemplateStyleAnimation) {
        totalRatio += AnimationRatio;
    }
    
    if (currentResource.fgWebp) {
        totalRatio += WebpRatio;
    }
    
    
    importPhotosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [importPhotosButton setImage:[UIImage imageNamed:@"draft"] forState:UIControlStateNormal];
    NSAttributedString *importTitle = [AppUtils generateAttriuteStringWithStr:@"批量导入图片" WithColor:[UIColor whiteColor] WithFont:[UIFont systemFontOfSize:14.0f]];
    [importPhotosButton setAttributedTitle:importTitle forState:UIControlStateNormal];
    [importPhotosButton setHidden:YES];
    [self.view addSubview:importPhotosButton];
    importPhotosButton.imageEdgeInsets = UIEdgeInsetsMake(0, importPhotosButton.frame.size.width - importPhotosButton.imageView.frame.origin.x - importPhotosButton.imageView.frame.size.width-7, 0, 0);
    importPhotosButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(importPhotosButton.frame.size.width - importPhotosButton.imageView.frame.size.width ), 0, 0);
    
    containerView = [[URMiddleEditContainerView alloc] initWithSnapshots:currentSnapshots style:currentResource.style];
    containerView.delegate = self;
    [self.view addSubview:containerView];
    
    PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    collectionView = [[PSTCollectionView alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT - [UIDevice safeAreaBottomHeight] - 80, SCREEN_WIDTH - 60, 80) collectionViewLayout:layout];
    [collectionView registerClass:[URPhotoEditShowImageCollectionViewCell class] forCellWithReuseIdentifier:photoEditShowImageCollectionViewCellIdentify];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:collectionView];
    
    [self makeConstraints];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationBarSetting];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!containerView.isGenerateData) {
        [containerView generateEditViews];

        for (NSInteger i=0; i<currentSnapshots.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UIImage *image = [containerView deSelectIndexPath:indexPath];
            URPhotoEditShowImageCollectionViewCell *cell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell setPictureImage:image];
            if (i == selectedRow) {
                [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:PSTCollectionViewScrollPositionCenteredHorizontally];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeConstraints
{
    [importPhotosButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([UIDevice safeAreaTopHeight] + 6);
        make.leading.equalTo(self.view).offset(25);
        make.width.equalTo(@(111));
        make.height.equalTo(@(30));
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(importPhotosButton.bottom).offset(11);
        make.bottom.equalTo(collectionView.top).offset(-22);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
}

-(void)navigationBarSetting
{
    [self.navigationController setNavigationViewColor:[UIColor colorFromHexString:@"#FFDE44"]];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    [rightItem1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#333333"]} forState:UIControlStateNormal];
//    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"存草稿" style:UIBarButtonItemStylePlain target:self action:@selector(saveInDraft)];
//    [rightItem2 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#999999"]} forState:UIControlStateNormal];
//    [self.navigationItem setRightBarButtonItems:@[rightItem1,rightItem2]];
    [self.navigationItem setRightBarButtonItem:rightItem1];
}

-(void)pushVideoComposeViewWithMovieUrl:(NSString *)movieUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[GeneralManager defaultManager] isAuditSucess]) {
            URVideoComposeViewController *videoComposeVC = [[URVideoComposeViewController alloc] initWithResource:currentResource movieUrl:movieUrl composition:currentComposition draftTemplate:draftTemplate isFromDraft:NO];
            [self.navigationController pushViewController:videoComposeVC animated:YES];
        }else{
            NSString *videoCompeletelyPath = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId identify:@"complete"];
            [[URVideoManager shareManager] mergeMovie:movieUrl withAudio:currentResource.music output:videoCompeletelyPath completely:^{
                if ([[NSFileManager defaultManager] fileExistsAtPath:movieUrl]) {
                    [[NSFileManager defaultManager] removeItemAtPath:movieUrl error:nil];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    URVideoComposeResultViewController *videoComposeResultVC = [[URVideoComposeResultViewController alloc] initWithResource:currentResource movieUrl:videoCompeletelyPath composition:currentComposition draftTemplate:draftTemplate isFromDraft:NO];
                    [self.navigationController pushViewController:videoComposeResultVC animated:YES];
                });
            }];
        }
    });
}

-(void)setHudProgress:(CGFloat)progress step:(ComposeStep)step isCompletely:(BOOL)isCompletely callback:(void(^)(void))callback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DMProgressHUD *hud = [DMProgressHUD progressHUDForView:self.view];
        switch (step) {
            case ComposeStepWebp:
            {
                CGFloat actualProgress = (progress * WebpRatio) / totalRatio;
                currentProgress += actualProgress;
                hud.progress = currentProgress;
            }
                break;
            case ComposeStepVideo:
            {
                CGFloat actualProgress = (progress * VideoRatio) / totalRatio;
                currentProgress = actualProgress;
                hud.progress = currentProgress;
            }
                break;
            case ComposeStepAnimation:
            {
                CGFloat actualProgress = (progress * AnimationRatio) / totalRatio;
                currentProgress += actualProgress;
                hud.progress = currentProgress;
            }
                break;
            default:
                break;
        }
        
        if (isCompletely) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud dismiss];
                if (callback) {
                    callback();
                }
            });
        }else{
            if (callback) {
                callback();
            }
        }
    });
    
}

-(void)nextStep
{
    if (isComposing) {
        return;
    } else {
        isComposing = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
        UIImage *image = [containerView deSelectIndexPath:indexPath];
        URPhotoEditShowImageCollectionViewCell *cell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setPictureImage:image];
    });
    [containerView generateImagesToCompose];
//    URPhotoEditShowImageCollectionViewCell *cell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    Snapshot *snapshot = [currentSnapshots objectAtIndex:0];
//    SnapshotMedia *meida = [snapshot.mediaList objectAtIndex:0];
//    [cell setPictureImage:meida.resultImage];
//    return;
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:DMProgressHUDAnimationGradient maskType:DMProgressHUDMaskTypeNone];
    hud.mode = DMProgressHUDModeProgress;
    hud.progressType = DMProgressHUDProgressTypeCircle;
    hud.style = DMProgressHUDStyleDark;
    hud.text = @"合成中...";
    currentProgress = 0.0f;
    videoPath = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId identify:@"compose"];
    
    float fps = currentResource.fps;
    if (currentResource.style == TemplateStyleGoodNight) {
        strategy = [[ComposeRotationStrategy alloc] initWithResource:currentResource snapshot:currentSnapshots fps:currentResource.fps];
        [strategy initlizeData];
        strategy.delegate = self;
        [strategy createVideoReader];
    }else if (currentResource.style == TemplateStyleAnimation){
        strategy = [[ComposeAnimationStrategy alloc] initWithResource:currentResource snapshot:currentSnapshots fps:currentResource.fps];
        [strategy initlizeData];
        strategy.delegate = self;
        [strategy createVideoReader];
    }else if(currentResource.style == TemplateStyleFriend){
        strategy = [[ComposeCoverStrategy alloc] initWithResource:currentResource snapshot:currentSnapshots fps:currentResource.fps];
        [strategy initlizeData];
        strategy.delegate = self;
        [strategy createVideoReader];
    }
    
    compose = [[VideoCompose alloc] initWithVideoUrl:videoPath videoSize:currentResource.videoSize fps:fps totalFrames:currentResource.totalFrame];
    compose.delegate = self;
    [compose readFrames];
}

-(void)saveInDraft
{

}

-(void)importPhotos
{
    
}

#pragma -mark UICollectionViewDataSource | UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(PSTCollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return currentSnapshots.count;
}

- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    URPhotoEditShowImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoEditShowImageCollectionViewCellIdentify forIndexPath:indexPath];
    if (indexPath.row == selectedRow) {
        [cell setIsSelected:YES];
    }else{
        [cell setIsSelected:NO];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Snapshot *info = [currentSnapshots objectAtIndex:indexPath.row];
        UIImage *image = [containerView deSelectIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithSnapshot:info index:indexPath.row+1];
            [cell setPictureImage:image];
        });
    });
    return cell;
}

- (UIEdgeInsets)collectionView:(PSTCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 80.0f;
    CGFloat width = height * (currentResource.videoSize.width / currentResource.videoSize.height);
    return CGSizeMake(width,height);
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    [containerView scrollToIndexPath:indexPath];
    URPhotoEditShowImageCollectionViewCell *cell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setIsSelected:YES];
}

-(void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [containerView deSelectIndexPath:indexPath];
    URPhotoEditShowImageCollectionViewCell *cell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setPictureImage:image];
    [cell setIsSelected:NO];
}

#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([currentEditView isKindOfClass:[URPhotoEditCanMoveView class]]) {
        URPhotoEditCanMoveView *view = (URPhotoEditCanMoveView *)currentEditView;
        [view setPictureImage:image];
    }else if([currentEditView isKindOfClass:[URPhotoEditNotMoveView class]]){
        URPhotoEditNotMoveView *view = (URPhotoEditNotMoveView *)currentEditView;
        [view setPictureImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
            UIImage *image = [containerView deSelectIndexPath:indexPath];
            URPhotoEditShowImageCollectionViewCell *cell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell setPictureImage:image];
        });
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma -mark
- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage
{
    if ([currentEditView isKindOfClass:[URPhotoEditCanMoveView class]]) {
        URPhotoEditCanMoveView *view = (URPhotoEditCanMoveView *)currentEditView;
        [view setPictureImage:editedImage];
    }else if([currentEditView isKindOfClass:[URPhotoEditNotMoveView class]]){
        URPhotoEditNotMoveView *view = (URPhotoEditNotMoveView *)currentEditView;
        [view setPictureImage:editedImage];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
    UIImage *image = [containerView deSelectIndexPath:indexPath];
    URPhotoEditShowImageCollectionViewCell *cell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setPictureImage:image];
}

- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker
{
    
}
#pragma -mark URMiddleEditContainerViewProtocol
-(void)openImagePickerViewFromView:(URPhotoEditView *)view scale:(CGFloat)scale
{
    currentEditView = view;
    if (currentResource.style == TemplateStyleFriend) {
        LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
        imagePicker.delegate = self;
        [imagePicker showImagePickerWithType:ImagePickerPhoto InViewController:self Scale:scale];
    }else{
        UIImagePickerController *pickerContoller = [[UIImagePickerController alloc] init];
        pickerContoller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerContoller.delegate = self;
        [self presentViewController:pickerContoller animated:YES completion:^{
            
        }];
    }
}

-(void)scrollToIndexPath:(NSIndexPath *)indexPath fromIndex:(NSIndexPath *)fromIndexPath
{
    selectedRow = indexPath.row;
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:PSTCollectionViewScrollPositionCenteredHorizontally];
    
    URPhotoEditShowImageCollectionViewCell *toCell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [toCell setIsSelected:YES];
    
    URPhotoEditShowImageCollectionViewCell *fromCell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:fromIndexPath];
    [fromCell setIsSelected:NO];
}

#pragma -mark VideoComposeProtocol
-(void)readNextPixelBuffer:(int)frame
{
    [strategy readVideoFrames:frame];
}

-(void)didWriteToMovie:(NSInteger)frame
{
    CGFloat progress = (1.0f * frame) / currentResource.totalFrame;
    [self setHudProgress:progress step:ComposeStepVideo isCompletely:NO callback:^{
        
    }];
}

-(void)videoWriteDidFinished:(BOOL)success
{
    if (success) {
        [strategy cleanMemory];
        [compose cleanMemory];
        NSLog(@"finishWriter");
        if (currentResource.style == TemplateStyleAnimation) {
            ComposeAnimation *composeAnimation = [[ComposeAnimation alloc] initWithResource:currentResource snapshots:currentSnapshots movieUrl:videoPath];
            [composeAnimation addAnimationCompletionHandler:^(NSString *outPutURL, int code) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                }
                
                if (currentResource.fgWebp) {
                    [self setHudProgress:1.0f step:ComposeStepAnimation isCompletely:NO callback:nil];
                    NSString *videoUrl = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId identify:@"composeWebp"];
                    __weak typeof(self) weakSelf = self;
                    [[URVideoManager shareManager] addWebpWithMovieUrl:outPutURL withWebpPath:currentResource.fgWebp output:videoUrl videoSize:currentResource.videoSize completely:^(BOOL isSucess) {
                        if (success) {
                            if ([[NSFileManager defaultManager] fileExistsAtPath:outPutURL]) {
                                [[NSFileManager defaultManager] removeItemAtPath:outPutURL error:nil];
                            }
                            
                            [self setHudProgress:1.0f step:ComposeStepWebp isCompletely:YES callback:^{
                                [weakSelf pushVideoComposeViewWithMovieUrl:videoUrl];
                            }];
                            
                        }
                        isComposing = NO;
                    }];
                }else{
                    isComposing = NO;
                    __weak typeof(self) weakSelf = self;
                    [self setHudProgress:1.0f step:ComposeStepAnimation isCompletely:YES callback:^{
                        [weakSelf pushVideoComposeViewWithMovieUrl:outPutURL];
                    }];
                }
            }];
        }else{
            if (currentResource.fgWebp) {
                NSString *videoUrl = [AppUtils videoPathWithUniqueIndex:currentComposition.templateId identify:@"composeWebp"];
                [[URVideoManager shareManager] addWebpWithMovieUrl:videoPath withWebpPath:currentResource.fgWebp output:videoUrl videoSize:currentResource.videoSize completely:^(BOOL isSucess) {
                    if (success) {
                        if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
                            [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                        }
                        __weak typeof(self) weakSelf = self;
                        [self setHudProgress:1.0f step:ComposeStepWebp isCompletely:YES callback:^{
                             [weakSelf pushVideoComposeViewWithMovieUrl:videoUrl];
                        }];
                    }
                    isComposing = NO;
                }];
            }else{
                isComposing = NO;
                __weak typeof(self) weakSelf = self;
                [self setHudProgress:1.0f step:ComposeStepVideo isCompletely:YES callback:^{
                    [weakSelf pushVideoComposeViewWithMovieUrl:videoPath];
                }];
            }
            
        }
    }
}

#pragma -mark ComposeStrategyProtocl
-(void)sendSampleBufferRef:(CMSampleBufferRef)sampleBufferRef frame:(NSInteger)frame
{
    [compose writeSampleBufferRef:sampleBufferRef frame:frame];
}

-(void)sendPixelBufferRef:(CVPixelBufferRef)pixelBuffer frame:(NSInteger)frame
{
    [compose writeCVPixelBuffer:pixelBuffer frame:frame];
}

-(void)sendResultImage:(UIImage *)image frame:(NSInteger)frame
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *videoDic = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//        NSString *imagePath = [NSString stringWithFormat:@"%@/image_%ld.png",videoDic,frame];
//        NSData *zipImage = [[URImageHanderManager shareManager] zipScaleWithImage:image];
//        BOOL result = [zipImage writeToFile:imagePath atomically:YES];
//        if (result) {
//            [imageList addObject:imagePath];
//        }
//    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        URPhotoEditShowImageCollectionViewCell *cell = (URPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        [cell setPictureImage:image];
//    });
    
    return;
}
@end
