//
//  WithdrawalViewController.m
//  CLWsdht
//
//  Created by yang on 16/4/16.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "WithdrawalView.h"
#import "BaseHeader.h"

@interface WithdrawalViewController ()

@end

@implementation WithdrawalViewController
{
    WithdrawalView *view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSubViews];
}
//提交申请
- (void)withDrawal:(NSNotification *)noti
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/Cash"];
    [ApplicationDelegate.httpManager POST:urlStr parameters:noti.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"%@", jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [SVProgressHUD showInfoWithStatus:@"已提交申请"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                });
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
//注册通知
- (void)regisNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withDrawal:) name:@"withDrawal" object:nil];
}
//UI
- (void)setSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"资金结算";
    view = [[WithdrawalView alloc] init];
    view.price = self.price;
    view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:view];
    [self regisNotification];
}
//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"withDrawal" object:nil];
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
