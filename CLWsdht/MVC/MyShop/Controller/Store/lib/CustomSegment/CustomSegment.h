//
//  CustomSegment.h
//  test
//
//  Created by yang on 16/3/29.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegmentDelegate <NSObject>

- (void)segmentSelectWith:(NSInteger)index;

@end

@interface CustomSegment : UIView

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items;

@property (nonatomic, assign) id<CustomSegmentDelegate>delegate;

@property (nonatomic, strong) UIColor *segmentBackColor;

@property (nonatomic, strong) UIColor *lineVieColor;

@property (nonatomic, strong) UIColor *buttonNormalColor;

@property (nonatomic, strong) UIColor *buttonSelectColor;

@property (nonatomic, assign) NSInteger selectItem;

- (void)scrollSetLinviewLocationWith:(CGFloat)offset;

@end
