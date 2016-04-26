//
//  CustomSegment.m
//  test
//
//  Created by yang on 16/3/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "CustomSegment.h"

#define kLineColor [UIColor colorWithRed:187/256.0 green:16/256.0 blue:13/256.0 alpha:1]
#define kButtonHeight 40
#define kSpace 2

@implementation CustomSegment
{
    NSMutableArray *buttonArray;
    NSArray *buttonNameArray;
    CGFloat width;
    CGFloat height;
    UIView  *LineView;
    NSInteger originalIndex;
}

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items
{
    if (self = [super initWithFrame:frame]) {
        buttonNameArray = items;
        width = self.frame.size.width / items.count;
        height = self.frame.size.height;
        LineView = [[UIView alloc] initWithFrame:CGRectMake(0, kButtonHeight, width, kSpace)];
        [self addSubview:LineView];
        //默认设置
        self.segmentBackColor = [UIColor colorWithRed:246/256.0 green:247/256.0 blue:249/256.0 alpha:1];
        self.lineVieColor = kLineColor;
        self.selectItem = 0;
        buttonArray = [NSMutableArray array];
        [self creatButton];
        
    }
    return self;
}

- (void)creatButton
{
    for (int i = 0; i < buttonNameArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonNameArray[i] forState:UIControlStateNormal];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:kLineColor forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        button.frame = CGRectMake(width * i, 0, width, kButtonHeight);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttonArray addObject:button];
        }
    [buttonArray[0] setSelected:YES];
}

- (void)buttonClick:(UIButton *)sender
{
    NSInteger currIndex = sender.tag - 100;
    
    [self setLineViewLocationWith:currIndex andTime:0.33];
}

- (void)setLineViewLocationWith:(NSInteger)index andTime:(CGFloat)time
{
    if (index != originalIndex) {
        [buttonArray[index] setSelected:YES];
        [buttonArray[originalIndex] setSelected:NO];
        [UIView animateWithDuration:time animations:^{
            LineView.frame = CGRectMake(index * width, kButtonHeight, width, kSpace);
        }];
        originalIndex = index;
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(segmentSelectWith:)]) {
            [self.delegate segmentSelectWith:index];
        }
    }
}

- (void)scrollSetLinviewLocationWith:(CGFloat)offset
{
    [buttonArray[originalIndex] setSelected:NO];
    [buttonArray[[[NSNumber numberWithFloat:offset] intValue]] setSelected:YES];
    LineView.frame = CGRectMake(offset * width, kButtonHeight, width, kSpace);
    originalIndex = offset;
}

- (void)setSegmentBackColor:(UIColor *)segmentBackColor
{
    _segmentBackColor = segmentBackColor;
    self.backgroundColor = segmentBackColor;
}

- (void)setLineVieColor:(UIColor *)lineVieColor
{
    _lineVieColor = lineVieColor;
    LineView.backgroundColor = lineVieColor;
}

- (void)setButtonNormalColor:(UIColor *)buttonNormalColor
{
    _buttonNormalColor = buttonNormalColor;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = buttonArray[i];
        [button setTitleColor:buttonNormalColor forState:UIControlStateNormal];
    }
}

- (void)setButtonSelectColor:(UIColor *)buttonSelectColor
{
    _buttonSelectColor = buttonSelectColor;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = buttonArray[i];
        [button setTitleColor:buttonSelectColor forState:UIControlStateSelected];
    }
}

- (void)setSelectItem:(NSInteger)selectItem
{
    _selectItem = selectItem;
    [self setLineViewLocationWith:selectItem andTime:0];
}

@end
