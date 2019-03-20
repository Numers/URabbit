//
//  UTPhotoEditView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Snapshot,URTplImageLayerView,URPictureImageLayerView;
@protocol UTPhotoEditViewProtocol <NSObject>
-(void)openImagePickerViewWithScale:(CGFloat)scale;
@end
@interface UTPhotoEditView : UIView
{
    
}
@property(nonatomic, strong) URTplImageLayerView *templateImageView;
@property(nonatomic, weak) id<UTPhotoEditViewProtocol> delegate;
-(instancetype)initWithSnapshot:(Snapshot *)snapshot frame:(CGRect)frame;
@end
