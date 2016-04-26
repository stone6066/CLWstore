//
//  ChooseMyGoodsListViewController.m
//  CLWsdht
//
//  Created by mfwl on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ChooseMyGoodsListViewController.h"
#import "SupplierStoreListModel.h"
#import "StoreGoodsListTableViewCell.h"
#import "BaseHeader.h"
#import "UserInfo.h"

#define rowNum (NSInteger)(kScreen_Height / 96 + 1)

@interface ChooseMyGoodsListViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger totalNum;
}
@property (strong, nonatomic) IBOutlet UITableView *goodsListTableView;

#pragma mark data
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *showArr;
@property (nonatomic, assign) NSInteger times;

@end

@implementation ChooseMyGoodsListViewController


- (void)dealloc {
    _goodsListTableView.delegate = nil;
    _goodsListTableView.dataSource = nil;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"选择我的商品";
        _times  = 0;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _showArr = [NSMutableArray arrayWithCapacity:0];
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

#pragma mark - 上拉刷新
- (void)setHeaderRefresh {
    
    _goodsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _modelArr = [NSMutableArray arrayWithCapacity:0];
        _showArr = [NSMutableArray arrayWithCapacity:0];
        totalNum = 0;
        _times = 0;
        [self dataHandle];
        
        [_goodsListTableView.mj_header beginRefreshing];
        [_goodsListTableView reloadData];
    }];
}


#pragma mark - 下拉加载
- (void)setFooterRefresh {
    _goodsListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (totalNum >= 10&&_times == 1) {
            [self dataHandle];
        } else {
            for (NSInteger i = _times * rowNum; i < _modelArr.count; i++) {
                SupplierStoreListModel *model = _modelArr[i];
                
                [_showArr addObject:model];
                if (i ==( (1 + _times) * rowNum) - 1) {
                    break;
                }
            }
            _times++;
        }
        
        if (_showArr.count == _modelArr.count) {
            [SVProgressHUD showInfoWithStatus:@"没有更多可以加载了"];
        }
        [_goodsListTableView.mj_footer endRefreshing];
        [_goodsListTableView reloadData];
    }];
}




- (void)dataHandle {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"UsrStore.asmx/GetPartsList"];
    NSDictionary *param = @{@"State":@"1", @"UsrStoreId":ApplicationDelegate.userInfo.user_Id};
    
    if (totalNum == 0) {
        totalNum = 10;
    }
        
    
    NSDictionary *paramDict = @{
                                @"limit":[NSString stringWithFormat:@"%ld", totalNum],
                                @"partsJson":[JYJSON JSONStringWithDictionaryOrArray:param],
                                @"sortJson":@"",
                                @"start":@"0"
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
         
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [self datprocessingWith:jsonDic];
                [self.goodsListTableView.mj_header endRefreshing];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
                [self.goodsListTableView.mj_header endRefreshing];
            }
         
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
        [self.goodsListTableView.mj_header endRefreshing];

    }];
}

- (void)datprocessingWith:(NSDictionary *)jsonDic {
    NSDictionary *dicFirst = jsonDic[@"Data"];
    NSArray *dataArr = dicFirst[@"Data"];
    NSLog(@"%@", jsonDic);
    totalNum = [[dicFirst objectForKey:@"Total"] integerValue];
    _modelArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in dataArr) {
        SupplierStoreListModel *model = [SupplierStoreListModel modelWithDictionary:dic];
//        NSLog(@"%@ %@",model.UseForName, model.TypeName);
        [_modelArr addObject:model];
    }
    for (NSInteger i = _times*rowNum; i < _modelArr.count; i ++) {
        SupplierStoreListModel *model = _modelArr[i];
   
        [_showArr addObject:model];
        if (i == ((1 + _times) * rowNum)-1) {
            break;
        }
    }
    _times ++;
    [_goodsListTableView reloadData];
}

- (void) setTableView {
    _goodsListTableView.delegate = self;
    _goodsListTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_showArr.count) {
        case 0:
            return 1;
            break;
            
        default:
            return _showArr.count;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    BaseModel *model = nil;
    switch (_showArr.count) {
        case 0: {
            static NSString *cellName = @"SoyTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            }
        }
            break;
        default: {
            model = _showArr[indexPath.row];
            static NSString *cellName = @"StoreGoodsListTableViewCell";
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
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (_showArr.count) {
        case 0:
            [SVProgressHUD showInfoWithStatus:@"暂无商品"];
            break;
            
        default:
            [self backAction];
            [kNotiCenter postNotificationName:@"chooseStoreGoodsBack" object:nil userInfo:@{@"storeModel":_showArr[indexPath.row]}];
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self dataHandle];
    [self setTableView];
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
