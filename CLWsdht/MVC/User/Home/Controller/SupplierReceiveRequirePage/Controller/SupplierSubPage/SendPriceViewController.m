//
//  SendPriceViewController.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "SendPriceViewController.h"
#import "PlaceHolderTextView.h"
#import "ChooseMyGoodsListViewController.h"
#import "SupplierStoreListModel.h"

@interface SendPriceViewController () <UITextFieldDelegate> {
    id __block goodsBack;
}
@property (strong, nonatomic) IBOutlet UIView *titleBv;
@property (strong, nonatomic) IBOutlet UILabel *signTitle;

@property (strong, nonatomic) IBOutlet UIView *chooseGoodsBv;
@property (strong, nonatomic) IBOutlet UIView *descripeBv;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UITextField *priceTF;
@property (nonatomic, strong) PlaceHolderTextView *pHTextView;
@property (strong, nonatomic) IBOutlet UILabel *descripTitle;
@property (strong, nonatomic) IBOutlet UILabel *goodsName;

@property (nonatomic, strong) SupplierStoreListModel *tempModel;

@end

@implementation SendPriceViewController

- (void)dealloc
{
    [kNotiCenter removeObserver:goodsBack];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"需求报价";
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self setBack];
    }
    return self;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textAlignment = 2;
        _titleLb.textColor = [UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1.0];
        _titleLb.font = [UIFont systemFontOfSize:14];
        [_titleBv addSubview:_titleLb];
        [_titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleBv);
            make.height.equalTo(@20);
            make.left.equalTo(_signTitle.mas_right).offset(20);
            make.right.equalTo(_titleBv).offset(-15);
        }];
    }
    return _titleLb;
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

- (IBAction)sure:(id)sender {
#pragma mark  发送报价
    [self postPrice];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Check for non-numeric characters
    NSUInteger lengthOfString = string.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
        unichar character = [string characterAtIndex:loopIndex];
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57) return NO; // 57 unichar for 9
    }
    
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > 6) return NO;//限制长度
    return YES;
}

-  (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
}

- (void)postPrice {
    if (_priceTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"价格不能为空"];
        return;
    } else if (_tempModel == nil) {
        [SVProgressHUD showInfoWithStatus:@"请选择商品"];
        return;
    } else if (_pHTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"说两句吧"];
        return;
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/AddDemandRespond"];
    NSDictionary *param = @{  @"Id":[MJYUtils mjy_uuid],
                              @"DemandId":_baseModel.Id,
                              @"UsrStoreId":_tempModel.UsrStoreId,
                              @"Price":_priceTF.text,
                              @"Description":_pHTextView.text,
                              @"PartsId":_tempModel.Id};
    NSDictionary *paramDict = @{
                                @"rpJson":[JYJSON JSONStringWithDictionaryOrArray:param]
                                };
  
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                
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



- (void)bVaddTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.chooseGoodsBv.userInteractionEnabled = YES;
    [self.chooseGoodsBv addGestureRecognizer:tap];
}
- (void)tap:(UITapGestureRecognizer *)tap {
    ChooseMyGoodsListViewController *chooseGoods  = [[ChooseMyGoodsListViewController alloc] init];
    [self.navigationController pushViewController:chooseGoods animated:YES];
}


- (PlaceHolderTextView *)pHTextView {
    if (!_pHTextView) {
        _pHTextView = [[PlaceHolderTextView alloc] init];
        _pHTextView.backgroundColor = [UIColor colorWithRed: 240 / 255.0  green:240 / 255.0 blue:240 /255.0 alpha:1.0f];
      
        _pHTextView.font = [UIFont systemFontOfSize:13];
        _pHTextView.layer.cornerRadius = 15;
        _pHTextView.layer.masksToBounds = YES;
        [self.descripeBv addSubview:_pHTextView];
        _pHTextView.placeholder = @"老板请描述下您的商品, 买家都很关心";
        [_pHTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_descripTitle.mas_bottom).offset(8);
            make.left.equalTo(_descripeBv).offset(15);
            make.right.equalTo(_descripeBv).offset(-15);
            make.bottom.equalTo(_descripeBv).offset(-8);
        }];
    }
    return _pHTextView;
}

- (void)addNoti {
   goodsBack = [kNotiCenter addObserverForName:@"chooseStoreGoodsBack" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        _tempModel = note.userInfo[@"storeModel"];
        _goodsName.text = _tempModel.TypeName;
    }];
}


- (void)setBaseModel:(BaseModel *)baseModel {
    if (_baseModel != baseModel) {
        _baseModel = baseModel;
    }
}

- (void)setKit {
     [self titleLb];
     [self pHTextView];
    _priceTF.delegate = self;
    _titleLb.text = _baseModel.Title;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self addNoti];
    [self bVaddTap];
    [self setKit];
   
    
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
