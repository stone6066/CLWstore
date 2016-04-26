//
//  ReleaseRequireModel.h
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "BaseModel.h"

@interface ReleaseRequireModel : BaseModel


@property (nonatomic, strong) NSArray *T_DicCarModel; /* 车辆详细类型 */
@property (nonatomic, strong) NSArray *T_DicPartsType; /* 配件详细类型 */
@property (nonatomic, strong) NSArray *T_DicCity;



@end
