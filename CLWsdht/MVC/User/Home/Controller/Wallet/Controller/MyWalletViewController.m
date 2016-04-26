//
//  MyWalletViewController.m
//  CLWsdht
//
//  Created by yang on 16/4/16.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletView.h"
#import "BaseHeader.h"
#import "WithdrawalViewController.h"
#import "UserInfo.h"

@interface MyWalletViewController ()

@end

@implementation MyWalletViewController
{
    MyWalletView *walletView;
    UserInfo *info;
}

//进入页面刷新
- (void)viewWillAppear:(BOOL)animated
{
    [self dataRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSubViews];
}

//请求数据
- (void)dataRequest
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"auth.asmx/GetBalance"];
    NSDictionary *paramDict = @{
                                @"usrId":info.user_Id,
                                @"usrType":@"2"
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
                MyWalletModel *model = [[MyWalletModel alloc] initWithDictionary:[jsonDic objectForKey:@"Data"]];
                walletView.model = model;
                [SVProgressHUD dismiss];

            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
}

//点击立即结算退出下一个界面
- (void)myWalletWith:(NSNotification *)noti{
    [self setHidesBottomBarWhenPushed:YES];
    WithdrawalViewController *withDrawal = [[WithdrawalViewController alloc] init];
    withDrawal.price = [noti.userInfo objectForKey:@"money"];
    [self.navigationController pushViewController:withDrawal animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

//UI
- (void)setSubViews
{
    self.title = @"我的钱包";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    info = ApplicationDelegate.userInfo;
    walletView = [[MyWalletView alloc] init];
    walletView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:walletView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myWalletWith:) name:@"MyWallet" object:nil];
}

//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyWallet" object:nil];
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
