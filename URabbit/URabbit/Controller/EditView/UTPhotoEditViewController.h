//
//  UTPhotoEditViewController.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Resource;
@interface UTPhotoEditViewController : UIViewController
{

}
-(instancetype)initWithResource:(Resource *)resource snapshots:(NSMutableArray *)snapshots;
@end
