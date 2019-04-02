//
//  URSegmentView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URSegmentView.h"

@implementation URSegmentView
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        scrollView = [[UIScrollView alloc] init];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setBounces:NO];
        [self addSubview:scrollView];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 48, 2)];
        [lineView setBackgroundColor:[UIColor colorFromHexString:@"#FFDE44"]];
        [scrollView addSubview:lineView];
        
        bottomLineView = [[UIView alloc] init];
        [bottomLineView setBackgroundColor:[UIColor colorFromHexString:@"#F5F5F5"]];
        [self addSubview:bottomLineView];
        
        [self makeContraints];
        _buttons = [NSMutableArray array];
        _titleList = [NSMutableArray array];
    }
    return self;
}

-(void)makeContraints
{
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@(38));
    }];
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.bottom);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@(0.5f));
    }];
}

-(void)addTitles:(NSArray *)titles
{
    if (titles && titles.count > 0) {
        if (_buttons.count > 0) {
            [_buttons removeAllObjects];
        }
        
        if (_titleList && _titleList.count > 0) {
            [_titleList removeAllObjects];
        }
        
        for (NSInteger i=0;i<titles.count;i++) {
            NSString *title = [titles objectAtIndex:i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            NSAttributedString *titleString = [AppUtils generateAttriuteStringWithStr:title WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:14.0f]];
            [button setAttributedTitle:titleString forState:UIControlStateNormal];
            [button setFrame:CGRectMake(i * 58, 0, 58, 36)];
            [scrollView addSubview:button];
            [_buttons addObject:button];
        }
        [scrollView setContentSize:CGSizeMake(titles.count * 58, 38)];
        [_titleList addObjectsFromArray:titles];
        [self setSelectedIndex:0 animation:NO];
        if (_selectIndexBlock) {
            _selectIndexBlock(0);
        }
    }
}

-(void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    if (scrollView) {
        [scrollView setContentInset:edgeInsets];
    }
}

-(void)setSelectIndexBlock:(SelectIndexBlock)selectIndexBlock
{
    _selectIndexBlock = selectIndexBlock;
}

-(void)clickButton:(UIButton *)button
{
    [self setSelectedIndex:button.tag animation:YES];
    if (_selectIndexBlock) {
        _selectIndexBlock(button.tag);
    }
}

-(void)setSelectedIndex:(NSInteger)index animation:(BOOL)animation
{
    if (selectedIndex >=0 && selectedIndex != index) {
        UIButton *btn = [_buttons objectAtIndex:selectedIndex];
        NSString *title = [_titleList objectAtIndex:selectedIndex];
        NSAttributedString *attrString = [AppUtils generateAttriuteStringWithStr:title WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:14]];
        [btn setAttributedTitle:attrString forState:UIControlStateNormal];
    }
    
    UIButton *selectBtn = [_buttons objectAtIndex:index];
    NSString *title = [_titleList objectAtIndex:index];
    NSAttributedString *tempAttrString = [AppUtils generateAttriuteStringWithStr:title WithColor:[UIColor colorFromHexString:@"#333333"] WithFont:[UIFont systemFontOfSize:14]];
    [selectBtn setAttributedTitle:tempAttrString forState:UIControlStateNormal];
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            [lineView setFrame:CGRectMake(selectBtn.center.x - 24, selectBtn.frame.origin.y + selectBtn.frame.size.height, 48, 2)];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [lineView setFrame:CGRectMake(selectBtn.center.x - 24, selectBtn.frame.origin.y + selectBtn.frame.size.height, 48, 2)];
    }
    selectedIndex = index;
}
@end
