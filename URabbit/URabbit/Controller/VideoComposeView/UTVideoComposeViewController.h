//
//  UTVideoComposeViewController.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Resource,Composition,DraftTemplate;
@interface UTVideoComposeViewController : UIViewController
-(instancetype)initWithResource:(Resource *)m movieUrl:(NSString *)url composition:(Composition *)composition draftTemplate:(DraftTemplate *)draftTemplate isFromDraft:(BOOL)fromDraft;
@end
