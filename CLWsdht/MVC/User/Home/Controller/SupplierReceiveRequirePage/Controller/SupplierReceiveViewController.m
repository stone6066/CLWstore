//
//  SupplierReceiveViewController.m
//  CLWsdht
//
//  Created by mfwl on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "SupplierReceiveViewController.h"

#import "ChooseCarTypeViewController.h"
#import "ChoosePartsViewController.h"
#import "BackBtView.h"
#import "RequireListModel.h"
#import "SupplierDetailsViewController.h"

#define rowNum (NSInteger)((kScreen_Height - 100) / 96 + 1)

@interface SupplierReceiveViewController () <BackBtViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    id __block chooseModel;
    id __block chooseParts;
    id __block chooseAddress;
    id __block chooseSort;
    NSInteger totalNum;
}

#pragma  mark show info
@property (strong, nonatomic) IBOutlet UILabel *addressLb;
@property (strong, nonatomic) IBOutlet UILabel *sortingLb;
@property (strong, nonatomic) IBOutlet UILabel *carTypeLb;
@property (strong, nonatomic) IBOutlet UILabel *partsNameLb;

@property (nonatomic, strong) BackBtView *btView;


@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *showModel;
@property (nonatomic, assign) NSInteger times;

@end

@implementation SupplierReceiveViewController

- (void)dealloc {
    _listTableView.delegate = nil;
    _listTableView.dataSource = nil;
    [kNotiCenter removeObserver:chooseModel];
    [kNotiCenter removeObserver:chooseParts];
    [kNotiCenter removeObserver:chooseAddress];
    [kNotiCenter removeObserver:chooseSort];
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = @"需求筛选";
        

        _times  = 0;
        self.showModel = [NSMutableArray arrayWithCapacity:0];
        [self addNoti];
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
- (void)viewWillAppear:(BOOL)animated {
    if (!self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = YES;
    }
}


- (void)dataHandle {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/GetDemandList"];
    
    NSDictionary *param = [NSDictionary dictionary];
    if (totalNum == 0) {
        totalNum = 10;
    }
    
    NSDictionary *paramDic = @{
                               @"demandJson":[JYJSON JSONStringWithDictionaryOrArray:param],
                               @"sortJson":@"",
                               
                               @"start":@"0",
                               
                               @"limit":[NSString stringWithFormat:@"%ld", totalNum]
                               };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];

           
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                [self datprocessingWith:jsonDic];
                //成功返回
             
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            [_listTableView.mj_header endRefreshing];
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
            [_listTableView.mj_header endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //请求异常
        [_listTableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
}

#pragma mark - 上拉刷新
- (void)setHeaderRefresh {
    
    _listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _modelArr = [NSMutableArray arrayWithCapacity:0];
        _showModel = [NSMutableArray arrayWithCapacity:0];
        totalNum = 0;
        _times = 0;
        [self dataHandle];
        
        [_listTableView.mj_header beginRefreshing];
        [_listTableView reloadData];
    }];
}



#pragma mark - 下拉加载
- (void)setFooterRefresh {
    _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (totalNum >= 10&&_times == 1) {
            [self dataHandle];
        } else {
            for (NSInteger i = _times * rowNum; i < _modelArr.count; i++) {
                [_showModel addObject:_modelArr[i]];
                if (i ==( (1 + _times) * rowNum) - 1) {
                    break;
                }
            }
            _times++;
        }
        if (_showModel.count == _modelArr.count) {
            [SVProgressHUD showInfoWithStatus:@"没有更多可以加载了"];
        }
        [_listTableView.mj_footer endRefreshing];
        [_listTableView reloadData];
    }];
}


- (void)datprocessingWith:(NSDictionary *)jsonDic {
    NSDictionary *dicFirst = jsonDic[@"Data"];
    NSArray *dataArr = dicFirst[@"Data"];
    totalNum = [[dicFirst objectForKey:@"Total"] integerValue];
    _modelArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in dataArr) {
        RequireListModel *model = [RequireListModel modelWithDictionary:dic];
        [_modelArr addObject:model];
    }
    for (NSInteger i = _times*rowNum; i < _modelArr.count; i ++) {
        [_showModel addObject:_modelArr[i]];
        if (i == ((1 + _times) * rowNum)-1) {
            break;
        }
    }
    _times ++;
    
    [_listTableView reloadData];
}




- (void)setListTableView {
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (_showModel.count) {
        case 0:
            return 1;
            break;
            
        default:
            return _showModel.count;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    BaseModel *model = nil;
    switch (_showModel.count) {
        case 0: {
            static NSString *cellName = @"SoyTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            }
        }
            break;
            
        default: {
            model = _showModel[indexPath.row];
           
            static NSString *cellName = @"SupplierTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            } else  /* 当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免 */
            {
                while ([cell.contentView.subviews lastObject] != nil) {
                    [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
            }
        }
            break;
    }
    
    return cell;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (_showModel.count) {
        case 0:
            [SVProgressHUD showErrorWithStatus:@"暂无需求"];
            break;
        default: {
            SupplierDetailsViewController *detailsVC = [[SupplierDetailsViewController alloc] init];
            detailsVC.baseModel = _modelArr[indexPath.row];
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
            break;
    }

}




- (void)addNoti {
    chooseModel = [kNotiCenter addObserverForName:@"chooseModel" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        BaseModel *model = note.userInfo[@"detailstype"];
        if (model.Name.length == 0) {
            _carTypeLb.text = @"品牌车型";
        } else {
              _carTypeLb.text = model.Name;
        }
    }];
    chooseParts  = [kNotiCenter addObserverForName:@"chooseParts" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        BaseModel *model = note.userInfo[@"detailspart"];
        if (model.Name.length == 0) {
            _partsNameLb.text = @"配件类型";
        } else {
            _partsNameLb.text = model.Name;
        }
    }];
    chooseAddress = [kNotiCenter addObserverForName:@"chooseAddress" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        BaseModel *proModel = note.userInfo[@"proModel"];
        BaseModel *cityModel = note.userInfo[@"cityModel"];
        _addressLb.text = [NSString stringWithFormat:@"%@ %@",proModel.Name, cityModel.Name];
    }];
    chooseSort = [kNotiCenter addObserverForName:@"chooseSortStyle" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        _sortingLb.text = note.userInfo[@"style"];
    }];

}


- (BackBtView *)btViewWithBtViewStyle:(BtViewStyle)style {
    if (!_btView) {
        _btView = [[BackBtView alloc] initWithBtViewStyle:style];
        _btView.delegate = self;
        [ApplicationDelegate.window addSubview:_btView];
        [ApplicationDelegate.window bringSubviewToFront:_btView];
        [_btView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(ApplicationDelegate.window);
        }];
    }
    return _btView;
}

- (void)pass {
    _btView = nil;
}


#pragma mark buttonClick
- (IBAction)opreation:(UIButton *)sender {
    switch (sender.tag) {
        case 111:
            [self btViewWithBtViewStyle:Double];
            break;
        case 112:
            [self btViewWithBtViewStyle:Single];
            break;
        case 113: {
            ChooseCarTypeViewController *carTypeVC = [[ChooseCarTypeViewController alloc] init];
            [self.navigationController pushViewController:carTypeVC animated:YES];
        }
            break;
        case 114: {
            ChoosePartsViewController *carTypeVC = [[ChoosePartsViewController alloc] init];
            [self.navigationController pushViewController:carTypeVC animated:YES];
        }
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self dataHandle];
    [self setListTableView];
    [self setFooterRefresh];
    [self setHeaderRefresh];
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
