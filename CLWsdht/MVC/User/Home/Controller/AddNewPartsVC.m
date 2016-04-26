//
//  AddNewPartsVC.m
//  CLWsdht
//
//  Created by tom on 16/4/11.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "AddNewPartsVC.h"
#import "CapturerCell.h"
#import "TextInputCell.h"
#import "NormalCell.h"
#import "MultilineTextInputCell.h"


@interface AddNewPartsVC ()

@end

@implementation AddNewPartsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_listTable registerNib:[UINib nibWithNibName:@"CapturerCell" bundle:nil] forCellReuseIdentifier:@"CapturerCell"];
    [_listTable registerNib:[UINib nibWithNibName:@"MultilineTextInputCell" bundle:nil] forCellReuseIdentifier:@"MultilineTextInputCell"];
    [_listTable registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:@"NormalCell"];
    [_listTable registerNib:[UINib nibWithNibName:@"TextInputCell" bundle:nil] forCellReuseIdentifier:@"TextInputCell"];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (NSString *)identifierByRow:(NSInteger)row {
    
    NSString *identifier = @"";
    
    switch (row) {
        case 0:{
            
            identifier = @"CapturerCell";
        }
            break;
        case 1:{
            
            identifier = @"TextInputCell";
            
        }
            break;
        case 2:{
            
            identifier = @"TextInputCell";
            
        }
            break;
        case 3:{
            
            identifier = @"NormalCell";
            
        }
            break;
        case 4:{
            
            identifier = @"TextInputCell";
            
        }
            break;
        case 5:{
            
            identifier = @"NormalCell";
            
        }
            break;
        case 6:{
            
            identifier = @"NormalCell";
            
        }
            break;
        case 7:{
            
            identifier = @"NormalCell";
            
        }
            break;
        case 8:{
            
            identifier = @"NormalCell";
            
        }
            break;
        case 9:{
            
            identifier = @"MultilineTextInputCell";
            
        }
            break;
            
        default:
            break;
    }
    
    return identifier;
}

- (void)setupCellTitle:(UITableViewCell *)cell row:(NSInteger)row {
    
    switch (row) {
        case 0:{
            
            
        }
            break;
        case 1:{
            
            TextInputCell *textInputCell = (TextInputCell *)cell;
            textInputCell.titleLabel.text = @"配件名称";
            textInputCell.contentTextField.text = @"请输入配件名称";
            
        }
            break;
        case 2:{
            
            TextInputCell *textInputCell = (TextInputCell *)cell;
            textInputCell.titleLabel.text = @"价格";
            textInputCell.contentTextField.text = @"请输入配件价格";
            
        }
            break;
        case 3:{
            
            NormalCell *normalCell = (NormalCell *)cell;
            normalCell.titleLabel.text = @"品牌车型";
            
        }
            break;
        case 4:{
            
            TextInputCell *textInputCell = (TextInputCell *)cell;
            textInputCell.titleLabel.text = @"排量";
            textInputCell.contentTextField.text = @"适配车辆排量";
            
        }
            break;
        case 5:{
            
            NormalCell *normalCell = (NormalCell *)cell;
            normalCell.titleLabel.text = @"配件分类";
            
        }
            break;
        case 6:{
            
            NormalCell *normalCell = (NormalCell *)cell;
            normalCell.titleLabel.text = @"配件颜色";
            
        }
            break;
        case 7:{
            
            NormalCell *normalCell = (NormalCell *)cell;
            normalCell.titleLabel.text = @"配件成色";
            
        }
            break;
        case 8:{
            
            NormalCell *normalCell = (NormalCell *)cell;
            normalCell.titleLabel.text = @"配件来源";
            
        }
            break;
        case 9:{
            
            MultilineTextInputCell *multilineCell = (MultilineTextInputCell *)cell;
            multilineCell.titleLabel.text = @"配件描述";
            
        }
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [self identifierByRow:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    return cell;
}

@end
