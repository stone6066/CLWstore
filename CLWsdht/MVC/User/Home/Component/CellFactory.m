//
//  CellFactory.m
//  MFSC
//
//  Created by mfwl on 16/3/21.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "CellFactory.h"

@implementation CellFactory

+ (BaseTableViewCell *)creatCellWithClassName:(NSString *)cellClassName cellModel:(BaseModel *)cellModel indexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    
    // 通过反射来定义cell，当遇到cell拓展时，可以直接用字符串反射，无需修改该工厂方法
    
//    Class classForCell = NSClassFromString(cellClassName);
    
    // 初始化目标cell
    
    cell = [[[NSBundle mainBundle] loadNibNamed:cellClassName owner:nil options:nil] firstObject];
    
    if (cellModel) {
        cell.model = cellModel;
    }
    
    return cell;
    

}





@end
