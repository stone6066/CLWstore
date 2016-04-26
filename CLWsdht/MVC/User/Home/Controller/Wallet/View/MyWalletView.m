//
//  MyWalletView.m
//  CLWsdht
//
//  Created by yang on 16/4/16.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "MyWalletView.h"
#import "BaseHeader.h"

@implementation MyWalletView
{
    UIImageView *backImageView;//上面的图
    UILabel *totalMoneyLabel;//可提现金额
    UIButton *settlementButton;//立即结算按钮
    UIImageView *CompletedImageView;//已结算
    UILabel *Completed;
    UILabel *CompletedPrice;
    UIImageView *waitingImageView;//待结算
    UILabel *waitingLabel;
    UILabel *waitingPrice;
}
//初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}
//模型赋值
- (void)setModel:(MyWalletModel *)model
{
    totalMoneyLabel.text = [NSString stringWithFormat:@"¥%ld", model.Balance];
    Completed.text = [NSString stringWithFormat:@"已结算%@笔", [model.Count objectForKey:@"Completed"]];
    CompletedPrice.text = [NSString stringWithFormat:@"共¥%@", [model.Count objectForKey:@"CompletedPrice"]];
    waitingLabel.text = [NSString stringWithFormat:@"待结算%@笔", [model.Count objectForKey:@"Waiting"]];
    waitingPrice.text = [NSString stringWithFormat:@"共¥%@", [model.Count objectForKey:@"WaitingPrice"]];
}
//立即结算点击事件
- (void)settlementButtonClick:(UIButton *)sender
{
    NSDictionary *dic = @{@"money": [totalMoneyLabel.text substringFromIndex:1]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyWallet" object:nil userInfo:dic];
}
//UI
- (void)setSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    backImageView = [UIImageView new];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"per_buyers"] ;
    [self addSubview:backImageView];
    totalMoneyLabel = [UILabel new];
    totalMoneyLabel.textColor = [UIColor whiteColor];
    totalMoneyLabel.font = [UIFont systemFontOfSize:25];
    totalMoneyLabel.text = @"¥0";
    totalMoneyLabel.textAlignment = 1;
    [backImageView addSubview:totalMoneyLabel];
    settlementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settlementButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [settlementButton setTitle:@"立即结算" forState:UIControlStateNormal];
    settlementButton.layer.borderWidth = 1;
    settlementButton.layer.borderColor = [UIColor orangeColor].CGColor;
    settlementButton.layer.cornerRadius = 5;
    [settlementButton addTarget:self action:@selector(settlementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:settlementButton];
    CompletedImageView  = [UIImageView new];
    CompletedImageView.image = [UIImage imageNamed:@"yijiesuan"];
    [self addSubview:CompletedImageView];
    Completed = [UILabel new];
    Completed.textColor = [UIColor lightGrayColor];
    Completed.font = [UIFont systemFontOfSize:12];
    [self addSubview:Completed];
    CompletedPrice = [UILabel new];
    CompletedPrice.textColor = [UIColor lightGrayColor];
    CompletedPrice.font = [UIFont systemFontOfSize:12];
    [self addSubview:CompletedPrice];
    waitingImageView  = [UIImageView new];
    waitingImageView.image = [UIImage imageNamed:@"daijiesuan"];
    [self addSubview:waitingImageView];
    waitingLabel = [UILabel new];
    waitingLabel.textColor = [UIColor lightGrayColor];
    waitingLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:waitingLabel];
    waitingPrice = [UILabel new];
    waitingPrice.textColor = [UIColor lightGrayColor];
    waitingPrice.font = [UIFont systemFontOfSize:12];
    [self addSubview:waitingPrice];
}
//frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf).offset(0);
        make.height.mas_equalTo(@150);
    }];
    [totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImageView.mas_centerY);
        make.left.right.equalTo(backImageView).offset(0);
        make.height.mas_equalTo(@25);
    }];
    [settlementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.top.equalTo(totalMoneyLabel.mas_bottom).offset(20);
        make.centerX.equalTo(backImageView.mas_centerX);
    }];
    [CompletedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_bottom).offset(20);
        make.left.equalTo(weakSelf).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 70));
    }];
    [Completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CompletedImageView).offset(15);
        make.left.equalTo(CompletedImageView.mas_right).offset(5);
        make.right.equalTo(weakSelf.mas_centerX).offset(0);
        make.height.mas_equalTo(@20);
    }];
    [CompletedPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Completed.mas_bottom).offset(0);
        make.left.equalTo(Completed);
        make.size.equalTo(Completed);
    }];
    [waitingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_centerX).offset(0);
        make.size.top.equalTo(CompletedImageView);
    }];
    [waitingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(Completed);
        make.left.equalTo(waitingImageView.mas_right).offset(5);
        make.right.equalTo(weakSelf).offset(-20);
    }];
    [waitingPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(CompletedPrice);
        make.right.equalTo(waitingLabel);
        make.left.equalTo(waitingLabel);
    }];
}

@end
