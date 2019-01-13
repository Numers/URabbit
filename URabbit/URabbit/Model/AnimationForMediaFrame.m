//
//  AnimationForMediaFrame.m
//  URabbit
//
//  Created by 鲍利成 on 2019/1/13.
//  Copyright © 2019年 鲍利成. All rights reserved.
//

#import "AnimationForMediaFrame.h"

@implementation AnimationForMediaFrame
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        id locationCenterX = [dic objectForKey:@"locationCentreX"];
        if (locationCenterX) {
            _locationCenterXPercent = [locationCenterX floatValue];
        }else{
            _locationCenterXPercent = 0.5;
        }
        
        id locationCenterY = [dic objectForKey:@"locationCentreY"];
        if (locationCenterY) {
            _locationCenterYPercent = [locationCenterY floatValue];
        }else{
            _locationCenterYPercent = 0.5;
        }
        
        id width = [dic objectForKey:@"width"];
        if (width) {
            _widthPercent = [width floatValue];
        }else{
            _widthPercent = 1.0f;
        }
        
        id height = [dic objectForKey:@"height"];
        if (height) {
            _heightPercent = [height floatValue];
        }else{
            _heightPercent = 1.0f;
        }
        
        id angle = [dic objectForKey:@"angle"];
        if (angle) {
            _angle = [angle floatValue];
        }else{
            _angle = 0.0f;
        }
        
        id blur = [dic objectForKey:@"blur"];
        if (blur) {
            _blur = [blur floatValue];
        }else{
            _blur = 0.0f;
        }
        
        id alpha = [dic objectForKey:@"alpha"];
        if (alpha) {
            _alpha = [alpha floatValue];
        }else{
            _alpha = 1.0f;
        }
    }
    return self;
}
@end
