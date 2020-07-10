//
//  JJRegisterVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/6.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJRegisterVC.h"
#import "GraphCodeView.h"
#import "JJRegisterModel.h"
#import "JJCustomView.h"

@interface JJRegisterVC ()<UITextViewDelegate,GraphCodeViewDelegate>

@property (nonatomic ,strong)GraphCodeView *graphCodeView;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)JJRegisterModel *registerModel;
@property (nonatomic ,strong)UIButton *countDownBtn;
@property (strong, nonatomic)CountDown *countDownForBtn;
@property (strong, nonatomic)UIScrollView *registerScrollView;
@end

@implementation JJRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topNavBar.hidden = YES;
    
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setValue:@"" forKey:@"mobile"];
    [self.mutableDic setValue:@"" forKey:@"password"];
    [self.mutableDic setValue:@"" forKey:@"confirmpwd"];
    [self.mutableDic setValue:@"" forKey:@"tuijian"];
    [self.mutableDic setValue:@"" forKey:@"code"];
    [self.mutableDic setValue:@"" forKey:@"prefix"];
    _countDownForBtn = [[CountDown alloc] init];
    
    [self init_UI];
}

- (void)init_UI
{
    [self registerScrollView];
    
    CGRect languageSwitchRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"中文简体") withFont:label_font_PingFang_SC(13)];
    UIButton *languageSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerScrollView addSubview:languageSwitchBtn];
    [languageSwitchBtn addTarget:self action:@selector(languageSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [ZDPayFuncTool setBtn:languageSwitchBtn Title:GCLocalizedString(@"中文简体") btnImage:@"方向"];
    [languageSwitchBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
    languageSwitchBtn.titleLabel.font = label_font_PingFang_SC(13);
    languageSwitchBtn.frame = CGRectMake((ScreenWidth-languageSwitchRect.size.width-20-20), 44, languageSwitchRect.size.width+20, 12.5);
    [self.registerScrollView bringSubviewToFront:languageSwitchBtn];
    
    CGRect registerTitleLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"注册") withFont:label_font_PingFang_SC(38)];
    UILabel *registerTitleLab = [[UILabel alloc] init];
    registerTitleLab.frame = CGRectMake(15.5,141,registerTitleLabRect.size.width,registerTitleLabRect.size.height);
    [self.registerScrollView addSubview:registerTitleLab];
    registerTitleLab.textColor = UICOLOR_RGB_SAME(2);
    registerTitleLab.font = label_font_PingFang_SC(38);
    registerTitleLab.text = GCLocalizedString(@"注册");
    
    NSArray *registerArray = @[GCLocalizedString(@"请输入手机号"),GCLocalizedString(@"设置6~18位大小写字母和数字组合的登录密码"),GCLocalizedString(@"确认登录密码"),GCLocalizedString(@"邀请码（必填）"),GCLocalizedString(@"请输入数字验证码")];
    [registerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15.5, registerTitleLab.bottom+47-9+i*(13.5+50), ScreenWidth-31, 13.5+18)];
        [self.registerScrollView addSubview:textField];
        textField.placeholder = registerArray[i];
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.tag = i+100;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        if (i==0) {
            textField.clearsOnBeginEditing = NO;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        if (i==0 || i==4) textField.keyboardType = UIKeyboardTypeNumberPad;
        
        UIView *lineView = [UIView new];
        [self.registerScrollView addSubview:lineView];
        lineView.backgroundColor = UICOLOR_RGB_SAME(243);
        lineView.frame = CGRectMake(14.5, registerTitleLab.bottom+79+i*(1+64), ScreenWidth-29, 1);
        
        if (i>=1 && i<=2) {
            UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.registerScrollView addSubview:privacyBtn];
            [privacyBtn addTarget:self action:@selector(privacyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [privacyBtn setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
            privacyBtn.frame = CGRectMake(ScreenWidth-18-16.5, registerTitleLab.bottom+47+i*(13.5+50), 18, 11);
            privacyBtn.tag = 200+i;
            privacyBtn.selected = YES;
            
            textField.secureTextEntry = YES;
        }
        if (i==4) {
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"发送验证码") withFont:label_font_PingFang_SC(13)];
            UIButton *countDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
             self.countDownBtn = countDownBtn;
             [self.countDownBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
             [self.countDownBtn setTitle:GCLocalizedString(@"发送验证码") forState:UIControlStateNormal];
             [self.registerScrollView addSubview:countDownBtn];
             countDownBtn.titleLabel.font = label_font_PingFang_SC(13);
             countDownBtn.layer.cornerRadius = ratioH(13);
             countDownBtn.layer.masksToBounds = YES;
             [countDownBtn addTarget:self action:@selector(senderCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            countDownBtn.frame = CGRectMake(ScreenWidth-countDownRect.size.width-14, mcNavBarHeight+mcStatusBarHeight+420, countDownRect.size.width,30.5);
        }
    }];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:GCLocalizedString(@"注册即表示同意《用户协议及隐私条款》")];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"proxy://"
                             range:[[attributedString string] rangeOfString:GCLocalizedString(@"《用户协议及隐私条款》")]];
    [attributedString addAttribute:NSFontAttributeName value:label_font_PingFang_SC(13) range:NSMakeRange(0, attributedString.length)];
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(15.5, registerTitleLab.bottom+369.5, ScreenWidth, 100)];
    [self.registerScrollView addSubview: textview];
    textview.attributedText = attributedString;
    textview.textColor = UICOLOR_RGB_SAME(93);
    textview.linkTextAttributes = @{NSForegroundColorAttributeName: UICOLOR_RGB(6, 101, 235, 1),
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    textview.textAlignment = NSTextAlignmentLeft;
    textview.delegate = self;
    textview.editable = NO;
    textview.scrollEnabled = NO;
    
    CGRect attributedStringRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"注册即表示同意《用户协议及隐私条款》") withFont:label_font_PingFang_SC(13)];
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.frame = CGRectMake(14.5,registerTitleLab.bottom+406-13+attributedStringRect.size.height,ScreenWidth-29,50.5);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,registerBtn.size.width,registerBtn.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:63/255.0 green:181/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:7/255.0 green:109/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [registerBtn.layer addSublayer:gl];
    [self.registerScrollView addSubview:registerBtn];
    registerBtn.layer.cornerRadius = 5;
    
    UILabel *btnLab = [UILabel new];
    [registerBtn addSubview:btnLab];
    btnLab.textColor = UICOLOR_RGB_SAME(255);
    btnLab.font = label_font_PingFang_SC(15);
    btnLab.frame = CGRectMake(0, 18, registerBtn.size.width, 14);
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = GCLocalizedString(@"注册");
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:GCLocalizedString(@"已有账号？登录")];
    [attributedString2 addAttribute:NSLinkAttributeName
                             value:@"login://"
                             range:[[attributedString2 string] rangeOfString:GCLocalizedString(@"登录")]];
    [attributedString2 addAttribute:NSFontAttributeName value:label_font_PingFang_SC(13) range:NSMakeRange(0, attributedString2.length)];
    UITextView *textview2 = [[UITextView alloc] initWithFrame:CGRectMake(0, registerBtn.bottom+23, ScreenWidth, 100)];
    [self.registerScrollView addSubview: textview2];
    textview2.attributedText = attributedString2;
    textview2.textColor = UICOLOR_RGB_SAME(93);
    textview2.linkTextAttributes = @{NSForegroundColorAttributeName: UICOLOR_RGB(6, 101, 235, 1),
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    textview2.textAlignment = NSTextAlignmentCenter;
    textview2.delegate = self;
    textview2.editable = NO;
    textview2.scrollEnabled = NO;
}

#pragma mark - lazy loading
- (GraphCodeView *)graphCodeView{
    if (!_graphCodeView) {
        _graphCodeView=[[GraphCodeView alloc]initWithFrame:CGRectMake(ScreenWidth-100-14, mcNavBarHeight+mcStatusBarHeight+383, 100.0,30.5)];
        [_graphCodeView setCodeStr:@"S3G9"];
        [_graphCodeView setDelegate:self];
        [self.registerScrollView addSubview:_graphCodeView];
    }
    return _graphCodeView;
}

- (UIScrollView *)registerScrollView
{
    if (!_registerScrollView) {
        _registerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _registerScrollView.showsVerticalScrollIndicator = NO;
        _registerScrollView.showsHorizontalScrollIndicator = NO;
        _registerScrollView.contentSize = CGSizeMake(ScreenWidth, 800);
        _registerScrollView.scrollEnabled = YES;
        [self.view addSubview:_registerScrollView];
    }
    return _registerScrollView;
}

#pragma mark - delegate
- (void)didTapGraphCodeView:(GraphCodeView *)graphCodeView{
    NSLog(@"点击了图形验证码");
    JJRegisterModel *model = [JJRegisterModel mj_objectWithKeyValues:self.mutableDic];
    self.registerModel = model;
    
    if ([model.mobile isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入手机号") target:nil];
        return;
    }
    [self networking_sendcode];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"proxy"]) {
        NSLog(@"用户协议---------------");
        return NO;
    } else if ([[URL scheme] isEqualToString:@"login"]) {
       NSLog(@"登陆---------------");
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - updateLabel
- (void)updateLabel {
    [self.registerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self init_UI];
}

#pragma mark - actions
- (void)textFieldAction:(UITextField *)textField
{
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"mobile"];
    } else if (textField.tag == 101) {
        [self.mutableDic setValue:textField.text forKey:@"password"];
    } else if (textField.tag == 102) {
        [self.mutableDic setValue:textField.text forKey:@"confirmpwd"];
    } else if (textField.tag == 103) {
        [self.mutableDic setValue:textField.text forKey:@"tuijian"];
    } else if (textField.tag == 104) {
        [self.mutableDic setValue:textField.text forKey:@"code"];
    }
}

- (void)senderCodeBtnAction:(UIButton *)sender
{
    JJRegisterModel *model = [JJRegisterModel mj_objectWithKeyValues:self.mutableDic];
    self.registerModel = model;
    
    if ([model.mobile isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入手机号") target:nil];
        return;
    }
    
    [self networking_sendcode];
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
    JJRegisterModel *model = [JJRegisterModel mj_objectWithKeyValues:self.mutableDic];
    self.registerModel = model;
    
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
    
    if ([model.tuijian isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"邀请码") target:nil];
        return;
    }

    [self networking_register];
}

- (void)privacyBtnAction:(UIButton *)sender
{
    if (sender.tag == 201) {
        UITextField *textField = [self.registerScrollView viewWithTag:101];
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
        UITextField *textField = [self.registerScrollView viewWithTag:102];
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

#pragma mark - 定时器
- (void)startcountDown {
    NSTimeInterval aMinutes = 60;
    [_countDownForBtn countDownWithStratDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes] completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond==0) {
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"发送验证码") withFont:label_font_PingFang_SC(13)];
            self.countDownBtn.frame = CGRectMake(ScreenWidth-countDownRect.size.width-14, mcNavBarHeight+mcStatusBarHeight+420, countDownRect.size.width,30.5);
            self.countDownBtn.enabled = YES;
            [self.countDownBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
            [self.countDownBtn setTitle:GCLocalizedString(@"发送验证码") forState:UIControlStateNormal];
        }else{
            NSString *str = GCLocalizedString(@"重新发送");
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[NSString stringWithFormat:@"%lis%@",totoalSecond,str] withFont:label_font_PingFang_SC(13)];
            self.countDownBtn.frame = CGRectMake(ScreenWidth-countDownRect.size.width-14, mcNavBarHeight+mcStatusBarHeight+420, countDownRect.size.width,30.5);
            [self.countDownBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
            self.countDownBtn.enabled = NO;
            [self.countDownBtn setTitle:[NSString stringWithFormat:@"%lis%@",totoalSecond,str] forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - networking
- (void)networking_register
{
    NSString *confirmpwd = [NSString stringWithFormat:@"%@",self.registerModel.confirmpwd];
    NSString *password = [NSString stringWithFormat:@"%@",self.registerModel.password];
    NSString *mobile = [NSString stringWithFormat:@"%@",self.registerModel.mobile];
    NSString *tuijian = [NSString stringWithFormat:@"%@",self.registerModel.tuijian];
    NSString *code = [NSString stringWithFormat:@"%@",self.registerModel.code];
    NSString *prefix = [NSString stringWithFormat:@"%@",self.registerModel.prefix];
    NSDictionary *params = @{@"mobile":mobile,
                             @"password":password,
                             @"confirmpwd":confirmpwd,
                             @"tuijian":tuijian,
                             @"code":code,
                             @"prefix":prefix
                            };
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,REGISTER] parameters:params successBlock:^(id  _Nonnull responseObject) {
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REGISTERSUCESS" object:nil userInfo:responseObject];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showMessage:[responseObject objectForKey:@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        NSLog(@"1");
    }];
}

- (void)networking_sendcode
{
    NSDictionary *params = @{@"mobile":self.registerModel.mobile};
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GET_REGISTER_CODE] parameters:params successBlock:^(id  _Nonnull responseObject) {
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self.mutableDic setValue:[responseObject objectForKey:@"data"] forKey:@"prefix"];
            JJRegisterModel *model = [JJRegisterModel mj_objectWithKeyValues:self.mutableDic];
            self.registerModel = model;
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

@end
