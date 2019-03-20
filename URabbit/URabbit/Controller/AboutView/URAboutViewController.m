//
//  URAboutViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URAboutViewController.h"
#import "GeneralManager.h"

@interface URAboutViewController ()
@property(nonatomic, strong) IBOutlet UILabel *versionLabel;
@property(nonatomic, strong) IBOutlet UIButton *scoreButton;
@property(nonatomic, strong) IBOutlet UIButton *arrowButton;
@property(nonatomic, strong) IBOutlet UIView *lineView1;
@property(nonatomic, strong) IBOutlet UIView *lineView2;
@property(nonatomic, strong) IBOutlet UIButton *versionCheckButton;
@end

@implementation URAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_versionLabel setText:[AppUtils appVersion]];
    NSString *downLoadHtml = [[GeneralManager defaultManager] returnDownloadHtml];
    BOOL isAuditSuccess = [[GeneralManager defaultManager] isAuditSucess];
    if (downLoadHtml && isAuditSuccess) {
        [_scoreButton setHidden:NO];
        [_arrowButton setHidden:NO];
        [_versionCheckButton setHidden:NO];
        [_lineView1 setHidden:NO];
        [_lineView2 setHidden:NO];
    }else{
        [_scoreButton setHidden:YES];
        [_arrowButton setHidden:YES];
        [_versionCheckButton setHidden:YES];
        [_lineView1 setHidden:YES];
        [_lineView2 setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"关于有兔"];
}

-(IBAction)clickVersionCheckBtn:(id)sender
{
    [[GeneralManager defaultManager] getNewAppVersion:^(BOOL hasNew) {
        if (!hasNew) {
            [AppUtils showInfo:@"当前是最新版本"];
        }
    }];
}

-(IBAction)clickScoreBtn:(id)sender
{
    [[GeneralManager defaultManager] jumpToDownloadHtml];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
