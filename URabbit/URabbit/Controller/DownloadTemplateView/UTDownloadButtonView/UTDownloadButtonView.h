//
//  UTDownloadButtonView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UTDownloadButtonViewProtocol<NSObject>
-(void)beginDownload;
@end
@interface UTDownloadButtonView : UIView
{
    UIButton *downloadButton;
}
@property(nonatomic, weak) id<UTDownloadButtonViewProtocol> delegate;
-(void)setProgress:(CGFloat)progress;
-(void)setButtonTitle:(NSString *)title;
@end
