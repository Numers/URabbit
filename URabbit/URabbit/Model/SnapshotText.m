//
//  SnapshotText.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "SnapshotText.h"
#import "Custom.h"
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
        if (textName) {
            _text = [self filterTextWithName:textName inArray:custom.textList];
        }
    }
    return self;
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
