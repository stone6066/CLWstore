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
#import "TheOrderViewController.h"

@implementation OrderTableViewCell




- (void)setOrderWithModel:(GoodModel *)model andWtihState:(NSString *)state andWithOrderModel:(OrderModel *)om{

    [_sureBtn setHidden:YES];
    [_Url sd_setImageWithURL:[NSURL URLWithString:model.Url]];
    [_Name setText:model.Name];
    NSString *string = model.CurrentPrice;
    if ([string isKindOfClass:[NSNull class]]) {
        [_Price setText:[NSString stringWithFormat:@"¥%@",model.Price]];
    }else{
        [_Price setText:[NSString stringWithFormat:@"¥%@",model.CurrentPrice]];
    }
    [_Cnt setText:[NSString stringWithFormat:@"X%@",model.Cnt]];
    [_changTextField setHidden:YES];
    if (![state isEqualToString:@"0"]) {
        [_changeBtn setHidden:YES];
    }
    else{
        [_changeBtn setHidden:NO];
    }
    _OM = om;
    _GM = model;
    
    // 我们喜欢听ChangeTheme的广播
    // 注册成为广播站ChangeTheme频道的听众
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 成为听众一旦有广播就来调用self recvBcast:函数
    [nc addObserver:self selector:@selector(changePrice:) name:@"ChangePrice" object:nil];

}

// 这个函数是系统自动来调用
// ios系统接收到ChangeTheme广播就会来自动调用
// notify就是广播的所有内容
- (void) changePrice:(NSNotification *)notify{
    static int index;
    NSLog(@"recv bcast %d", index++);
    _Price.text = _changTextField.text;
}

- (void)assginOrderWithModel:(GoodModel *)cellModel{
    [_Url sd_setImageWithURL:[NSURL URLWithString:cellModel.Url]];
    [_Name setText:cellModel.Name];
    [_Price setText:[NSString stringWithFormat:@"%@",cellModel.Price]];
    [_Cnt setText:[NSString stringWithFormat:@"X%@",cellModel.Cnt]];
    [_changeBtn setHidden:YES];
}
//改价按钮
- (IBAction)changPriceBtn:(UIButton *)sender {
    [_changeBtn setHidden:YES];
    [_sureBtn setHidden:NO];
    [_changTextField setHidden:NO];
}
//确认按钮
- (IBAction)sureBtn:(UIButton *)sender
{
//    TheOrderViewController  *theOrder = [[TheOrderViewController alloc] init];
    [self.controller changGoodPrice:_GM andWithModel:_OM andWithChangePrice:_changTextField.text];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
