//
//  MyShopViewController.m
//  CLWsdht
//
//  Created by yang on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "MyShopViewController.h"
#import "CustomSegment.h"//自定义分段选择器
#import "BaseHeader.h"
#import "MyShopTableViewCell.h"//cell
#import "MyShopModel.h"//模型
#import "UserInfo.h"

@interface MyShopViewController ()<CustomSegmentDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CustomSegment *segment;//自定义分段选择器
    NSInteger pageNumber;//当前页数
    NSInteger totalNumber;//总个数
    NSInteger pageSize;//每个分页个数(可以修改成宏, 入参需要修改)
    BOOL isSelect;//选择哪个分段
    UserInfo *info;//登录信息
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;//装数据的数组

@property (nonatomic, strong) NSMutableArray *showArray;

@end

@implementation MyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}

//CustomSegmentDelegate
- (void)segmentSelectWith:(NSInteger)index
{
    if (isSelect) {
        isSelect = NO;
        [self getPartsListDataRequestUp];
    }else{
        isSelect = YES;
        [self getPatsListDataRequestDown];
    }
    [self.tableView.mj_header beginRefreshing];
}

//设置下拉刷新  上拉加载
- (void)setRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNumber = 0;
        pageSize = 10;
        [self.dataArray removeAllObjects];
        if (isSelect) {
            [self getPatsListDataRequestDown];
        }else{
            [self getPartsListDataRequestUp];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
}
//上拉加载方法
- (void)footRefresh
{
    pageNumber++;
    if (isSelect) {
        [self getPatsListDataRequestDown];
    }else{
        [self getPartsListDataRequestUp];
    }
}
//停止刷新
- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
//上下架按钮方法
- (void)upAndDownWith:(NSNotification *)noti
{
    [self.tableView.mj_header beginRefreshing];
    [SVProgressHUD showWithStatus:k_Status_Load];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"UsrStore.asmx/ChangePartsState"];
    [ApplicationDelegate.httpManager POST:urlStr parameters:noti.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
                [self endRefresh];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        [self endRefresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
}
//上架列表数据请求
- (void)getPartsListDataRequestUp
{
    if (pageNumber * pageSize > totalNumber) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"UsrStore.asmx/GetPartsList"];
    NSDictionary *param = @{@"State":@"1",@"UsrStoreId":info.user_Id};
    NSLog(@"%@", urlStr);
    NSDictionary *paramDict = @{
                                @"limit":[NSString stringWithFormat:@"%ld", (long)pageSize],
                                @"partsJson":[JYJSON JSONStringWithDictionaryOrArray:param],
                                @"sortJson":@"",
                                @"start":@"0"
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@", jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                NSDictionary *dic = [jsonDic objectForKey:@"Data"];
                totalNumber = [[dic objectForKey:@"Total"] integerValue];
                NSArray *array = [dic objectForKey:@"Data"];
                self.dataArray = [NSMutableArray arrayWithArray:array];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        [self endRefresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
        [self endRefresh];
    }];
}
//下架列表数据请求
- (void)getPatsListDataRequestDown
{
    if (pageNumber * pageSize > totalNumber) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"UsrStore.asmx/GetPartsList"];
    NSDictionary *param = @{@"State":@"0",@"UsrStoreId":info.user_Id};
    NSDictionary *paramDict = @{
                                @"limit":[NSString stringWithFormat:@"%ld", pageSize],
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
                NSDictionary *dic = [jsonDic objectForKey:@"Data"];
                totalNumber = [[dic objectForKey:@"Total"] integerValue];
                NSArray *array = [dic objectForKey:@"Data"];
                self.dataArray = [NSMutableArray arrayWithArray:array];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        [self endRefresh];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
        [self endRefresh];
    }];
}
//UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MyShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyShopModel *model = [[MyShopModel alloc] initWithDictionary:self.dataArray[indexPath.row]];
    cell.model = model;
    return cell;
}
//UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
//UI
- (void)setSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的商店";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    info = ApplicationDelegate.userInfo;
    segment = [[CustomSegment alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 42) andItems:@[@"出售中",@"已下架"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upAndDownWith:) name:@"getPatsList" object:nil];
    [SVProgressHUD showWithStatus:k_Status_Load];
    [self setRefresh];
}
//懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, self.view.bounds.size.width, self.view.bounds.size.height - 42 - 64 - 39) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)showArray
{
    if (!_showArray) {
        _showArray = [NSMutableArray array];
    }
    return _showArray;
}


//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getPatsList" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
