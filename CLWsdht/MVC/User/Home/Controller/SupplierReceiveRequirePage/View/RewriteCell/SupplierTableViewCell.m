//
//  SupplierTableViewCell.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "SupplierTableViewCell.h"
#import "BaseHeader.h"

@interface SupplierTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *wait;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *descrip;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UILabel *views;
@property (strong, nonatomic) IBOutlet UILabel *endDate;


@end

@implementation SupplierTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.height.equalTo(@20);
        make.right.equalTo(_wait.mas_left).offset(-10);
    }];
    
    [_wait mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(_wait.text.length * 13 + 5, 20));
    }];
    [_address mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_address.text.length * 13 + 5, 20));
        make.top.equalTo(self.title.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(10);
    }];
    [_type mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(8);
        make.left.equalTo(_address.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(_type.text.length * 13 + 5, 20));
    }];
    [_descrip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(_type.mas_bottom).offset(8);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    [_count mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descrip.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(_count.text.length * 13, 20));
        make.left.equalTo(self.contentView).offset(10);
    }];
    [_views mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_views.text.length * 13, 20));
        make.top.equalTo(self.descrip.mas_bottom).offset(8);
        make.left.equalTo(self.count.mas_right).offset(10);
    }];
    [_endDate mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11*13, 20));
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.descrip.mas_bottom).offset(8);
    }];
}

- (void)setModel:(BaseModel *)model {
    [super model];
    _count.text = [NSString stringWithFormat:@"数量 %ld", model.Cnt];
    _title.text = model.Title;
    _type.text = model.CarBrandName;
    _wait.text = @"待选标";
    _descrip.text = [NSString stringWithFormat:@"%@ > %@ > %ld", model.CarBrandName, model.CarModelName, model.Year];
    _address.text = model.ProvincialName;
    _views.text = [NSString stringWithFormat:@"浏览量 %ld", model.Views];
    _endDate.text = [NSString stringWithFormat:@"截止日期: %@", [model.EndDate substringToIndex:10]];
    
    //    NSLog(@"%@",model.Mobile);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
