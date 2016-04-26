//
//  DetailsTableViewCell.m
//  CLWsdht
//
//  Created by mfwl on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import "BaseModel.h"
#import "BaseHeader.h"
@interface DetailsTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *proName;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *from;
@property (strong, nonatomic) IBOutlet UILabel *disp;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UILabel *endDate;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *phoneNum;
@property (strong, nonatomic) IBOutlet UILabel *descrip;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation DetailsTableViewCell





- (void)setModel:(BaseModel *)model {
 
    _title.text = model.Title;
    _proName.text = model.ProvincialName;
    _type.text = model.CarBrandName;
    _year.text = [NSString stringWithFormat:@"%ld", model.Year];
    _disp.text = [NSString stringWithFormat:@"%ld", model.Displacement];
    _name.text = model.PartsUseForName;
    _from.text = model.Reason;
    _count.text = [NSString stringWithFormat:@"%ld", model.Cnt];
    _endDate.text = [model.EndDate substringToIndex:10];
    _address.text = [NSString stringWithFormat:@"%@%@", model.ProvincialName, model.CityName];
    _phoneNum.text = [NSString stringWithFormat:@"%ld", model.Mobile];
    _descrip.text = model.Description;
}




- (void)awakeFromNib {
 
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
