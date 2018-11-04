//
//  LLTabBar.m
//  LLRiseTabBarDemo
//
//  Created by Meilbn on 10/18/15.
//  Copyright © 2015 meilbn. All rights reserved.
//

#import "LLTabBar.h"

@interface LLTabBar ()

@property (strong, nonatomic) NSMutableArray *tabBarItems;

@end

@implementation LLTabBar

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self config];
	}
	
	return self;
}

#pragma mark - Private Method

- (void)config {
	self.backgroundColor = [UIColor whiteColor];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, -1, SCREEN_WIDTH, 1)];
    [self drawLine:topLine lineLength:SCREEN_WIDTH lineSpacing:0 lineColor:[UIColor clearColor]];
    [self addShadowToView:topLine withColor:[UIColor colorWithRed:196.0f/255 green:196.0f/255 blue:196.0f/255 alpha:1.0f]];
	[self addSubview:topLine];
}


- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.5;
    theView.layer.shadowRadius = 0.5;
    // 单边阴影 顶边
    float shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, theView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
}

- (void)setSelectedIndex:(NSInteger)index {
	for (LLTabBarItem *item in self.tabBarItems) {
		if (item.tag == index) {
			item.selected = YES;
		} else {
			item.selected = NO;
		}
	}
	
    if ([self.delegate respondsToSelector:@selector(currentTabbarController)]) {
        UITabBarController *tabBarController = (UITabBarController *)[self.delegate currentTabbarController];
        if (tabBarController) {
            tabBarController.selectedIndex = index;
        }
    }
}

#pragma mark - Touch Event

- (void)itemSelected:(LLTabBarItem *)sender {
	if (sender.tabBarItemType != LLTabBarItemRise) {
		[self setSelectedIndex:sender.tag];
	} else {
		if (self.delegate) {
			if ([self.delegate respondsToSelector:@selector(tabBarDidSelectedRiseButton)]) {
				[self.delegate tabBarDidSelectedRiseButton];
			}
		}
	}
}

#pragma mark - Setter

- (void)setTabBarItemAttributes:(NSArray<NSDictionary *> *)tabBarItemAttributes {
    _tabBarItemAttributes = tabBarItemAttributes.copy;
    
    CGFloat itemWidth = SCREEN_WIDTH / _tabBarItemAttributes.count;
    CGFloat tabBarHeight = CGRectGetHeight(self.frame);
    NSInteger itemTag = 0;
    BOOL passedRiseItem = NO;
    
    _tabBarItems = [NSMutableArray arrayWithCapacity:_tabBarItemAttributes.count];
    for (id item in _tabBarItemAttributes) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *itemDict = (NSDictionary *)item;
            
            LLTabBarItemType type = [itemDict[kLLTabBarItemAttributeType] integerValue];
            CGRect frame = CGRectMake(itemTag * itemWidth + (passedRiseItem ? itemWidth : 0), 0, itemWidth, tabBarHeight);
            
            LLTabBarItem *tabBarItem = [self tabBarItemWithFrame:frame
                                                           title:itemDict[kLLTabBarItemAttributeTitle]
                                                 normalImageName:itemDict[kLLTabBarItemAttributeNormalImageName]
                                               selectedImageName:itemDict[kLLTabBarItemAttributeSelectedImageName] tabBarItemType:type];
            if (itemTag == 0) {
                tabBarItem.selected = YES;
            }
            
            [tabBarItem addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            if (tabBarItem.tabBarItemType != LLTabBarItemRise) {
                tabBarItem.tag = itemTag;
                itemTag++;
            } else {
                tabBarItem.tag = -1;
                passedRiseItem = YES;
            }
            
            [_tabBarItems addObject:tabBarItem];
            [self addSubview:tabBarItem];
        }
    }
}

- (LLTabBarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(LLTabBarItemType)tabBarItemType {
    LLTabBarItem *item = [[LLTabBarItem alloc] initWithFrame:frame];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:8];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setTitleColor:[UIColor colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorFromHexString:@"#FF5858"] forState:UIControlStateSelected];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}

-(void)drawLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
@end
