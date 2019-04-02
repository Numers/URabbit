//
//  URMemberCompositionDetailsViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URMemberCompositionDetailsViewController.h"
#import "URMemberCompositionInfoView.h"
#import "Composition.h"
#import "UINavigationController+NavigationBar.h"
#import "UIButton+Gradient.h"
#import "URUMShareManager.h"

@interface URMemberCompositionDetailsViewController ()
{
    Composition *currentCompositon;
    URMemberCompositionInfoView *compositionInfoView;
}
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UIButton *shareButton;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *navHeight;
@end

@implementation URMemberCompositionDetailsViewController
-(instancetype)initWithComposition:(Composition *)composition
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"UTMemberCompositionDetailsViewIdentify"];
    if (self) {
        currentCompositon = composition;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _navHeight.constant = [UIDevice safeAreaTopHeight];
    compositionInfoView = [[URMemberCompositionInfoView alloc] initWithVideoSize:CGSizeMake(currentCompositon.videoWidth, currentCompositon.videoHeight) frame:CGRectMake(0, 51, SCREEN_WIDTH, 0)];
    [_scrollView addSubview:compositionInfoView];
    [compositionInfoView setupViewWithComposition:currentCompositon];
    
    [_shareButton setTitleColor:[UIColor colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [_shareButton setBackgroundColor:[UIColor clearColor]];
    [_shareButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, 44) colorArray:@[[UIColor colorFromHexString:@"#FED546"],[UIColor colorFromHexString:@"#FEBD43"]] percentageArray:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
    
    [_titleLabel setText:currentCompositon.title];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,compositionInfoView.frame.origin.y + compositionInfoView.frame.size.height + 65)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (compositionInfoView) {
        [compositionInfoView destroyPlayView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickDeleteBtn:(id)sender
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:currentCompositon.moviePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:currentCompositon.moviePath error:nil];
    }
    
    NSString *sql = [NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"templateId"),bg_sqlValue(@(currentCompositon.templateId)),bg_sqlKey(@"bg_updateTime"),bg_sqlValue(currentCompositon.bg_updateTime)];
    [Composition bg_delete:CompositionTableName where:sql];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickShareBtn:(id)sender
{
    [[URUMShareManager shareManager] indirectShareVideo:[NSURL fileURLWithPath:currentCompositon.moviePath]];
}
@end
