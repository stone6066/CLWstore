//
//  MyShopModel.h
//  CLWsdht
//
//  Created by yang on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyShopModel : NSObject

#warning 没有加注释的字段的类型没有确认, 需要赋值是要确认字段的类型
@property (nonatomic, strong) NSString *AddDate;

@property (nonatomic, strong) NSString *CarModelSIG;

@property (nonatomic, strong) NSString *CityId;

@property (nonatomic, strong) NSString *ColourId;

@property (nonatomic, strong) NSString *ColourName;

@property (nonatomic, strong) NSString *Description;

@property (nonatomic, strong) NSString *Enable;

@property (nonatomic, strong) NSString *Id;//id

@property (nonatomic, strong) NSString *Img;

@property (nonatomic, strong) NSString *Mobile;

@property (nonatomic, strong) NSString *Name;//商品名

@property (nonatomic, strong) NSString *PartsSrcId;

@property (nonatomic, strong) NSString *PartsSrcName;//部位

@property (nonatomic, strong) NSString *PartsTypeId;

@property (nonatomic, strong) NSString *PartsUseForId;

@property (nonatomic, assign) NSInteger Price;//价钱

@property (nonatomic, strong) NSString *ProvincialId;

@property (nonatomic, strong) NSString *PurityId;

@property (nonatomic, strong) NSString *PurityName;//新旧程度

@property (nonatomic, assign) NSInteger State;//上下架状态(1 上架  0 下架)

@property (nonatomic, strong) NSString *StoreName;//商店名

@property (nonatomic, strong) NSString *TypeName;

@property (nonatomic, strong) NSString *Url;//图片

@property (nonatomic, strong) NSString *UseForName;

@property (nonatomic, strong) NSString *UsrStoreId;

@property (nonatomic, strong) NSString *Views;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
