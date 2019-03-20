//
//  URVideoComposeResultViewController.h
//  URabbit
//
//  Created by 鲍利成 on 2019/3/20.
//  Copyright © 2019 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Resource,Composition,DraftTemplate;
@interface URVideoComposeResultViewController : UIViewController
-(instancetype)initWithResource:(Resource *)m movieUrl:(NSString *)url composition:(Composition *)composition draftTemplate:(DraftTemplate *)draftTemplate isFromDraft:(BOOL)fromDraft;
@end
