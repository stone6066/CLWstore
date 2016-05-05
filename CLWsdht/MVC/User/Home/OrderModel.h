//
//  OrderModel.h
//  CLWsdht
//
//  Created by koroysta1 on 16/4/12.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodModel.h"

@interface OrderModel : NSObject

@property (nonatomic, copy) NSString *StoreImg;
@property (nonatomic, copy) NSString *StoreUrl;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *StoreName;//店铺名称
@property (nonatomic, copy) NSString *PartsMobile;//来源
@property (nonatomic, copy) NSString *StoreId;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *GarageState;
@property (nonatomic, copy) NSString *Addr;//收货地址
@property (nonatomic, copy) NSString *Serial;

@property (nonatomic, strong) NSArray *PartsList;

@property (nonatomic, strong) GoodModel *goodmodel;
- (NSArray *)assignModelWithDict: (NSDictionary *) dataDict;

@end
