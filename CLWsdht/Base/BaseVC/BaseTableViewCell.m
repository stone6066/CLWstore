//
//  BaseTableViewCell.m
//  MFSC
//
//  Created by mfwl on 16/3/21.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseModel.h"

@implementation BaseTableViewCell


- (void)setModel:(BaseModel *)model {
    if (_model != model) {
        _model = model;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
