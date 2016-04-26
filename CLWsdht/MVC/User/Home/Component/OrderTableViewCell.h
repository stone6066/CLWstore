//
//  OrderTableViewCell.h
//  CLWsdht
//
//  Created by koroysta1 on 16/4/12.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Url;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UILabel *Cnt;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

- (void)setOrderWithModel:(GoodModel *)model andWtihState:(NSString *)state;
- (void)assginOrderWithModel:(GoodModel *)cellModel;


@end
