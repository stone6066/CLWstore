//
//  BackBtView.h
//  CLWsdht
//
//  Created by mfwl on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, BtViewStyle) {
    Single,
    Double,
};


@protocol BackBtViewDelegate <NSObject>

- (void)pass;

@end

@interface BackBtView : UIButton


@property (nonatomic, assign) id <BackBtViewDelegate> delegate;

- (instancetype)initWithBtViewStyle:(BtViewStyle)style;

@end
