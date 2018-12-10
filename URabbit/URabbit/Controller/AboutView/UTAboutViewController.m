//
//  UTAboutViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTAboutViewController.h"
#import "GeneralManager.h"

@interface UTAboutViewController ()
@property(nonatomic, strong) IBOutlet UILabel *versionLabel;
@end

@implementation UTAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_versionLabel setText:[AppUtils appVersion]];
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
    [[GeneralManager defaultManager] getNewAppVersion];
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