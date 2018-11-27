//
//  UTPhotoEditViewController.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Resource,Composition,DraftTemplate;
@interface UTPhotoEditViewController : UIViewController
{
    Composition *currentComposition;
    DraftTemplate *draftTemplate;
}
-(instancetype)initWithResource:(Resource *)resource snapshots:(NSMutableArray *)snapshots compositon:(Composition *)composition;
@end
