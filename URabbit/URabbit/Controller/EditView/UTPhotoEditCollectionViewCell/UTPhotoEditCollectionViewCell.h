//
//  UTPhotoEditCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditInfo,UTPhotoEditView,AxiosInfo;
@protocol UTPhotoEditCollectionViewCellProtocol<NSObject>
-(void)openImagePickerViewFromView:(UTPhotoEditView *)view;
@end
@interface UTPhotoEditCollectionViewCell : UICollectionViewCell
{
    EditInfo *editInfo;
    UTPhotoEditView *editView;
}
@property(nonatomic, weak) id<UTPhotoEditCollectionViewCellProtocol> delegate;
-(void)setupCellWithEditInfo:(EditInfo *)info;
-(UIImage *)tranferViewToImage;
-(AxiosInfo *)generateAxiosInfo;
@end
