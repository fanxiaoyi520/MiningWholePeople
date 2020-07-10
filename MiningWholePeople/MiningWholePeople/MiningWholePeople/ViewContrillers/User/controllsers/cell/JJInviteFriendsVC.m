//
//  JJInviteFriendsVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/10.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJInviteFriendsVC.h"
@interface JJInviteFriendsModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *msg;
@property (nonatomic ,copy)NSString *data;
@property (nonatomic ,copy)NSString *link;
@end

@implementation JJInviteFriendsModel
@end

@interface JJInviteFriendsVC ()

@property (nonatomic ,strong)JJInviteFriendsModel *inviteFriendsModel;
@property (nonatomic ,strong)UIImageView *QRImageView;
@end

@implementation JJInviteFriendsVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self networking_set_pay_pwd];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self init_UI];
}

- (void)init_UI
{
    UIImageView *backImageView = [UIImageView new];
    backImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:backImageView];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourcePath = [bundle resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"图层 14"];
    backImageView.image = [UIImage imageWithContentsOfFile:filePath];
    backImageView.userInteractionEnabled = YES;
    
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = UICOLOR_RGB_SAME(255);
    backView.layer.cornerRadius = 5;
    backView.frame = CGRectMake(13, 285, ScreenWidth - 26, ScreenHeight-285);

    CGRect titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"你的好友邀请你一起加入矿工家族") withFont:label_font_PingFang_SC(13)];
    UILabel *titleLab = [UILabel new];
    [backView addSubview:titleLab];
    titleLab.textColor = UICOLOR_RGB_SAME(3);
    titleLab.font = label_font_PingFang_SC(13);
    titleLab.numberOfLines = 0;
    titleLab.frame = CGRectMake((backView.size.width-titleRect.size.width)/2, 17.5, titleRect.size.width, 13);
    titleLab.text = GCLocalizedString(@"你的好友邀请你一起加入矿工家族");
    
    UIImageView *QRImageView = [UIImageView new];
    QRImageView.frame = CGRectMake((backView.size.width-128)/2, titleLab.bottom+11.5, 128, 128);
    [backView addSubview:QRImageView];
    self.QRImageView = QRImageView;
}

#pragma mark - networking
- (void)networking_set_pay_pwd
{
    [MBProgressHUD showHUDAddedTo:self.QRImageView animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,USER_REFERRAL] parameters:nil successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.QRImageView animated:YES];
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            JJInviteFriendsModel *model = [JJInviteFriendsModel mj_objectWithKeyValues:responseObject];
            self.inviteFriendsModel = model;
            self.QRImageView.image = [UIImage generateQRCodeWithString:model.data Size:100];
        } else {
            [self showMessage:[responseObject objectForKey:@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.QRImageView animated:YES];
        if (error) {
            NSString *responseData = error.userInfo[NSLocalizedDescriptionKey];
            [self showMessage:responseData target:nil];
        }
    }];
}
@end
