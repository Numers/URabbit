//
//  UTPhotoEditViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditViewController.h"
#import "UTPhotoEditShowImageCollectionViewCell.h"
#import "UTMiddleEditContainerView.h"
#import "HomeTemplate.h"
#import "UTPhotoEditView.h"
#import "Material.h"
#import "ComposeStrategy.h"
#import "VideoCompose.h"
#import "UTVideoManager.h"

#import "UTVideoComposeViewController.h"

static NSString *photoEditShowImageCollectionViewCellIdentify = @"PhotoEditShowImageCollectionViewCellIdentify";
@interface UTPhotoEditViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UTMiddleEditContainerViewProtocol,VideoComposeProtocol,ComposeStrategyProtocl>
{
    UIButton *importPhotosButton;
    UTMiddleEditContainerView *containerView;
    UICollectionView *collectionView;
    UTPhotoEditView *currentEditView;
    
    NSInteger selectedRow;
    
    Material *material;
    NSMutableArray *editInfoList;
    
    
    ComposeStrategy *strategy;
    NSMutableArray *imageList;
    VideoCompose *compose;
    NSString *videoPath;
}
@end

@implementation UTPhotoEditViewController
-(instancetype)initWithMaterial:(Material *)m editInfo:(NSMutableArray *)list;
{
    self = [super init];
    if (self) {
        material = m;
        editInfoList = [NSMutableArray arrayWithArray:list];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#121722"]];
    selectedRow = 0;
    imageList = [NSMutableArray array];
    
    importPhotosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [importPhotosButton setImage:[UIImage imageNamed:@"draft"] forState:UIControlStateNormal];
    NSAttributedString *importTitle = [AppUtils generateAttriuteStringWithStr:@"批量导入图片" WithColor:[UIColor whiteColor] WithFont:[UIFont systemFontOfSize:14.0f]];
    [importPhotosButton setAttributedTitle:importTitle forState:UIControlStateNormal];
    [self.view addSubview:importPhotosButton];
    importPhotosButton.imageEdgeInsets = UIEdgeInsetsMake(0, importPhotosButton.frame.size.width - importPhotosButton.imageView.frame.origin.x - importPhotosButton.imageView.frame.size.width-7, 0, 0);
    importPhotosButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(importPhotosButton.frame.size.width - importPhotosButton.imageView.frame.size.width ), 0, 0);
    
    containerView = [[UTMiddleEditContainerView alloc] initWithEditInfo:editInfoList];
    containerView.delegate = self;
    [self.view addSubview:containerView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT - [UIDevice safeAreaBottomHeight] - 80, SCREEN_WIDTH - 60, 80) collectionViewLayout:layout];
    [collectionView registerClass:[UTPhotoEditShowImageCollectionViewCell class] forCellWithReuseIdentifier:photoEditShowImageCollectionViewCellIdentify];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:collectionView];
    
    [self makeConstraints];
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

-(void)makeConstraints
{
    [importPhotosButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([UIDevice safeAreaTopHeight] + 6);
        make.leading.equalTo(self.view).offset(25);
        make.width.equalTo(@(111));
        make.height.equalTo(@(30));
    }];
    
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-[UIDevice safeAreaBottomHeight]);
//        make.leading.equalTo(self.view).offset(30);
//        make.trailing.equalTo(self.view).offset(-30);
//        make.height.equalTo(@(80));
//    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(importPhotosButton.bottom).offset(11);
        make.bottom.equalTo(collectionView.top).offset(-22);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
}

-(void)navigationBarSetting
{
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    [rightItem1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"存草稿" style:UIBarButtonItemStylePlain target:self action:@selector(saveInDraft)];
    [rightItem2 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#999999"]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItems:@[rightItem1,rightItem2]];
}

-(void)nextStep
{
    if (imageList.count > 0) {
        [imageList removeAllObjects];
    }
    
    NSMutableArray *axiosInfos = [containerView imagesAxiosToCompose];
    NSString *videoDic = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    videoPath = [NSString stringWithFormat:@"%@/video.mp4",videoDic];
    
    float fps = [[UTVideoManager shareManager] getFpsWithVideoPath:material.templateVideo];
    strategy = [[ComposeStrategy alloc] initWithMaterial:material axiosInfos:axiosInfos fps:fps];
    strategy.delegate = self;
    [strategy createVideoReader];

    compose = [[VideoCompose alloc] initWithVideoUrl:videoPath videoSize:CGSizeMake(544, 960) fps:fps];
    compose.delegate = self;
}

-(void)saveInDraft
{
    
}

-(void)importPhotos
{
    
}

#pragma -mark UICollectionViewDataSource | UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return editInfoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTPhotoEditShowImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoEditShowImageCollectionViewCellIdentify forIndexPath:indexPath];
    if (indexPath.row == selectedRow) {
        [cell setIsSelected:YES];
    }else{
        [cell setIsSelected:NO];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EditInfo *info = [editInfoList objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithEditInfo:info];
        });
    });
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(48.0f,80.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    [containerView scrollToIndexPath:indexPath];
    UTPhotoEditShowImageCollectionViewCell *cell = (UTPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setIsSelected:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [containerView deSelectIndexPath:indexPath];
    UTPhotoEditShowImageCollectionViewCell *cell = (UTPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setIsSelected:NO];
    [cell updateImageView];
}

#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (currentEditView) {
        [currentEditView setPictureImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma -mark UTMiddleEditContainerViewProtocol
-(void)openImagePickerViewFromView:(UTPhotoEditView *)view
{
    currentEditView = view;
    UIImagePickerController *pickerContoller = [[UIImagePickerController alloc] init];
    pickerContoller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerContoller.delegate = self;
    [self presentViewController:pickerContoller animated:YES completion:^{
        
    }];
}

-(void)scrollToIndexPath:(NSIndexPath *)indexPath fromIndex:(NSIndexPath *)fromIndexPath
{
    selectedRow = indexPath.row;
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    UTPhotoEditShowImageCollectionViewCell *toCell = (UTPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [toCell setIsSelected:YES];
    
    UTPhotoEditShowImageCollectionViewCell *fromCell = (UTPhotoEditShowImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:fromIndexPath];
    [fromCell setIsSelected:NO];
    [fromCell updateImageView];
}

#pragma -mark VideoComposeProtocol
-(CMSampleBufferRef)readNextPixelBuffer:(int)frame
{
    if (frame == material.totalFrames-1) {
        return nil;
    }
    CMSampleBufferRef sampleBufferRef = [strategy readVideoFrames:frame];
    return sampleBufferRef;
}

-(void)didWriteToMovie:(int)frame
{
    [strategy cleanMemory];
}

-(void)videoWriteDidFinished:(BOOL)success
{
    if (success) {
        [strategy removeVideoReader];
        NSLog(@"finishWriter");
        dispatch_async(dispatch_get_main_queue(), ^{
            UTVideoComposeViewController *videoComposeVC = [[UTVideoComposeViewController alloc] initWithMaterial:material movieUrl:videoPath images:imageList];
            [self.navigationController pushViewController:videoComposeVC animated:YES];
        });
    }
}

#pragma -mark ComposeStrategyProtocl
-(void)composeImage:(UIImage *)image
{
    [imageList addObject:image];
}
@end
