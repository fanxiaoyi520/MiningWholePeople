//
//  JJLoginPasswordVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/10.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJLoginPasswordVC.h"

@interface JJLoginPasswordModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *payword;
@property (nonatomic ,copy)NSString *confirmpwd;
@end

@implementation JJLoginPasswordModel

@end

@interface JJLoginPasswordVC ()

@property (nonatomic ,assign)CGFloat sure_top;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)JJLoginPasswordModel *loginPasswordModel;
@end

@implementation JJLoginPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = GCLocalizedString(@"登陆密码");
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setValue:@"" forKey:@"payword"];
    [self.mutableDic setValue:@"" forKey:@"confirmpwd"];
    
    [self init_UI];
}

- (void)init_UI
{
    NSArray *fundArray = @[GCLocalizedString(@"请输入您要设置的登录密码"),GCLocalizedString(@"请再次输入您的新登录密码")];
    [fundArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15.5, mcNavBarHeight+mcStatusBarHeight+30+i*(13.5+50), ScreenWidth-31, 13.5+18*2)];
        [self.view addSubview:textField];
        textField.placeholder = fundArray[i];
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.tag = 100 + i;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
        
        UIView *lineView = [UIView new];
        [self.view addSubview:lineView];
        lineView.backgroundColor = UICOLOR_RGB_SAME(243);
        lineView.frame = CGRectMake(14.5, mcNavBarHeight+mcStatusBarHeight+30+13.5+18*2+i*(1+64), ScreenWidth-29, 1);
        
        if (i==1) self.sure_top = lineView.frame.origin.y;
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(14.5,self.sure_top+51.5,ScreenWidth-29,50.5);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,sureBtn.size.width,sureBtn.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:63/255.0 green:181/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:7/255.0 green:109/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [sureBtn.layer addSublayer:gl];
    [self.view addSubview:sureBtn];
    sureBtn.layer.cornerRadius = 5;
    
    UILabel *btnLab = [UILabel new];
    [sureBtn addSubview:btnLab];
    btnLab.textColor = UICOLOR_RGB_SAME(255);
    btnLab.font = label_font_PingFang_SC(15);
    btnLab.frame = CGRectMake(0, 18, sureBtn.size.width, 14);
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = GCLocalizedString(@"确认");
}

#pragma mark - actions
- (void)textFieldAction:(UITextField *)textField
{
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"payword"];
    } else {
        [self.mutableDic setValue:textField.text forKey:@"confirmpwd"];
    }
}

- (void)sureBtnAction:(UIButton *)sender
{
    JJLoginPasswordModel *model = [JJLoginPasswordModel mj_objectWithKeyValues:self.mutableDic];
    self.loginPasswordModel = model;
    
    if ([model.payword isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入6到20位的字母数字组合!") target:nil];
        return;
    }
    
    if (model.payword.length <6 || model.payword.length > 20) {
        [self showMessage:GCLocalizedString(@"请输入6到20位的字母数字组合!") target:nil];
        return;
    }
    
    if ([model.confirmpwd isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"两次密码不一致") target:nil];
        return;
    }
    
    if (![model.confirmpwd isEqualToString:model.payword]) {
        [self showMessage:GCLocalizedString(@"两次密码不一致") target:nil];
        return;
    }
    [self networking_set_pay_pwd];
}

#pragma mark - networking
- (void)networking_set_pay_pwd
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *payword = [NSString stringWithFormat:@"%@",self.loginPasswordModel.payword];
    NSString *confirmpwd = [NSString stringWithFormat:@"%@",self.loginPasswordModel.confirmpwd];
    NSDictionary *params = @{@"password":payword,@"confirmpwd":confirmpwd};
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,SET_PWD] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            if (self.loginPasswordBlock) {
                self.loginPasswordBlock([responseObject objectForKey:@"msg"]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showMessage:[responseObject objectForKey:@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *responseData = error.userInfo[NSLocalizedDescriptionKey];
            [self showMessage:responseData target:nil];
        }
    }];
}

@end
