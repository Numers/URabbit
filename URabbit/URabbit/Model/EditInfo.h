//
//  EditInfo.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface EditInfo : NSObject
@property(nonatomic, strong) UIImage *editImage;
@property(nonatomic) NSRange range;
@property(nonatomic) CGSize originSize;
@property(nonatomic) CGFloat editImageCenterXPercent;
@property(nonatomic) CGFloat editImageCenterYPercent;
@property(nonatomic) AnimationType animationType;
@end
