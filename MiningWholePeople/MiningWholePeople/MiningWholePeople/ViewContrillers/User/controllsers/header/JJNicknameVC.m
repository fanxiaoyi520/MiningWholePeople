//
//  JJNicknameVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/9.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJNicknameVC.h"

@interface JJNicknameModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *nikeName;
@end

@implementation JJNicknameModel
@end

@interface JJNicknameVC ()

@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)JJNicknameModel *nicknameModel;
@end

@implementation JJNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = GCLocalizedString(@"昵称");
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setValue:@"" forKey:@"nikeName"];
    
    [self init_UI];
}

- (void)init_UI
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15.5, mcStatusBarHeight+mcNavBarHeight+30, ScreenWidth-31, 13.5+18*2)];
    [self.view addSubview:textField];
    textField.placeholder = GCLocalizedString(@"请设置您的用户昵称");
    [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    textField.tag = 100;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    lineView.backgroundColor = UICOLOR_RGB_SAME(243);
    lineView.frame = CGRectMake(14.5, textField.bottom, ScreenWidth-29, 1);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15,lineView.bottom+19,221,13);
    label.textColor = UICOLOR_RGB(56, 104, 199, 1);
    label.font = label_font_PingFang_SC(13);
    [self.view addSubview:label];
    label.text = GCLocalizedString(@"4-10个字符、支持数字、字母、中文");
    
    UIButton *preservationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preservationBtn addTarget:self action:@selector(preservationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    preservationBtn.frame = CGRectMake(14.5,label.bottom+20,ScreenWidth-29,50.5);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,preservationBtn.size.width,preservationBtn.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:63/255.0 green:181/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:7/255.0 green:109/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [preservationBtn.layer addSublayer:gl];
    [self.view addSubview:preservationBtn];
    preservationBtn.layer.cornerRadius = 5;
    
    UILabel *btnLab = [UILabel new];
    [preservationBtn addSubview:btnLab];
    btnLab.textColor = UICOLOR_RGB_SAME(255);
    btnLab.font = label_font_PingFang_SC(15);
    btnLab.frame = CGRectMake(0, 18, preservationBtn.size.width, 14);
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = GCLocalizedString(@"保存");
}

#pragma mark - actions
- (void)preservationBtnAction:(UIButton *)sender
{
    JJNicknameModel *model = [JJNicknameModel mj_objectWithKeyValues:self.mutableDic];
    self.nicknameModel = model;
    if ([model.nikeName isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"昵称不能为空") target:nil];
        return;
    }
    [self networking_set_user_nickname];
}

- (void)textFieldAction:(UITextField *)textField
{
    [self.mutableDic setValue:textField.text forKey:@"nikeName"];
}

#pragma mark - networking
- (void)networking_set_user_nickname
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *nickname = [NSString stringWithFormat:@"%@",self.nicknameModel.nikeName];
    NSDictionary *params = @{@"nickname":nickname};
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,SET_USER_NICKNAME] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            if (self.resetNicknameBlock) {
                self.resetNicknameBlock(nickname,[responseObject objectForKey:@"msg"]);
                [self.navigationController popViewControllerAnimated:YES];
            }
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
