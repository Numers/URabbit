//
//  LaunchAnimateView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/4.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "LaunchAnimateView.h"

@implementation LaunchAnimateView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:webView];
        
        UIScrollView *scrollView = [self findScrollViewInWebView];
        if (scrollView) {
            [scrollView setScrollEnabled:NO];
            [scrollView setShowsVerticalScrollIndicator:NO];
            [scrollView setShowsHorizontalScrollIndicator:NO];
        }
        [self loadHTML];
    }
    return self;
}

-(UIScrollView *)findScrollViewInWebView
{
    UIScrollView *scrollView;
    for (UIView *view in webView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
            break;
        }
    }
    return scrollView;
}

- (void)loadHTML {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSURL *baseURL = [url URLByDeletingLastPathComponent];
    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
}

@end
