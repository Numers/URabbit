//
//  UTMemberCompositionDetailsViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTMemberCompositionDetailsViewController.h"
#import "UTMemberCompositionInfoView.h"
#import "Composition.h"

@interface UTMemberCompositionDetailsViewController ()
{
    Composition *currentCompositon;
    UTMemberCompositionInfoView *compositionInfoView;
}
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@end

@implementation UTMemberCompositionDetailsViewController
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
    compositionInfoView = [[UTMemberCompositionInfoView alloc] initWithVideoSize:CGSizeMake(currentCompositon.videoWidth, currentCompositon.videoHeight) frame:CGRectMake(0, 51, SCREEN_WIDTH, 0)];
    [_scrollView addSubview:compositionInfoView];
    [compositionInfoView setupViewWithComposition:currentCompositon];
    
    [_titleLabel setText:currentCompositon.title];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,compositionInfoView.frame.origin.y + compositionInfoView.frame.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickShareBtn:(id)sender
{
    
}
@end
