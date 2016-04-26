//
//  BaseTableViewCell.h
//  MFSC
//
//  Created by mfwl on 16/3/21.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseModel;

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) BaseModel *model;



@end
