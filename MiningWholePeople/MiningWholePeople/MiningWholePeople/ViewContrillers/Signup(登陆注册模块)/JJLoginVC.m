//
//  JJLoginVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/6.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJLoginVC.h"
#import "JJRegisterVC.h"
#import "JJForgetPassVC.h"
#import "JJLoginModel.h"
#import "JJCustomView.h"

@interface JJLoginVC ()<UITextViewDelegate>

@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)JJLoginModel *loginModel;
@property (nonatomic ,strong)UILabel *loginTitleLab;
@end

@implementation JJLoginVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateLabel];
}

- (void)registerSucessNoti:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]];
    [self showMessage:str target:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topNavBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSucessNoti:) name:@"REGISTERSUCESS" object:nil];

    [self init_UI];
    
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setValue:@"" forKey:@"mobile"];
    [self.mutableDic setValue:@"" forKey:@"password"];
}

- (void)init_UI
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"矩形 1 拷贝 4"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(18, 44, 19, 19);
    
    CGRect languageSwitchRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"中文简体") withFont:label_font_PingFang_SC(13)];
    UIButton *languageSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:languageSwitchBtn];
    [languageSwitchBtn addTarget:self action:@selector(languageSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [ZDPayFuncTool setBtn:languageSwitchBtn Title:GCLocalizedString(@"中文简体") btnImage:@"方向"];
    [languageSwitchBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
    languageSwitchBtn.titleLabel.font = label_font_PingFang_SC(13);
    languageSwitchBtn.frame = CGRectMake((ScreenWidth-languageSwitchRect.size.width-20-20), 44, languageSwitchRect.size.width+20, 12.5);
    
    CGRect registerTitleLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"登录") withFont:label_font_PingFang_SC(39)];
    UILabel *loginTitleLab = [[UILabel alloc] init];
    loginTitleLab.frame = CGRectMake(15.5,141,registerTitleLabRect.size.width,registerTitleLabRect.size.height);
    [self.view addSubview:loginTitleLab];
    loginTitleLab.textColor = UICOLOR_RGB_SAME(2);
    loginTitleLab.font = label_font_PingFang_SC(39);
    loginTitleLab.text = GCLocalizedString(@"登录");
    self.loginTitleLab = loginTitleLab;
    
    CGRect titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"欢迎来到 矿工家族") withFont:label_font_PingFang_SC(17)];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(16,loginTitleLab.bottom+28,titleRect.size.width,17);
    [self.view addSubview:titleLab];
    titleLab.textColor = UICOLOR_RGB_SAME(93);
    titleLab.font = label_font_PingFang_SC(17);
    titleLab.text = GCLocalizedString(@"欢迎来到 矿工家族");
    
    NSArray *defaultArray = @[GCLocalizedString(@"请输入您的账户"),GCLocalizedString(@"请输入登陆密码")];
    [defaultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15.5, loginTitleLab.bottom+86.5-9+i*(13.5+50), ScreenWidth-31, 13.5+18)];
        [self.view addSubview:textField];
        textField.placeholder = defaultArray[i];
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.tag = 100 + i;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        
        UIView *lineView = [UIView new];
        [self.view addSubview:lineView];
        lineView.backgroundColor = UICOLOR_RGB_SAME(243);
        lineView.frame = CGRectMake(14.5, loginTitleLab.bottom+118+i*(1+64), ScreenWidth-29, 1);

        if (i==0) {
            textField.clearsOnBeginEditing = NO;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }

        if (i==1) {
            UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.view addSubview:privacyBtn];
            [privacyBtn addTarget:self action:@selector(privacyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [privacyBtn setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
            privacyBtn.frame = CGRectMake(ScreenWidth-18-16.5, loginTitleLab.bottom+47+35+i*(13.5+50), 18, 11);
            privacyBtn.tag = 200+i;
            privacyBtn.selected = YES;
            
            textField.secureTextEntry = YES;
        }
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.frame = CGRectMake(14.5,loginTitleLab.bottom+283-64,ScreenWidth-29,50.5);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,loginBtn.size.width,loginBtn.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:63/255.0 green:181/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:7/255.0 green:109/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [loginBtn.layer addSublayer:gl];
    [self.view addSubview:loginBtn];
    loginBtn.layer.cornerRadius = 5;
    
    UILabel *btnLab = [UILabel new];
    [loginBtn addSubview:btnLab];
    btnLab.textColor = UICOLOR_RGB_SAME(255);
    btnLab.font = label_font_PingFang_SC(15);
    btnLab.frame = CGRectMake(0, 18, loginBtn.size.width, 14);
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = GCLocalizedString(@"登录");
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:GCLocalizedString(@"忘记密码 | 没有账号？注册")];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"forget://"
                             range:[[attributedString string] rangeOfString:GCLocalizedString(@"忘记密码")]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"register://"
                             range:[[attributedString string] rangeOfString:GCLocalizedString(@"注册")]];
    [attributedString addAttribute:NSFontAttributeName value:label_font_PingFang_SC(13) range:NSMakeRange(0, attributedString.length)];
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(0, loginBtn.bottom+34.5, ScreenWidth, 100)];
    [self.view addSubview: textview];
    textview.attributedText = attributedString;
    textview.textColor = UICOLOR_RGB_SAME(93);
    textview.linkTextAttributes = @{NSForegroundColorAttributeName: UICOLOR_RGB(6, 101, 235, 1),
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    textview.textAlignment = NSTextAlignmentCenter;
    textview.delegate = self;
    textview.editable = NO;
    textview.scrollEnabled = NO;
}

#pragma mark - updateLabel
- (void)updateLabel {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self init_UI];
}


#pragma mark - actions
- (void)textFieldAction:(UITextField *)textField
{
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"mobile"];
    } else if (textField.tag == 101) {
        [self.mutableDic setValue:textField.text forKey:@"password"];
    }
}

- (void)closeBtnAction:(UIButton *)sender
{
    [ZDPayFuncTool getLoginSwitch];
}

- (void)languageSwitchBtnAction:(UIButton *)sender
{
    NSArray *array = @[GCLocalizedString(@"中文简体"),GCLocalizedString(@"English")];
    JJCustomView *customView = [JJCustomView init_JJCustomViewWithVC:self];
    [customView showPopupViewWithData:array];
    customView.clickTableBlock = ^(NSString * _Nonnull name) {

        if ([name isEqualToString:@"中文简体"]) {
            [NSBundle setLanguage:@"zh-Hans"];
            UserInfo *user = [[UserInfoContext sharedUserInfoContext] getUserInfo];
            user.lang = @"cn";
            [Utilities SetNSUserDefaults:user];
        } else {
            [NSBundle setLanguage:@"en"];
            UserInfo *user = [[UserInfoContext sharedUserInfoContext] getUserInfo];
            user.lang = @"en";
            [Utilities SetNSUserDefaults:user];
        }
        [self updateLabel];
    };
}

- (void)loginBtnAction:(UIButton *)sender
{
    JJLoginModel *model = [JJLoginModel mj_objectWithKeyValues:self.mutableDic];
    self.loginModel = model;
    
    if ([model.mobile isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入手机号") target:nil];
        return;
    }
    
    if (model.mobile.length!=11) {
        [self showMessage:GCLocalizedString(@"请输入正确的手机号") target:nil];
        return;
    }
    
    if ([model.password isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入密码") target:nil];
        return;
    }

    [self networking_index];
}

- (void)privacyBtnAction:(UIButton *)sender
{
    UITextField *textField = [self.view viewWithTag:101];
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

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"forget"]) {
        NSLog(@"忘记密码---------------");
        JJForgetPassVC *vc = [JJForgetPassVC new];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"register"]) {
       NSLog(@"注册---------------");
        JJRegisterVC *vc = [JJRegisterVC new];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - networking
- (void)networking_index
{
    NSString *mobile = [NSString stringWithFormat:@"%@",self.loginModel.mobile];
    NSString *password = [NSString stringWithFormat:@"%@",self.loginModel.password];
    
    NSDictionary *params = @{@"mobile":mobile,@"password":password};
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,LOGIN] parameters:params successBlock:^(id  _Nonnull responseObject) {
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            UserInfo *user = [[UserInfoContext sharedUserInfoContext] getUserInfo];
            user.isLogin = YES;
            user.phoneNumber = self.loginModel.mobile;
            user.tabBarSelected = 0;
            user.token = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"token"]];
            [Utilities SetNSUserDefaults:user];
            [ZDPayFuncTool getLoginSwitch];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
