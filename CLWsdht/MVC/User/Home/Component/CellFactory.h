//
//  CellFactory.h
//  MFSC
//
//  Created by mfwl on 16/3/21.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "BaseTableViewCell.h"

@interface CellFactory : NSObject


+ (BaseTableViewCell *)creatCellWithClassName:(NSString *)cellClassName cellModel:(BaseModel *)cellModel indexPath:(NSIndexPath *)indexPath;


@end
