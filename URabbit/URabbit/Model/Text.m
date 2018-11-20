//
//  Text.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "Text.h"

@implementation Text
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _name = [dic objectForKey:@"name"];
        _content = [dic objectForKey:@"content"];
        _fontUrl = [dic objectForKey:@"fontUrl"];
        _fontSize = [[dic objectForKey:@"fontSize"] floatValue];
        _fontColor = [dic objectForKey:@"fontColor"];
        _wordLimit = [[dic objectForKey:@"wordLimit"] integerValue];
        _horizontalAlignType = (TextHorizontalAlignType)[[dic objectForKey:@"align"] integerValue];
        _verticalAlignType = (TextVerticalAlignType)[[dic objectForKey:@"valign"] integerValue];
        _rowLimit = [[dic objectForKey:@"rowLimit"] integerValue];
        _direction = [[dic objectForKey:@"direction"] integerValue];
    }
    return self;
}
@end
