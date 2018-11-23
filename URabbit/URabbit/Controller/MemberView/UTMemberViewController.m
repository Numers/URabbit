//
//  UTMemberViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/23.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTMemberViewController.h"

@interface UTMemberViewController ()
@property(nonatomic, strong) IBOutlet UIImageView *headImageView;
@property(nonatomic, strong) IBOutlet UILabel *nickNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *isMemeberLabel;
@property(nonatomic, strong) IBOutlet UIView *priceBackView;
@end

@implementation UTMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_priceBackView.layer setCornerRadius:5];
    [_priceBackView.layer setBorderColor:[UIColor colorFromHexString:@"#FF5858"].CGColor];
    [_priceBackView.layer setBorderWidth:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
