//
//  JJHomeVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/3.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJHomeVC.h"

@interface JJHomeVC ()

@end

@implementation JJHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topNavBar.backBtn.hidden = YES;
    [self init_UI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLabel];
}

- (void)init_UI
{
    UIImageView *backImageView = [UIImageView new];
    [self.view addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"矩形 1"];
    backImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UIImageView *contentImageView = [UIImageView new];
    [self.view addSubview:contentImageView];
    contentImageView.userInteractionEnabled = YES;
    contentImageView.image = [UIImage imageNamed:@"97S58PICw18Am9f58PICs0nfY_PIC2018"];
    contentImageView.frame = CGRectMake((ScreenWidth-263.5)/2, 194, 263.5, (263.5*contentImageView.image.size.height)/contentImageView.image.size.width);
    

    CGRect assetsRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"资产:0.00 FTI" withFont:label_font_PingFang_SC(11.5)];
    UILabel *assetsLabel = [[UILabel alloc] init];
    assetsLabel.frame = CGRectMake(20.5,54,assetsRect.size.width+49.5,32);
    [self.view addSubview:assetsLabel];
    assetsLabel.text = @"资产:0.00 FTI";
    assetsLabel.textColor = UICOLOR_RGB_SAME(14);
    assetsLabel.font = label_font_PingFang_SC(11.5);
    assetsLabel.layer.cornerRadius = 16;
    assetsLabel.backgroundColor = UICOLOR_RGB(215, 228, 254, 1.0);
    assetsLabel.layer.masksToBounds = YES;
    [ZDPayFuncTool setAttributeStringForPriceLabel:assetsLabel text:@"资产:0.00 FTI"];
    
    UIImageView *headerView = [UIImageView new];
    [self.view addSubview:headerView];
    headerView.image = [UIImage imageNamed:@"椭圆 1"];
    headerView.frame = CGRectMake(14.5, 50, 40.5, 40.5);

    UILabel *gradeLabel = [[UILabel alloc] init];
    gradeLabel.frame = CGRectMake(13,78.5,43,12);
    gradeLabel.layer.cornerRadius = 6;
    [self.view addSubview:gradeLabel];
    gradeLabel.text = @"一星矿工";
    gradeLabel.textColor = UICOLOR_RGB_SAME(255);
    gradeLabel.font = label_font_PingFang_SC(6.5);
    gradeLabel.textAlignment = NSTextAlignmentCenter;
    gradeLabel.layer.backgroundColor = UICOLOR_RGB(46, 198, 211, 1).CGColor;
    gradeLabel.layer.cornerRadius = 6;
    
    UIButton *speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:speakBtn];
    [speakBtn setImage:[UIImage imageNamed:@"speak__1"] forState:UIControlStateNormal];
    speakBtn.frame = CGRectMake(headerView.left, gradeLabel.bottom+19.5, 40.5, 40.5);
    
    NSArray *funcsBtnArray = @[GCLocalizedString(@"升级矿机"),GCLocalizedString(@"邀请好友"),GCLocalizedString(@"新手教程")];
    NSArray *funcsImageArray = @[@"矿车不居中",@"邀请",@"笔记"];
    [funcsBtnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        
        UIButton *funcsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:funcsBtn];
        funcsBtn.frame = CGRectMake(ScreenWidth - 15 - 40.5-5, 49.5+i*(61.5+17), 40.5+10, 61.5);
        
        UIImageView *funcImageView = [UIImageView new];
        [funcsBtn addSubview:funcImageView];
        funcImageView.frame = CGRectMake(5, 0, funcsBtn.size.width-10, funcsBtn.size.width-10);
        funcImageView.image = [UIImage imageNamed:funcsImageArray[i]];
        
        CGRect funcLabelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:funcsBtnArray[i] withFont:label_font_PingFang_SC(11)];
        UILabel *funcLabel = [[UILabel alloc] init];
        funcLabel.frame = CGRectMake(ScreenWidth-funcLabelRect.size.width-12,100+i*(11+67.5),funcLabelRect.size.width,11);
        [self.view addSubview:funcLabel];
        funcLabel.textAlignment = NSTextAlignmentCenter;
        funcLabel.font = label_font_PingFang_SC(11);
        funcLabel.textColor = UICOLOR_RGB_SAME(255);
        funcLabel.text = funcsBtnArray[i];
    }];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(14.5,ScreenHeight-self.tabBarController.tabBar.height-110.5-20,ScreenWidth-29,110.5);
    backView.backgroundColor = UICOLOR_RGB_SAME(255);
    [self.view addSubview:backView];
    backView.layer.cornerRadius = 5;
    backView.userInteractionEnabled = YES;
    
    NSArray *nameArray1 = @[GCLocalizedString(@"我的矿机"),GCLocalizedString(@"升级矿机")];
    NSArray *nameArray2 = @[GCLocalizedString(@"矿机数量"),GCLocalizedString(@"日总产量")];
    NSArray *nameArray3 = @[@"0台",@"0FTI"];
    CGRect nameLabel1Rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"我的矿机") withFont:label_font_PingFang_SC(15)];
    CGRect nameLabel2Rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"矿机数量") withFont:label_font_PingFang_SC(11)];
    [nameArray1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        CGRect nameLabel_1Rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:nameArray1[i] withFont:label_font_PingFang_SC(15)];
        UILabel *nameLabel1 = [[UILabel alloc] init];
        nameLabel1.frame = CGRectMake(15.5+i*(61.5+nameLabel1Rect.size.width),13.5,nameLabel_1Rect.size.width,15);
        [backView addSubview:nameLabel1];
        nameLabel1.textAlignment = NSTextAlignmentLeft;
        nameLabel1.font = label_font_PingFang_SC(15);
        nameLabel1.textColor = UICOLOR_RGB_SAME(14);
        nameLabel1.text = nameArray1[i];
        

        UILabel *nameLabel2 = [[UILabel alloc] init];
        nameLabel2.frame = CGRectMake(15.5+i*(61.5+nameLabel1Rect.size.width),nameLabel1.bottom+27.5,nameLabel2Rect.size.width,11);
        [backView addSubview:nameLabel2];
        nameLabel2.textAlignment = NSTextAlignmentLeft;
        nameLabel2.font = label_font_PingFang_SC(11);
        nameLabel2.textColor = UICOLOR_RGB_SAME(92);
        nameLabel2.text = nameArray2[i];
        
        UILabel *nameLabel3 = [[UILabel alloc] init];
        nameLabel3.frame = CGRectMake(15.5+i*(61.5+nameLabel1Rect.size.width),nameLabel2.bottom+9.5,nameLabel1Rect.size.width,11);
        [backView addSubview:nameLabel3];
        nameLabel3.textAlignment = NSTextAlignmentLeft;
        nameLabel3.font = label_font_PingFang_SC(15);
        nameLabel3.textColor = UICOLOR_RGB_SAME(13);
        nameLabel3.text = nameArray3[i];
        
        if (i==0) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0,40,ScreenWidth-100-29,0.5);
            lineView.backgroundColor = UICOLOR_RGB_SAME(244);
            [backView addSubview:lineView];
            
            UIButton *drawingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            drawingBtn.backgroundColor = UICOLOR_RGB(0, 99, 235, 1);
            [backView addSubview:drawingBtn];
            drawingBtn.frame = CGRectMake(backView.width-100, 0, 100, backView.height);
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:drawingBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = drawingBtn.bounds;
            maskLayer.path = maskPath.CGPath;
            drawingBtn.layer.mask = maskLayer;
            
            UIImageView *btnImage = [UIImageView new];
            [drawingBtn addSubview:btnImage];
            btnImage.frame = CGRectMake((drawingBtn.size.width-40.5)/2, 25.5, 40.5, 40.5);
            btnImage.userInteractionEnabled = YES;
            btnImage.image = [UIImage imageNamed:@"铲子"];
            
            CGRect drawingLabelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"一键收矿") withFont:label_font_PingFang_SC(11)];
            UILabel *drawingLabel = [[UILabel alloc] init];
            drawingLabel.frame = CGRectMake((drawingBtn.size.width-drawingLabelRect.size.width)/2, btnImage.bottom+10, drawingLabelRect.size.width, 11);
            [drawingBtn addSubview:drawingLabel];
            drawingLabel.textAlignment = NSTextAlignmentLeft;
            drawingLabel.font = label_font_PingFang_SC(11);
            drawingLabel.textColor = UICOLOR_RGB_SAME(255);
            drawingLabel.text = GCLocalizedString(@"一键收矿");
        }
    }];
}

#pragma mark - updateLabel
- (void)updateLabel {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self init_UI];
}

#pragma mark networking-index
- (void)networking_index
{
    NSDictionary *params = @{@"token":@""};
    [AFNetworkingManager requestWithType:SkyHttpRequestTypeGet urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,INDEX] parameters:params successBlock:^(id  _Nonnull responseObject) {
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

@end
