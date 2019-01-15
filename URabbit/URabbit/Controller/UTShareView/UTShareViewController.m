//
//  UTShareViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTShareViewController.h"

@interface UTShareViewController ()

@end

@implementation UTShareViewController
-(instancetype)init
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"UTShareViewIdentify"];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self clickCancelBtn:nil];
}

-(IBAction)clickWeixinBtn:(id)sender
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(sendShareToWeixin)]) {
            [self.delegate sendShareToWeixin];
        }
    }];
}

-(IBAction)clickFriendBtn:(id)sender
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(sendShareToFriend)]) {
            [self.delegate sendShareToFriend];
        }
    }];
}

-(IBAction)clickQQBtn:(id)sender
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(sendShareToQQ)]) {
            [self.delegate sendShareToQQ];
        }
    }];
}

-(IBAction)clickWeiboBtn:(id)sender
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(sendShareToWeibo)]) {
            [self.delegate sendShareToWeibo];
        }
    }];
}

-(IBAction)clickCancelBtn:(id)sender
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
