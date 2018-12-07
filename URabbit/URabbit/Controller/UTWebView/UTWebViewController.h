//
//  UTWebViewController.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <KINWebBrowser/KINWebBrowserViewController.h>

@interface UTWebViewController : KINWebBrowserViewController
@property(nonatomic, copy) NSString *loadUrl;
@property(nonatomic, copy) NSString *navTitle;
@end
