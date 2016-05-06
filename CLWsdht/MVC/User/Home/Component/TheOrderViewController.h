//
//  TheOrderViewController.h
//  CLWsdht
//
//  Created by koroysta1 on 16/4/8.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
#import "OrderModel.h"

@interface TheOrderViewController : UIViewController

@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, copy) NSString *orderState;
@property (nonatomic, copy) NSString *storeId;

- (void)changGoodPrice:(GoodModel *)goodModel andWithModel:(OrderModel *)orderModel andWithChangePrice:(NSString *)text;
@end
