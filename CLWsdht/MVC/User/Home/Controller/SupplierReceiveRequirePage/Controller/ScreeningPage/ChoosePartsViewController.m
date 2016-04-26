//
//  ChoosePartsViewController.m
//  CLWsdht
//
//  Created by mfwl on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ChoosePartsViewController.h"
#import "ReleaseRequireModel.h"

@interface ChoosePartsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *carPartsTableView;
@property (strong, nonatomic) IBOutlet UITableView *detailsCarPartsTableView;


#pragma mark  data
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *partsModelArr;
@property (nonatomic, strong) NSMutableArray *detailsPartsModelArr;
#pragma mark tempModel
@property (nonatomic, strong) ReleaseRequireModel *partsModel;


@end

@implementation ChoosePartsViewController

- (void)dealloc {
    _carPartsTableView.delegate = nil;
    _carPartsTableView.dataSource =nil;
    _detailsCarPartsTableView.dataSource = nil;
    _detailsCarPartsTableView.delegate = nil;
}

- (IBAction)chooseAll:(UIButton *)sender {
    BaseModel *model = [[BaseModel alloc] init];
    [self post:model andDetailsModel:model];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = @"配件选择";
        [self setBack];
    }
    return self;
}
- (void)setBack  {
    UIButton *back = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [back setFrame:CGRectMake(0, 0, 20, 20)];
    [back setTintColor:[UIColor orangeColor]];
    [back setImage:[UIImage imageNamed:@"fanhuiy"] forState:(UIControlStateNormal)];
    [back addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item  = [[UIBarButtonItem  alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back:(UIButton *)back {
    [self backAction];
}


#pragma mark handleData
- (void)partsDataHandle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PartsUseFor" ofType:@"plist"];
    
    self.dataArr = [NSArray arrayWithContentsOfFile:path];
    self.partsModelArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in _dataArr) {
        ReleaseRequireModel *model = [ReleaseRequireModel modelWithDictionary:dic];
        [_partsModelArr addObject:model];
    }
    [self.carPartsTableView reloadData];
    
}


- (void)setTableView {
    _carPartsTableView.delegate = self;
    _carPartsTableView.dataSource = self;
    _detailsCarPartsTableView.delegate= self;
    _detailsCarPartsTableView.dataSource = self;
//    _detailsCarPartsTableView.tableFooterView = [[UIView alloc] init];
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    [_carPartsTableView addGestureRecognizer:swipeGR];
}
- (void)swipeAction:(UISwipeGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_detailsCarPartsTableView.hidden == NO) {
            _detailsCarPartsTableView.hidden = YES;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_carPartsTableView]) {
        return _partsModelArr.count;
    } else {
        return _detailsPartsModelArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_carPartsTableView]) {
        static NSString *cellIdentifier = @"partsTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellIdentifier];
        }
        ReleaseRequireModel *model = _partsModelArr[indexPath.row];
        cell.textLabel.text = model.Name;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        static NSString *cellIdentifier = @"detailsPartsTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellIdentifier];
        }
        ReleaseRequireModel *model =  _detailsPartsModelArr[indexPath.row];
        cell.textLabel.text = model.Name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
#pragma mark cell click
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_carPartsTableView]) {
        
        _detailsPartsModelArr = [NSMutableArray arrayWithCapacity:0];
        ReleaseRequireModel *model = _partsModelArr[indexPath.row];
        self.partsModel = model;
        for (NSDictionary *dic in model.T_DicPartsType) {
            ReleaseRequireModel *detailPartsModel = [ReleaseRequireModel modelWithDictionary:dic];
            [_detailsPartsModelArr addObject:detailPartsModel];
        }
        if (_detailsCarPartsTableView.hidden) {
            _detailsCarPartsTableView.hidden = NO;
        }
        [_detailsCarPartsTableView reloadData];
    } else {
        ReleaseRequireModel *model = _detailsPartsModelArr[indexPath.row];
        [self post:model andDetailsModel:self.partsModel];
    }
}
- (void) post:(id)choosepartModel andDetailsModel:(id)detailsPartModel {
    [self.navigationController popViewControllerAnimated:YES];
    [kNotiCenter postNotificationName:@"chooseParts" object:nil userInfo:@{@"detailspart":choosepartModel, @"carpart":detailsPartModel}];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self partsDataHandle];
    [self setTableView];
    // Do any additional setup after loading the view from its nib.
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

@end
