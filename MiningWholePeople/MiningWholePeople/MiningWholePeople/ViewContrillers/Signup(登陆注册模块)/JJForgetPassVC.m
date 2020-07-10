//
//  JJForgetPassVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/6.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJForgetPassVC.h"
#import "JJForgetPassModel.h"

@interface JJForgetPassVC ()

@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)UIButton *countDownBtn;
@property (strong, nonatomic)CountDown *countDownForBtn;
@property (strong, nonatomic)JJForgetPassModel *forgetPassModel;
@end

@implementation JJForgetPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = GCLocalizedString(@"忘记密码");
    
    _countDownForBtn = [[CountDown alloc] init];
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setValue:@"" forKey:@"mobile"];
    [self.mutableDic setValue:@"" forKey:@"password"];
    [self.mutableDic setValue:@"" forKey:@"code"];
    [self.mutableDic setValue:@"" forKey:@"prefix"];
    
    [self init_UI];
}

- (void)init_UI
{
    NSArray *defaultArray = @[GCLocalizedString(@"请输入手机号"),GCLocalizedString(@"请输入验证码"),GCLocalizedString(@"请输入登陆密码"),GCLocalizedString(@"请确认登陆密码")];
    [defaultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15.5,mcNavBarHeight+mcStatusBarHeight+50-13+i*(13.5+50), ScreenWidth-31, 13.5+18)];
        [self.view addSubview:textField];
        textField.placeholder = defaultArray[i];
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *lineView = [UIView new];
        [self.view addSubview:lineView];
        lineView.backgroundColor = UICOLOR_RGB_SAME(243);
        lineView.frame = CGRectMake(14.5, mcNavBarHeight+mcStatusBarHeight+80+i*(1+64), ScreenWidth-29, 1);
        
        textField.tag = i+100;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        if (i==0) {
            textField.clearsOnBeginEditing = NO;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        if (i==0 || i==4) textField.keyboardType = UIKeyboardTypeNumberPad;
        
        if (i>=2 && i<=3) {
            UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.view addSubview:privacyBtn];
            [privacyBtn addTarget:self action:@selector(privacyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [privacyBtn setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
            privacyBtn.frame = CGRectMake(ScreenWidth-18-16.5, mcNavBarHeight+mcStatusBarHeight+48+i*(13.5+50), 18, 11);
            privacyBtn.tag = 200+i;
            privacyBtn.selected = YES;
            
            textField.secureTextEntry = YES;
        }
        if (i==1) {
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"发送验证码") withFont:label_font_PingFang_SC(13)];
            UIButton *countDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
             self.countDownBtn = countDownBtn;
             [self.countDownBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
             [self.countDownBtn setTitle:GCLocalizedString(@"发送验证码") forState:UIControlStateNormal];
             [self.view addSubview:countDownBtn];
             countDownBtn.titleLabel.font = label_font_PingFang_SC(13);
             countDownBtn.layer.cornerRadius = ratioH(13);
             countDownBtn.layer.masksToBounds = YES;
             [countDownBtn addTarget:self action:@selector(senderCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            countDownBtn.frame = CGRectMake(ScreenWidth-countDownRect.size.width-14, mcNavBarHeight+mcStatusBarHeight+99, countDownRect.size.width, 30.5);
        }
    }];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.frame = CGRectMake(14.5,mcNavBarHeight+mcStatusBarHeight+200+67*2,ScreenWidth-29,50.5);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,registerBtn.size.width,registerBtn.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:63/255.0 green:181/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:7/255.0 green:109/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [registerBtn.layer addSublayer:gl];
    [self.view addSubview:registerBtn];
    registerBtn.layer.cornerRadius = 5;

    UILabel *btnLab = [UILabel new];
    [registerBtn addSubview:btnLab];
    btnLab.textColor = UICOLOR_RGB_SAME(255);
    btnLab.font = label_font_PingFang_SC(15);
    btnLab.frame = CGRectMake(0, 18, registerBtn.size.width, 14);
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = GCLocalizedString(@"确认");
}

#pragma mark - actions
- (void)textFieldAction:(UITextField *)textField
{
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"mobile"];
    } else if (textField.tag == 101) {
           [self.mutableDic setValue:textField.text forKey:@"code"];
    } else if (textField.tag == 102) {
        [self.mutableDic setValue:textField.text forKey:@"password"];
    } else if (textField.tag == 103) {
        [self.mutableDic setValue:textField.text forKey:@"confirmpwd"];
    }
}

- (void)loginBtnAction:(UIButton *)sender
{
    JJForgetPassModel *model = [JJForgetPassModel mj_objectWithKeyValues:self.mutableDic];
    self.forgetPassModel = model;

    if ([model.mobile isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入手机号") target:nil];
        return;
    }
    
    if ([model.code isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入验证码") target:nil];
        return;
    }
    
    if (model.mobile.length!=11) {
        [self showMessage:GCLocalizedString(@"请输入正确的手机号") target:nil];
        return;
    }
    
    if ([model.password isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入8到20位的字母数字组合") target:nil];
        return;
    }
    
    if (model.password.length<8  || model.password.length>20 || [ZDPayFuncTool isStringContainNumberWith:model.password] == NO || [ZDPayFuncTool isStringContainCharWith:model.password] == NO) {
        [self showMessage:GCLocalizedString(@"请输入8到20位的字母数字组合") target:nil];
        return;
    }
    
    if ([model.confirmpwd isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"确认登陆密码") target:nil];
        return;
    }
    
    if (![model.confirmpwd isEqualToString:model.password]) {
        [self showMessage:GCLocalizedString(@"登陆密码不一致") target:nil];
        return;
    }

}

- (void)privacyBtnAction:(UIButton *)sender
{
    if (sender.tag == 202) {
        UITextField *textField = [self.view viewWithTag:102];
        if (sender.selected == YES) {
            textField.secureTextEntry = NO;
            [sender setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
            sender.selected = NO;
        } else {
            [sender setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
            textField.secureTextEntry = YES;
            sender.selected = YES;
        }
    } else {
        UITextField *textField = [self.view viewWithTag:103];
        if (sender.selected == YES) {
            textField.secureTextEntry = NO;
            [sender setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
            sender.selected = NO;
        } else {
            [sender setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
            textField.secureTextEntry = YES;
            sender.selected = YES;
        }
    }
}

- (void)senderCodeBtnAction:(UIButton *)sender
{
    JJForgetPassModel *model = [JJForgetPassModel mj_objectWithKeyValues:self.mutableDic];
    self.forgetPassModel = model;
    
    if ([model.mobile isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入手机号") target:nil];
        return;
    }
    
    if (model.mobile.length!=11) {
        [self showMessage:GCLocalizedString(@"请输入正确的手机号") target:nil];
        return;
    }
    
    [self networking_sendcode];
}

#pragma mark - 定时器
- (void)startcountDown {
    NSTimeInterval aMinutes = 60;
    [_countDownForBtn countDownWithStratDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes] completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond==0) {
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"发送验证码") withFont:label_font_PingFang_SC(13)];
            self.countDownBtn.frame = CGRectMake(ScreenWidth-countDownRect.size.width-14, mcNavBarHeight+mcStatusBarHeight+99, countDownRect.size.width,30.5);
            self.countDownBtn.enabled = YES;
            [self.countDownBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
            [self.countDownBtn setTitle:GCLocalizedString(@"发送验证码") forState:UIControlStateNormal];
        }else{
            NSString *str = GCLocalizedString(@"重新发送");
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[NSString stringWithFormat:@"%lis%@",totoalSecond,str] withFont:label_font_PingFang_SC(13)];
            self.countDownBtn.frame = CGRectMake(ScreenWidth-countDownRect.size.width-14, mcNavBarHeight+mcStatusBarHeight+99, countDownRect.size.width,30.5);
            [self.countDownBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
            self.countDownBtn.enabled = NO;
            [self.countDownBtn setTitle:[NSString stringWithFormat:@"%lis%@",totoalSecond,str] forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - networking
- (void)networking_sendcode
{
    NSString *mobile = [NSString stringWithFormat:@"%@",self.forgetPassModel.mobile];
    NSDictionary *params = @{@"mobile":mobile};
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,FORGET_GET_CODE] parameters:params successBlock:^(id  _Nonnull responseObject) {
        if (!responseObject) {
            return;
        }

        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self.mutableDic setValue:[responseObject objectForKey:@"data"] forKey:@"prefix"];
            [self startcountDown];
        } else {
            [self showMessage:[responseObject objectForKey:@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (error) {
            NSString *responseData = error.userInfo[NSLocalizedDescriptionKey];
            [self showMessage:responseData target:nil];
        }
    }];
}

- (void)networking_forget
{
    NSString *confirmpwd = [NSString stringWithFormat:@"%@",self.forgetPassModel.confirmpwd];
    NSString *password = [NSString stringWithFormat:@"%@",self.forgetPassModel.password];
    NSString *mobile = [NSString stringWithFormat:@"%@",self.forgetPassModel.mobile];
    NSString *code = [NSString stringWithFormat:@"%@",self.forgetPassModel.code];
    NSString *prefix = [NSString stringWithFormat:@"%@",self.forgetPassModel.prefix];
    NSDictionary *params = @{@"mobile":mobile,
                             @"password":password,
                             @"confirmpwd":confirmpwd,
                             @"code":code,
                             @"prefix":prefix
                            };
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,FORGET] parameters:params successBlock:^(id  _Nonnull responseObject) {
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self.mutableDic setValue:[responseObject objectForKey:@"data"] forKey:@"prefix"];
        } else {
            [self showMessage:[responseObject objectForKey:@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        if (error) {
            NSString *responseData = error.userInfo[NSLocalizedDescriptionKey];
            [self showMessage:responseData target:nil];
        }
    }];
}
@end
