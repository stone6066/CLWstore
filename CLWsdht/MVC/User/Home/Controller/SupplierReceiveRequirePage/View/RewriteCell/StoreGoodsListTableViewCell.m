//
//  StoreGoodsListTableViewCell.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "StoreGoodsListTableViewCell.h"
#import "BaseHeader.h"

@interface StoreGoodsListTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imgv;
@property (strong, nonatomic) IBOutlet UILabel *partsName;
@property (strong, nonatomic) IBOutlet UILabel *storeName;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *allow;
@property (strong, nonatomic) IBOutlet UIImageView *smSign;
@property (strong, nonatomic) IBOutlet UILabel *from;
@property (strong, nonatomic) IBOutlet UILabel *purity;

@end

@implementation StoreGoodsListTableViewCell


- (void)layoutSubviews {
    [super layoutSubviews];
    [_imgv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.equalTo(@80);
    }];
    [_partsName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(_imgv.mas_right).offset(8);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    [_allow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-8);
        make.width.equalTo(@(_allow.text.length * 13 + 5));
        make.height.equalTo(@20);
    }];
    [_smSign mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.allow.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [_storeName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_imgv.mas_right).offset(8);
        make.height.equalTo(@20);
        make.width.equalTo(@(_storeName.text.length * 13 + 5));
    }];
    [_price mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgv.mas_right).offset(8);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.equalTo(@120);
    }];
    [_from mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-8);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.equalTo(@(_from.text.length * 13 + 5));
    }];
    [_purity mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.from.mas_left).offset(-8);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.equalTo(@(_from.text.length * 13 + 10));
    }];
}

- (void)setModel:(BaseModel *)model {
    [super model];

   [_imgv sd_setImageWithURL:[NSURL URLWithString:model.Url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
   }];
    _partsName.text = model.TypeName;
    _storeName.text = model.StoreName;
    _from.text = model.PartsSrcName;
    _purity.text = model.PurityName;
    _price.text = [NSString stringWithFormat:@"￥%.2f", (CGFloat)model.Price];

//   [_imgv setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.Url]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//       NSLog(@"123");
//   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//       NSLog(@"%@",error);
//   }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
