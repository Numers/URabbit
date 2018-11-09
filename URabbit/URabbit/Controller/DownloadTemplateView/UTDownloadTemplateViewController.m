//
//  UTDownloadTemplateViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTDownloadTemplateViewController.h"
#import "HomeTemplate.h"
#import "EditInfo.h"

#import "UTDownloadButtonView.h"
#import "UTVideoInfoView.h"
#import "UTVideoAuthorView.h"
#import "Material.h"

#import "UTPhotoEditViewController.h"

@interface UTDownloadTemplateViewController ()<UTDownloadButtonViewProtocol>
{
    HomeTemplate *currentHomeTemplate;
    Material *materia;
    NSMutableArray *editInfoList;
    
    UTDownloadButtonView *makeButtonView;
    UIScrollView *scrollView;
    UTVideoInfoView *videoInfoView;
    UTVideoAuthorView *videoAuthorView;
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
    editInfoList = [NSMutableArray array];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scrollView setContentInset:UIEdgeInsetsMake(0, 0, [UIDevice safeAreaBottomHeight], 0)];
    [self.view addSubview:scrollView];
    
    videoInfoView = [[UTVideoInfoView alloc] initWithHomeTemplate:currentHomeTemplate frame:CGRectMake(0,17, SCREEN_WIDTH, 0)];
    [scrollView addSubview:videoInfoView];
    videoAuthorView = [[UTVideoAuthorView alloc] initWithHomeTemplate:currentHomeTemplate frame:CGRectMake(0, videoInfoView.frame.origin.y + videoInfoView.frame.size.height, SCREEN_WIDTH, 77)];
    [scrollView addSubview:videoAuthorView];
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,[UIDevice safeAreaTopHeight] + 17 + videoInfoView.frame.size.height + videoAuthorView.frame.size.height)];
    
    makeButtonView = [[UTDownloadButtonView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - [UIDevice safeAreaBottomHeight] - 72.0f, SCREEN_WIDTH, 72.0f)];
    makeButtonView.delegate = self;
    [self.view addSubview:makeButtonView];
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
    [self.navigationItem setTitle:currentHomeTemplate.name];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share_button"] style:UIBarButtonItemStylePlain target:self action:@selector(clickShareButton)];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collection_button"] style:UIBarButtonItemStylePlain target:self action:@selector(clickCollectionButton)];
    rightItem2.imageInsets = UIEdgeInsetsMake(0, 15, 0, -10);
    [self.navigationItem setRightBarButtonItems:@[rightItem1,rightItem2]];
    
}

-(void)generateMaterial
{
    materia = [[Material alloc] initWithFileUrl:currentHomeTemplate.materialPath];
}

-(void)clickShareButton
{
    
}

-(void)clickCollectionButton
{
    
}

#pragma -mark UTDownloadButtonViewProtocol
-(void)beginDownload
{
    if (editInfoList.count > 0) {
        [editInfoList removeAllObjects];
    }
    [self generateMaterial];
    EditInfo *info = [[EditInfo alloc] init];
    info.editImage = [UIImage imageNamed:@"template1"];
    info.originSize = info.editImage.size;
    info.editImageCenterXPercent = 0.5;
    info.editImageCenterYPercent = (544.0f/2)/960.0f;
    info.range = NSMakeRange(0, 375);
    info.animationType = AnimationRotation;
    [editInfoList addObject:info];
    UTPhotoEditViewController *photoEditVC = [[UTPhotoEditViewController alloc] initWithMaterial:materia editInfo:editInfoList];
    [self.navigationController pushViewController:photoEditVC animated:YES];
}
@end
