//
//  URPictureImageLayerView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol URPictureImageLayerViewProtocol<NSObject>
-(void)selectPictureWithMediaName:(NSString *)mediaName;
@end
@interface URPictureImageLayerView : UIImageView
{
    UITapGestureRecognizer *tapGesture;
}
@property(nonatomic, copy) NSString *mediaName;
@property(nonatomic, weak) id<URPictureImageLayerViewProtocol> delegate;
@end
