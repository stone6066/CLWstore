//
//  TheOrderViewController.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/8.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "TheOrderViewController.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法
#import "MJExtension.h"
#import "OrderTableViewCell.h"
#import "BaseHeader.h"
#import "OrderModel.h"
#import "UserInfo.h"
#import "MyOrderViewController.h"
#import "SingleCase.h"


@interface TheOrderViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) NSMutableArray *partlistArr;


@end

@implementation TheOrderViewController
- (void)viewWillAppear:(BOOL)animated{
    [self GetOrderListByNetwork];
    [self setUpView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的配件订单"];
    _partlistArr = [[NSMutableArray alloc] initWithCapacity:0];
    SingleCase *singleCase = [SingleCase sharedSingleCase];
    _storeId = singleCase.str;
    
//    [self addObserver:self forKeyPath:@"orderTableView" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"orderTableView"])
//    {
//        NSLog(@"1111");
//    }
//}

//UI界面
-(void)setUpView{
    _orderTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStyleGrouped];
    _orderTableView.delegate=self;
    _orderTableView.dataSource=self;
    [_orderTableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderCellIdentifer"];
    [self.view addSubview:_orderTableView];
}

//待确认
- (IBAction)confirmBtn:(UIButton *)sender {
    _orderState = @"0";
    [self GetOrderListByNetwork];
}
//待付款
- (IBAction)payBtn:(UIButton *)sender {
    _orderState = @"1";
    [self GetOrderListByNetwork];
}
//待发货
- (IBAction)dispatchBtn:(UIButton *)sender {
    _orderState = @"2";
    [self GetOrderListByNetwork];
}
//待收货
- (IBAction)receiveBtn:(UIButton *)sender {
    _orderState = @"3";
    [self GetOrderListByNetwork];
}
//待评价
- (IBAction)judgeBtn:(UIButton *)sender {
    _orderState = @"4";
    [self GetOrderListByNetwork];
}

//获取我的订单
- (void)GetOrderListByNetwork{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/GetOrdersList"];
    NSDictionary *paramDict = @{
                                @"state":_orderState,
                                @"usrId":@"",
                                @"garageId":@"",
                                @"storeId":_storeId,
                                @"start":[NSString stringWithFormat:@"%d",0],
                                @"limit":[NSString stringWithFormat:@"%d",10]
                                };
    
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          //            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          if (jsonDic[@"Success"]) {
                                              //成功
                                              NSLog(@"------------------%@", jsonDic);

                                              NSLog(@"%@ %@", [NSThread currentThread].name, self);
                                              
                                              OrderModel *orderModel = [[OrderModel alloc] init];
                                              _partlistArr = [orderModel assignModelWithDict:jsonDic];
                                              [_orderTableView reloadData];
                                              [SVProgressHUD showSuccessWithStatus:  k_Success_Load];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
    
}


#pragma mark -- UITableViewDataSource

/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //根据当前页面的state设置按钮的显示和隐藏
    int i = 0;
    if ([_orderState isEqualToString:@"0"]) {
        i = 128;
    }
    else if ([_orderState isEqualToString:@"1"]){
        i = 85;
    }
    else if ([_orderState isEqualToString:@"2"]){
        i = 128;
    }
    else if ([_orderState isEqualToString:@"3"]){
        i = 85;
    }
    else if ([_orderState isEqualToString:@"4"]){
        i = 128;
    }
    return i;
}
//设置cell头的UI
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    //店铺图标
    UIImageView *storeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [storeImg setImage:[UIImage imageNamed:@"NotificationBackgroundError.png"]];
    [headerView addSubview:storeImg];
    //店铺名字
    UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(storeImg.frame.origin.x+storeImg.frame.size.width+5, storeImg.frame.origin.y, 100, 20)];
    [storeName setBackgroundColor:[UIColor clearColor]];
    [storeName setText:OM.StoreName];
    [storeName setTextColor:[UIColor blackColor]];
    [storeName setFont:[UIFont systemFontOfSize:14]];
    [headerView addSubview:storeName];
    //图标
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, storeImg.frame.origin.y, 20, 20)];
    [img setImage:[UIImage imageNamed:@"等级砖石"]];
    [headerView addSubview:img];
    return headerView;
    
}
//设置cell尾的UI
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[section];
    
    //价格Label
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65,10, 50, 15)];
    [price setBackgroundColor:[UIColor clearColor]];
    [price setText:[NSString stringWithFormat:@"￥%@",OM.Price]];
    [price setTextAlignment:NSTextAlignmentCenter];
    [price setTextColor:[UIColor redColor]];
    [price setFont:[UIFont systemFontOfSize:13]];
    [footerView addSubview:price];
    //合计
    UILabel *add = [[UILabel alloc] initWithFrame:CGRectMake(price.frame.origin.x-40, price.frame.origin.y, 35, 15)];
    [add setBackgroundColor:[UIColor clearColor]];
    [add setText:@"合计"];
    [add setTextAlignment:NSTextAlignmentRight];
    [add setTextColor:[UIColor lightGrayColor]];
    [add setFont:[UIFont systemFontOfSize:13]];
    [footerView addSubview:add];
    //共计几件商品
    UILabel *manyGood = [[UILabel alloc] initWithFrame:CGRectMake(add.frame.origin.x-95, add.frame.origin.y, 90, 15)];
    [manyGood setBackgroundColor:[UIColor clearColor]];
    NSArray *many = OM.PartsList;
    [manyGood setText:[NSString stringWithFormat:@"共计%lu件商品",(unsigned long)many.count]];
    [manyGood setTextAlignment:NSTextAlignmentCenter];
    [manyGood setTextColor:[UIColor lightGrayColor]];
    [manyGood setFont:[UIFont systemFontOfSize:13]];
    [footerView addSubview:manyGood];
    //分割线
    UILabel *carveF = [[UILabel alloc] initWithFrame:CGRectMake(0, manyGood.frame.origin.y+manyGood.frame.size.height+8, SCREEN_WIDTH, 0.5)];
    [carveF setBackgroundColor:[UIColor lightGrayColor]];
    [footerView addSubview:carveF];

    //收货地址、
    UILabel *storeOK = [[UILabel alloc] initWithFrame:CGRectMake(10, carveF.frame.origin.y+5, 90, 15)];
    [storeOK setBackgroundColor:[UIColor clearColor]];
    [storeOK setText:@"收货地址"];
    [storeOK setTextColor:[UIColor lightGrayColor]];
    [storeOK setFont:[UIFont systemFontOfSize:12]];
    [footerView addSubview:storeOK];
    //收货地址信息
    UILabel *garageOK = [[UILabel alloc] initWithFrame:CGRectMake(10, storeOK.frame.origin.y+storeOK.frame.size.height+3, SCREEN_WIDTH-20, 15)];
    [garageOK setBackgroundColor:[UIColor clearColor]];
    [garageOK setText:OM.Addr];
    [garageOK setTextColor:[UIColor lightGrayColor]];
    [garageOK setFont:[UIFont systemFontOfSize:12]];
    [footerView addSubview:garageOK];
    //分割线
    UILabel *carveS = [[UILabel alloc] initWithFrame:CGRectMake(0, garageOK.frame.origin.y+manyGood.frame.size.height+13, SCREEN_WIDTH, 0.5)];
    [carveS setBackgroundColor:[UIColor lightGrayColor]];
    [footerView addSubview:carveS];
    
    //确认订单按钮
    UIButton *okOederBtn = [[UIButton alloc] initWithFrame:CGRectMake(footerView.frame.size.width-80, footerView.frame.size.height-35, 65, 30)];
    [okOederBtn setBackgroundColor:[UIColor redColor]];
    [okOederBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [okOederBtn setTitle:@"确认订单" forState:UIControlStateNormal];
    [okOederBtn setTag:section];
    [okOederBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okOederBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [okOederBtn addTarget:self action:@selector(okOederBtn:) forControlEvents:UIControlEventTouchUpInside];
    //发货按钮
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(footerView.frame.size.width-80, footerView.frame.size.height-35, 65, 30)];
    [payButton setBackgroundColor:[UIColor redColor]];
    [payButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [payButton setTitle:@"发货" forState:UIControlStateNormal];
    [payButton setTag:section];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [payButton addTarget:self action:@selector(payButton:) forControlEvents:UIControlEventTouchUpInside];
    //评价按钮
    UIButton *judgeBtn = [[UIButton alloc] initWithFrame:CGRectMake(footerView.frame.size.width-80, footerView.frame.size.height-35, 65, 30)];
    [judgeBtn setBackgroundColor:[UIColor redColor]];
    [judgeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [judgeBtn setTitle:@"评价" forState:UIControlStateNormal];
    [judgeBtn setTag:section];
    [judgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [judgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //[button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    
    //根据当前页面的state设置按钮的显示和隐藏
    if ([_orderState isEqualToString:@"0"]) {
        [footerView addSubview:okOederBtn];
    }
    else if ([_orderState isEqualToString:@"2"]){
        [footerView
addSubview:payButton];
    }
    else if ([_orderState isEqualToString:@"4"]){
        [footerView addSubview:judgeBtn];
    }
    return footerView;
}


#pragma mark -- 订单上按钮响应事件
//确认按钮
- (void)okOederBtn:(UIButton *)btn{
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[btn.tag];
    
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/StoreConfirm"];
    NSDictionary *paramDict = @{
                                @"ordersId":OM.Id,
                                @"isConfirm":@"true",
                                };
    
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          //            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          if (jsonDic[@"Success"]) {
                                              //成功
                                              NSLog(@"------------------%@", jsonDic);
                                              [_orderTableView reloadData];
                                              [SVProgressHUD showSuccessWithStatus:  k_Success_Load];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];

}
//发货按钮
- (void)payButton:(UIButton *)btn{
    
    
}
//改价按钮
- (void)changGoodPrice:(GoodModel *)goodModel andWithModel:(OrderModel *)orderModel andWithChangePrice:(NSString *)text{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/StoreConfirmPrice"];
    
    NSDictionary *competitionOrderJson = @{
                                           @"Id":goodModel.Id,
                                           @"OrdersId":orderModel.Id,
                                           @"PartsId":goodModel.PartsId,
                                           @"Cnt":goodModel.Cnt,
                                           @"Price":goodModel.Price,
                                           @"Point":@"",
                                           @"Evaluate":@"",
                                           @"CurrentPrice":text,
                                           @"Reason":@""
                                           };
    NSError *error;
    NSData *competitionOrdersJsonData = [NSJSONSerialization dataWithJSONObject:competitionOrderJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *competitionOrdersJsonDataJsonString = [[NSString alloc] initWithData:competitionOrdersJsonData encoding:NSUTF8StringEncoding];

    
    NSDictionary *paramDict = @{
                                @"ordersId":orderModel.Serial,
                                @"ordersPartsJson":competitionOrdersJsonDataJsonString,
                                };
    
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          //            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          if (jsonDic[@"Success"]) {
                                              //成功
                                              NSLog(@"------------------%@", jsonDic);
                                              
                                              // 取得ios系统唯一的全局的广播站 通知中心
                                              NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                                              //设置广播内容
                                              //将内容封装到广播中 给ios系统发送广播
                                              // ChangeTheme频道
                                              [nc postNotificationName:@"ChangePrice" object:self];

                                              [self.orderTableView reloadData];
                                              [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];

}



//返回某个section中rows的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderModel *OM = [[OrderModel alloc] init];
    OM = _partlistArr[section];
    return OM.PartsList.count;
}


//这个方法是用来创建cell对象，并且给cell设置相关属性的
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置标识符
    static NSString *userStoreCellIdentifer = @"orderCellIdentifer";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCellIdentifer"];
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userStoreCellIdentifer];
    }
    cell.controller = self;
    OrderModel *OM=_partlistArr[indexPath.section];
    GoodModel *GM=OM.PartsList[indexPath.row];
    [cell setOrderWithModel:GM andWtihState:_orderState andWithOrderModel:OM];
    
    return cell;
}

//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"zzzzzz%lu",(unsigned long)_partlistArr.count);
    return _partlistArr.count;
}

#pragma mark -- UITableViewDelegate
//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
//选中cell时调起的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中cell要做的操作
    
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