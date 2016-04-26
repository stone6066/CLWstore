//
//  TableViewSectionIndexTitlesView.m
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "TableViewSectionIndexTitlesView.h"
#import "TableViewSectionIndexCell.h"
#import <Masonry.h>
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define WIDTH [[UIScreen mainScreen] bounds].size.width

@interface TableViewSectionIndexTitlesView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *sectionIndexTableView;

@end


@implementation TableViewSectionIndexTitlesView

- (void)dealloc {
    _sectionIndexTableView.dataSource = nil;
    _sectionIndexTableView.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createTableView];
    }
    return self;
}

- (void)createTableView {
    self.sectionIndexTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    [self addSubview:_sectionIndexTableView];
    _sectionIndexTableView.backgroundColor = [UIColor clearColor];
    [_sectionIndexTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
    _sectionIndexTableView.scrollEnabled = NO;
    _sectionIndexTableView.delegate = self;
    _sectionIndexTableView.dataSource = self;
    _sectionIndexTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _sectionIndexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewSectionIndexCell";
    TableViewSectionIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil] firstObject];
    }
    cell.sectionIndex.text = _titles[indexPath.row];
    cell.sectionIndex.font = [UIFont systemFontOfSize:0.6 / _titles.count-1];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT * 0.6 / _titles.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate scrollerToSection:indexPath.row withIndex:_titles[indexPath.row]];
}



- (void)setTitles:(NSArray *)titles {
    if (_titles != titles) {
        _titles = titles;
    }
    [_sectionIndexTableView reloadData];
}


@end
