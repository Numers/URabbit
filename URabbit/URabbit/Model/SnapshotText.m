//
//  SnapshotText.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "SnapshotText.h"
#import "Custom.h"
#import "UTTextLabel.h"
#import "Text.h"
@implementation SnapshotText
-(instancetype)initWithDictionary:(NSDictionary *)dic withCustom:(Custom *)custom
{
    self = [super init];
    if (self) {
        _centerXPercent = [[dic objectForKey:@"centreX"] floatValue];
        _centerYPercent = [[dic objectForKey:@"centreY"] floatValue];
        _widthPercent = [[dic objectForKey:@"width"] floatValue];
        _heightPercent = [[dic objectForKey:@"height"] floatValue];
        _angle = [[dic objectForKey:@"angle"] floatValue];
        _opacity = [[dic objectForKey:@"pellucidity"] floatValue];
        NSString *textName = [dic objectForKey:@"name"];
        _textLabel = [[UTTextLabel alloc] init];
        if (textName) {
            _textName = textName;
            _textLabel.textName = textName;
            _text = [self filterTextWithName:textName inArray:custom.textList];
            if (_text) {
//                if (_text.fontSize > 0) {
//                    [_textLabel setFont:[UIFont systemFontOfSize:_text.fontSize]];
//                }

                if (_text.fontColor) {
                    [_textLabel setTextColor:[UIColor colorFromHexString:_text.fontColor]];
                }
                switch (_text.horizontalAlignType) {
                    case TextHorizontalAlignLeft:
                        [_textLabel setTextAlignment:NSTextAlignmentLeft];
                        break;
                    case TextHorizontalAlignRight:
                        [_textLabel setTextAlignment:NSTextAlignmentRight];
                        break;
                    case TextHorizontalAlignCenter:
                        [_textLabel setTextAlignment:NSTextAlignmentCenter];
                        break;
                    default:
                        break;
                }
                
                switch (_text.verticalAlignType) {
                    case TextVerticalAlignTop:
                        [_textLabel setVerticalAlignment:VerticalAlignmentTop];
                        break;
                    case TextVerticalAlignBottom:
                        [_textLabel setVerticalAlignment:VerticalAlignmentBottom];
                        break;
                    case TextVerticalAlignCenter:
                        [_textLabel setVerticalAlignment:VerticalAlignmentMiddle];
                        break;
                    default:
                        break;
                }
                
                [_textLabel setText:_text.content];
            }
        }
    }
    return self;
}

-(void)changeText:(NSString *)text
{
    [_textLabel setText:text];
    _text.content = text;
}


-(Text *)filterTextWithName:(NSString *)name inArray:(NSArray *)array
{
    Text *text = nil;
    NSArray *filterArray = [AppUtils fiterArray:array fieldName:@"name" value:name];
    if (filterArray && filterArray.count > 0) {
        text = [filterArray objectAtIndex:0];
    }
    return text;
}
@end
