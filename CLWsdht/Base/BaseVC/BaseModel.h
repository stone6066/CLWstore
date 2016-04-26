//
//  BaseModel.h
//  ceshi1
//
//  Created by mfwl on 16/1/26.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Sort;
@property (nonatomic, copy) NSString *Letter;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *SIG;
@property (nonatomic, copy) NSString *content;


@property (nonatomic, copy) NSString *CarBrandId;
@property (nonatomic, copy) NSString *CarModelId;
@property (nonatomic, copy) NSString *PartsUseForId;

@property (nonatomic ,copy) NSString *AddDate;
@property (nonatomic ,copy) NSString *CarBrandName;
@property (nonatomic ,copy) NSString *CarModelName;
@property (nonatomic ,copy) NSString *CityId;
@property (nonatomic ,copy) NSString *CityName;
@property (nonatomic ,assign) NSInteger Cnt;
@property (nonatomic ,copy) NSString *Description;
@property (nonatomic ,assign) NSInteger Displacement;
@property (nonatomic ,assign) NSInteger Enable;
@property (nonatomic ,copy) NSString *EndDate;
@property (nonatomic ,assign) NSInteger Year;
@property (nonatomic ,copy) NSString *Img;
@property (nonatomic ,assign) NSInteger Mobile;
@property (nonatomic ,copy) NSString *PartsTypeId;
@property (nonatomic ,copy) NSString *PartsTypeName;
@property (nonatomic ,assign) NSInteger Views;
@property (nonatomic ,copy) NSString *PartsUseForName;
@property (nonatomic ,copy) NSString *ProvincialId;
@property (nonatomic ,copy) NSString *ProvincialName;
@property (nonatomic ,copy) NSString *Reason;
@property (nonatomic ,copy) NSString *RespondId;
@property (nonatomic ,assign) NSInteger State;
@property (nonatomic ,copy) NSString *Title;
@property (nonatomic ,copy) NSString *Url;
@property (nonatomic ,copy) NSString *UsrId;
@property (nonatomic ,copy) NSString *UsrName;



@property (nonatomic ,copy) NSString *CarModelSIG;
@property (nonatomic ,copy) NSString *ColourId;
@property (nonatomic ,copy) NSString *ColourName;
@property (nonatomic ,assign) NSInteger Price;
@property (nonatomic ,copy) NSString *PurityId;
@property (nonatomic ,copy) NSString *PurityName;
@property (nonatomic ,copy) NSString *StoreName;
@property (nonatomic ,copy) NSString *TypeName;
@property (nonatomic ,copy) NSString *UseForName;
@property (nonatomic ,copy) NSString *UsrStoreId;
@property (nonatomic ,copy) NSString *PartsSrcName;



+ (id)modelWithDictionary:(NSDictionary *)dic;

@end
