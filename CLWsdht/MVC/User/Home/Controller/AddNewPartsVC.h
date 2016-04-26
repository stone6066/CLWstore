//
//  AddNewPartsVC.h
//  CLWsdht
//
//  Created by tom on 16/4/11.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewPartsVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTable;

@end
