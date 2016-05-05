//
//  OrderTableViewCell.h
//  CLWsdht
//
//  Created by koroysta1 on 16/4/12.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
#import "OrderModel.h"
#import "TheOrderViewController.h"

@interface OrderTableViewCell : UITableViewCell

@property (weak, nonatomic) TheOrderViewController* controller;
@property (weak, nonatomic) IBOutlet UIImageView *Url;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UILabel *Cnt;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UITextField *changTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, strong) OrderModel *OM;
@property (nonatomic, strong) GoodModel *GM;

- (void)setOrderWithModel:(GoodModel *)model andWtihState:(NSString *)state andWithOrderModel:(OrderModel *)om;
- (void)assginOrderWithModel:(GoodModel *)cellModel;


@end
