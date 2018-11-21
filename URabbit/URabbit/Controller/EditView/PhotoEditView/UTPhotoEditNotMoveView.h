//
//  UTPhotoEditNotMoveView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditView.h"

@interface UTPhotoEditNotMoveView : UTPhotoEditView
-(void)setPictureImage:(UIImage *)image;
-(void)generateImageWithSize:(CGSize)size style:(TemplateStyle)style;
@end
