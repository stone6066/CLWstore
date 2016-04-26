//
//  MaintainModel.h
//  CLWsdht
//
//  Created by koroysta1 on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodModel.h"

@interface MaintainModel : NSObject

@property (nonatomic, copy) NSString *CarBrandId;
@property (nonatomic, copy) NSString *CarBrandName;
@property (nonatomic, copy) NSString *CarModelId;
@property (nonatomic, copy) NSString *CarModelName;
@property (nonatomic, copy) NSString *GarageMobile;
@property (nonatomic, copy) NSString *GarageName;
@property (nonatomic, copy) NSString *GarageOrdersAddDate;
@property (nonatomic, copy) NSString *GarageOrdersId;
@property (nonatomic, copy) NSString *GarageOrdersMobile;
@property (nonatomic, copy) NSString *GarageOrdersState;
@property (nonatomic, copy) NSString *GarageOrdersUsrName;
@property (nonatomic, copy) NSString *GaragePrice;
@property (nonatomic, copy) NSString *GarageSerial;
@property (nonatomic, copy) NSString *Message;
@property (nonatomic, copy) NSString *UsrGarageId;
@property (nonatomic, strong) NSArray *PartsList;

@property (nonatomic, strong) GoodModel *goodmodel;
- (NSArray *)maintainModelWithDict: (NSDictionary *) dataDict;
@end
