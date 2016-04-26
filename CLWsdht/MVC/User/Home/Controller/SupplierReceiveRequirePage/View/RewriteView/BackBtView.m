//
//  BackBtView.m
//  CLWsdht
//
//  Created by mfwl on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BackBtView.h"
#import "BaseHeader.h"
#import "ReleaseRequireModel.h"

@interface BackBtView () <UITableViewDataSource , UITableViewDelegate>
@property (nonatomic, strong) UITableView *showListTableView;
@property (nonatomic, strong) UITableView *cityListTableView;
#pragma  mark  data
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *proModelArr;
@property (nonatomic, strong) NSMutableArray *cityModelArr;

@property (nonatomic, strong) ReleaseRequireModel *tempModel;
@property (nonatomic, assign) BtViewStyle tempStyle;


@end

@implementation BackBtView
- (void)dealloc {
    _showListTableView.delegate = nil;
    _showListTableView.dataSource = nil;
    _cityListTableView.delegate = nil;
    _cityListTableView.dataSource = nil;
    [self removeTarget:self action:@selector(remove) forControlEvents:(UIControlEventTouchUpInside)];
}

- (instancetype)initWithBtViewStyle:(BtViewStyle)style
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
        [self addTarget:self action:@selector(remove) forControlEvents:(UIControlEventTouchUpInside)];
        [self showListTableViewWith:style];
        _tempStyle = style;
        [self dataArrWith:style];
        [self cityListTableView];

    }
    return self;
}

- (NSArray *)dataArrWith:(BtViewStyle)style {
    if (!_dataArr) {
        switch (style) {
            case 0: {
                _proModelArr = @[@"默认排序",@"日期升序",@"日期降序",@"浏览量升序",@"浏览量降序"].mutableCopy;
            }
                break;
                
            default: {
                NSString *path = [[NSBundle mainBundle]pathForResource:@"Provincial" ofType:@"plist"];
                _dataArr = [[NSArray alloc]initWithContentsOfFile:path];
                _proModelArr = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in _dataArr) {
                    ReleaseRequireModel *model = [ReleaseRequireModel modelWithDictionary:dic];
                    [_proModelArr addObject:model];
                }
            }
                break;
        }
        
    }
    return _dataArr;
}

- (UITableView *)showListTableViewWith:(BtViewStyle)style {
    if(!_showListTableView) {
        self.showListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _showListTableView.delegate = self;
        _showListTableView.dataSource = self;
        [self addSubview:_showListTableView];
        [_showListTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            switch (style) {
                case 0:
                    make.height.equalTo(@(kScreen_Height  / 3));
                    _showListTableView.scrollEnabled = NO;
                    break;
                    
                default:
                    make.height.equalTo(@(kScreen_Height * 2 / 3));
                    _showListTableView.scrollEnabled = YES;
                    break;
            }
            make.top.equalTo(self).offset(113);
        }];
        
    }
    return _showListTableView;
}


- (UITableView *)cityListTableView {
    if (!_cityListTableView) {
        self.cityListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _cityListTableView.delegate = self;
        _cityListTableView.dataSource = self;
        _cityListTableView.hidden = YES;
        [self addSubview:_cityListTableView];
        [_cityListTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.height.equalTo(@(kScreen_Height * 2 / 3));
            make.width.equalTo(@(kScreen_Width / 2));
            make.top.equalTo(self).offset(113);
        }];
    }
    return _cityListTableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_cityListTableView]) {
        return _cityModelArr.count;
    } else return _proModelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_showListTableView]) {
        switch (_tempStyle) {
            case 0: {
                static NSString *cellName = @"sortcell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellName];
                }
                
                cell.textLabel.text = _proModelArr[indexPath.row];
                cell.textLabel.textAlignment = 1;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                return cell;
            }
                
                break;
                
            default: {
                static NSString *cellName = @"procell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellName];
                }
                ReleaseRequireModel *model = _proModelArr[indexPath.row];
                cell.textLabel.text = model.Name;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                return cell;
            }
                break;
        }
        
        

    } else {
        static NSString *cellName = @"citycell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellName];
        }
        ReleaseRequireModel *model = _cityModelArr[indexPath.row];
        cell.textLabel.text = model.Name;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_showListTableView]) {
        switch (_tempStyle) {
            case 0: {
                [kNotiCenter postNotificationName:@"chooseSortStyle" object:nil userInfo:@{@"style":_proModelArr[indexPath.row]}];
                [self remove];
            }
                
                break;
                
            default: {
                _tempModel = _proModelArr[indexPath.row];
                _cityModelArr = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in _tempModel.T_DicCity) {
                    ReleaseRequireModel *model = [ReleaseRequireModel modelWithDictionary:dic];
                    [_cityModelArr addObject:model];
                }
                if (_cityListTableView.hidden) {
                    _cityListTableView.hidden = NO;
                }
                [_cityListTableView reloadData];
            }
                
                break;
        }
        
    } else {
        [kNotiCenter postNotificationName:@"chooseAddress" object:nil userInfo:@{@"proModel":_tempModel, @"cityModel":_cityModelArr[indexPath.row]}];
        [self remove];
    }
}

- (void)remove {
    [self.delegate pass];
    [self removeFromSuperview];
    _showListTableView = nil;
    _cityListTableView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
