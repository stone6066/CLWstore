//
//  MyShopTableViewCell.m
//  CLWsdht
//
//  Created by yang on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "MyShopTableViewCell.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>

#define kFont [UIFont systemFontOfSize:13]//默认字号

@implementation MyShopTableViewCell
{
    UIImageView *imageView;//图片
    UILabel *nameLabel;//商品名
    UILabel *StoreNameLabel;//商店名
    UILabel *shangLabel;//商
    UILabel *renzhengLabel;//已认证
    UILabel *priceLabel;//价钱
    UILabel *PurityNameLabel;//新旧程度
    UILabel *PartsSrcNameLabel;//部位
    UIButton *leftButton;//编辑
    UIButton *rightButton;//上下架
}

//初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubViews];
    }
    return self;
}

//模型赋值
- (void)setModel:(MyShopModel *)model
{
    _model = model;
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.Url] placeholderImage:[UIImage imageNamed:@"8821914_104949466000_2.jpg"]];
    StoreNameLabel.text = model.StoreName;
    PurityNameLabel.text = model.PurityName;
    priceLabel.text = [NSString stringWithFormat:@"¥%ld", model.Price];
    PartsSrcNameLabel.text = model.PartsSrcName;
    nameLabel.text = model.Name;
    [self setButtonTitleWithState:model.State];
}

//设置button的title
- (void)setButtonTitleWithState:(NSInteger)state
{
    switch (state) {
        case 0:
            [rightButton setTitle:@"商品上架" forState:UIControlStateNormal];
            break;
        case 1:
            [rightButton setTitle:@"商品下架" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

//编辑按钮点击事件
//- (void)leftClick:(UIButton *)sender
//{
//    NSLog(@"bianji");
//}

//上下架按钮点击事件
- (void)rightClick:(UIButton *)sender
{
    NSString *state;
    switch (_model.State) {
        case 0:
            state = @"1";
            break;
        case 1:
            state = @"0";
            break;
            
        default:
            break;
    }
    NSDictionary *dic = @{@"state":[NSString stringWithFormat:@"%@", state],@"id":_model.Id};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPatsList" object:nil userInfo:dic];
}

//搭建界面
- (void)setSubViews
{
    imageView = [UIImageView new];
    [self.contentView addSubview:imageView];
    nameLabel = [UILabel new];
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    StoreNameLabel = [UILabel new];
    StoreNameLabel.font = kFont;
    [self.contentView addSubview:StoreNameLabel];
    shangLabel = [UILabel new];
    shangLabel.backgroundColor = [UIColor redColor];
    shangLabel.text = @"商";
    shangLabel.font = kFont;
    shangLabel.textAlignment = 1;
    shangLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:shangLabel];
    renzhengLabel = [UILabel new];
    renzhengLabel.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:255/255.0 alpha:1.0];
    renzhengLabel.text = @"已认证";
    renzhengLabel.font = kFont;
    [self.contentView addSubview:renzhengLabel];
    priceLabel = [UILabel new];
    priceLabel.font = kFont;
    priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:priceLabel];
    PurityNameLabel = [UILabel new];
    PurityNameLabel.textAlignment = 1;
    PurityNameLabel.textColor = [UIColor lightGrayColor];
    PurityNameLabel.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:255/255.0 alpha:1.0];
    PurityNameLabel.font = kFont;
    [self.contentView addSubview:PurityNameLabel];
    PartsSrcNameLabel = [UILabel new];
    PartsSrcNameLabel.textAlignment = 2;
    PartsSrcNameLabel.textColor = [UIColor lightGrayColor];
    PartsSrcNameLabel.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:255/255.0 alpha:1.0];
    PartsSrcNameLabel.font = kFont;
    [self.contentView addSubview:PartsSrcNameLabel];
//    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.titleLabel.font = kFont;
//    leftButton.backgroundColor = [UIColor redColor];
//    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [leftButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:leftButton];
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = kFont;
    rightButton.backgroundColor = [UIColor redColor];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rightButton];
}

//设置frame(masonry)
- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 80));
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.height.mas_equalTo(@40);
    }];
    [StoreNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(0);
        make.left.equalTo(nameLabel);
        make.width.height.equalTo(nameLabel).multipliedBy(0.5);
    }];
    [shangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(StoreNameLabel);
        make.width.equalTo(StoreNameLabel.mas_height);
        make.right.equalTo(renzhengLabel.mas_left).offset(-5);
    }];
    [renzhengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(StoreNameLabel);
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.left.equalTo(shangLabel.mas_right).offset(5);
    }];
    [PartsSrcNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(PurityNameLabel);
        make.left.equalTo(PurityNameLabel.mas_right).offset(5);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    [PurityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(priceLabel);
        make.width.mas_equalTo(@40).priorityLow();
        make.right.equalTo(PartsSrcNameLabel.mas_left).offset(-5);
    }];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(StoreNameLabel.mas_bottom).offset(0);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.right.equalTo(PurityNameLabel.mas_left).offset(0);
        make.height.equalTo(StoreNameLabel);
    }];
//    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(rightButton.mas_left).offset(-5);
//        make.top.width.height.equalTo(rightButton);
//    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@30);
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
