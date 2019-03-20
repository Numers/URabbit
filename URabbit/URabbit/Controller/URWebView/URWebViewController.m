//
//  URWebViewController.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URWebViewController.h"
#import "UINavigationController+NavigationBar.h"

@interface URWebViewController ()
@property(nonatomic, strong) UIView *bgView;
@end

@implementation URWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ViewBackgroundColor];
    [self setTintColor:[UIColor colorFromHexString:@"#333333"]];
    [self.progressView setTrackTintColor:[UIColor whiteColor]];
    [self.progressView setProgressTintColor:[UIColor colorFromHexString:@"#2D99F6"]];
    
    if ([AppUtils isNetworkURL:_loadUrl]) {
        [self webViewLoadUrl];
    }
    
    if (![AppUtils isNullStr:_navTitle]) {
        self.title = _navTitle;
    }
    self.showsPageTitleInNavigationBar = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UIDesigner
-(void)loadSuccess:(BOOL)success
{
    if (success) {
        if (self.wkWebView) {
            [self.wkWebView setHidden:NO];
        }
        if (_bgView) {
            [_bgView setHidden:YES];
        }
    }else{
        if (self.wkWebView) {
            [self.wkWebView setHidden:YES];
        }
        if (_bgView) {
            [_bgView setHidden:NO];
        }else{
            [self addNoNetworkBackgroundView];
        }
    }
}

-(void)refreshWebView
{
    if (_bgView) {
        [_bgView setHidden:YES];
    }
    
    if (self.wkWebView) {
        [self.wkWebView setHidden:NO];
        if (![AppUtils isNullStr:self.wkWebView.URL.absoluteString]) {
            [self.wkWebView reload];
        }else{
            if ([AppUtils isNetworkURL:_loadUrl]) {
                [self webViewLoadUrl];
            }
        }
    }
}

-(void)addNoNetworkBackgroundView
{
    if (_bgView == nil) {
        UIImage *bgimage = [UIImage imageNamed:@"NoNetworkBackgroundImage"];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgimage.size.width, bgimage.size.height + 2 + 20 + 35 + 30)];
        {
            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgimage.size.width, bgimage.size.height)];
            [bgImageView setImage:bgimage];
            [_bgView addSubview:bgImageView];
        }
        
        {
            UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, bgimage.size.height + 0.67, bgimage.size.width, 20.0f)];
            [lblDesc setFont:[UIFont systemFontOfSize:14.0f]];
            [lblDesc setTextAlignment:NSTextAlignmentCenter];
            [lblDesc setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
            [lblDesc setText:@"网络正在开小差..."];
            [_bgView addSubview:lblDesc];
        }
        
        {
            UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 106.f, 30.0f)];
            [refreshBtn addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
            NSAttributedString *attrTitle = [[NSAttributedString alloc]initWithString:@"点击刷新" attributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#55A8FD"],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
            [refreshBtn setAttributedTitle:attrTitle forState:UIControlStateNormal];
            [refreshBtn.layer setCornerRadius:15.0f];
            [refreshBtn.layer setMasksToBounds:YES];
            [refreshBtn.layer setBorderWidth:1.0f];
            [refreshBtn.layer setBorderColor:[UIColor colorFromHexString:@"#55A8FD"].CGColor];
            [refreshBtn setCenter:CGPointMake(_bgView.frame.size.width / 2.0f, _bgView.frame.size.height - 15)];
            [_bgView addSubview:refreshBtn];
        }
        [_bgView setCenter:CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f)];
        [self.view insertSubview:_bgView atIndex:0];
    }
}

-(void)setLoadUrl:(NSString *)loadUrl
{
    if ([AppUtils isNetworkURL:loadUrl]) {
        _loadUrl = loadUrl;
    }
}

-(void)webViewLoadUrl
{
    if ([AppUtils isNetworkURL:_loadUrl]){
        [self loadURL:[NSURL URLWithString:_loadUrl]];
    }
}

#pragma -mark WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //    [self initToolBarItems];
    [self loadSuccess:YES];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self loadSuccess:NO];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self loadSuccess:NO];
}
@end
