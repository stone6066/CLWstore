//
//  MyWalletModel.h
//  CLWsdht
//
//  Created by yang on 16/4/16.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWalletModel : NSObject

@property (nonatomic, assign) NSInteger Balance;//钱包钱数

//Completed 已结算单数
//CompletedPrice 已结算钱数
//Waiting 待结算单数
//WaitingPrice 待结算钱数
@property (nonatomic, strong) NSDictionary *Count;//结算订单信息

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
