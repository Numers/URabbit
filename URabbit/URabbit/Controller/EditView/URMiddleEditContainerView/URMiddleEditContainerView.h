//
//  URMiddleEditContainerView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class URPhotoEditView;
@protocol URMiddleEditContainerViewProtocol <NSObject>
-(void)openImagePickerViewFromView:(URPhotoEditView *)view scale:(CGFloat)scale;
-(void)scrollToIndexPath:(NSIndexPath *)indexPath fromIndex:(NSIndexPath *)fromIndexPath;
@end
@interface URMiddleEditContainerView : UIView
{
    NSMutableArray *dataSource;
    UIScrollView *scrollView;
    NSMutableArray *cells;
    TemplateStyle currentStyle;
}
@property(nonatomic, weak) id<URMiddleEditContainerViewProtocol> delegate;
@property(nonatomic) BOOL isGenerateData;
-(instancetype)initWithSnapshots:(NSMutableArray *)snapshots style:(TemplateStyle)style;
-(void)generateEditViews;
-(void)scrollToIndexPath:(NSIndexPath *)indexPath;
-(UIImage *)deSelectIndexPath:(NSIndexPath *)indexPath;
-(void)generateImagesToCompose;
@end
