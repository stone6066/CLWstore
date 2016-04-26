//
//  TableViewSectionIndexTitlesView.h
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TableViewSectionIndexTitlesViewDelegate <NSObject>

- (void)scrollerToSection:(NSInteger)section withIndex:(NSString *)index;

@end


@interface TableViewSectionIndexTitlesView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) id <TableViewSectionIndexTitlesViewDelegate> delegate;

@end
