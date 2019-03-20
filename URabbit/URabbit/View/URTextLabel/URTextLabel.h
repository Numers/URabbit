//
//  URTextLabel.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentDefault = 0,
    VerticalAlignmentTop, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@protocol URTextLabelProtocol <NSObject>
-(void)didSelectTextLabelWithName:(NSString *)name content:(NSString *)content;
@end
@interface URTextLabel : UILabel
{
    UITapGestureRecognizer *tapGesture;
}
@property(nonatomic, weak) id<URTextLabelProtocol> delegate;
@property (nonatomic) VerticalAlignment verticalAlignment;
@property(nonatomic, copy) NSString *textName;
@end
