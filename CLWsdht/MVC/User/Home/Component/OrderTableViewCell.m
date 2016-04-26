//
//  OrderTableViewCell.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/12.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation OrderTableViewCell


- (void)setOrderWithModel:(GoodModel *)model andWtihState:(NSString *)state{
    [_Url sd_setImageWithURL:[NSURL URLWithString:model.Url]];
    [_Name setText:model.Name];
    [_Price setText:[NSString stringWithFormat:@"%@",model.Price]];
    [_Cnt setText:[NSString stringWithFormat:@"X%@",model.Cnt]];
    if (![state isEqualToString:@"0"]) {
        [_changeBtn setHidden:YES];
    }
    else{
        [_changeBtn setHidden:NO];
    }
    
}

- (void)assginOrderWithModel:(GoodModel *)cellModel{
    [_Url sd_setImageWithURL:[NSURL URLWithString:cellModel.Url]];
    [_Name setText:cellModel.Name];
    [_Price setText:[NSString stringWithFormat:@"%@",cellModel.Price]];
    [_Cnt setText:[NSString stringWithFormat:@"X%@",cellModel.Cnt]];
    [_changeBtn setHidden:YES];
}
- (IBAction)changeThePrice:(UIButton *)sender {
    NSLog(@"zhangmeng123");
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
