//
//  JJUserVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/3.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJUserVC.h"
#import "JJMyTeamVC.h"
#import "JJRealNameAuthVC.h"
#import "JJUserSetUpVC.h"
#import "JJPersonalInfoVC.h"
#import "JJSecurityCenterVC.h"
#import "JJContactCustomerVC.h"
#import "JJInviteFriendsVC.h"

#import "JJUserModel.h"
@interface JJUserCell:UITableViewCell

@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UIImageView *headerImageView;
@property (nonatomic ,strong)UILabel *titleLab;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UIImageView *navImageView;

- (void)layoutViewAndLondingData:(NSString *)model withImageModel:(NSString *)imageStr withMyIndexPath:(NSIndexPath *)myIndexPath;
@end

@implementation JJUserCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self init_UI];
    }
    return self;
}

- (void)init_UI
{
    UIView *backView = [UIView new];
    [self.contentView addSubview:backView];
    self.backView = backView;
    self.backView.backgroundColor = UICOLOR_RGB_SAME(255);
    
    UIImageView *headerImageView = [UIImageView new];
    [self.backView addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    UILabel *titleLab = [UILabel new];
    [self.backView addSubview:titleLab];
    titleLab.textColor = UICOLOR_RGB_SAME(0);
    titleLab.font = label_font_PingFang_SC(13);
    self.titleLab = titleLab;
    
    UIView *lineView = [UIView new];
    [self.backView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = UICOLOR_RGB_SAME(245);
    
    UIImageView *navImageView = [UIImageView new];
    [backView addSubview:navImageView];
    self.navImageView = navImageView;
}

- (void)layoutViewAndLondingData:(NSString *)model withImageModel:(NSString *)imageStr withMyIndexPath:(NSIndexPath *)myIndexPath
{
    self.backView.frame = CGRectMake(14, 0, ScreenWidth-28, 49);

    self.headerImageView.image = [UIImage imageNamed:imageStr];
    self.headerImageView.frame = CGRectMake(17, 15, self.headerImageView.image.size.width, self.headerImageView.image.size.height);
    
    CGRect titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model withFont:label_font_PingFang_SC(13)];
    self.titleLab.frame = CGRectMake(self.headerImageView.right+15.5, 18, titleRect.size.width, 13);
    self.titleLab.text = model;
    
    self.lineView.frame = CGRectMake(18, 48, self.backView.size.width-36, 1);
    if (myIndexPath.row == 6) self.lineView.hidden = YES;
    
    self.navImageView.frame = CGRectMake(self.backView.width-6-18, 20, 6, 11.5);
    self.navImageView.image = [UIImage imageNamed:@"fangxiang"];
}

@end

@interface JJUserHeaderView:UITableViewHeaderFooterView

@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UIImageView *headerImageView;
@property (nonatomic ,strong)UILabel *nameLab;
@property (nonatomic ,strong)UILabel *UIDLab;
@property (nonatomic ,strong)UILabel *gradeLab;
@property (nonatomic ,strong)UIImageView *navImageView;

- (void)layoutViewAndLondingData:(id)model;
@end

@implementation JJUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self init_UI];
    }
    return self;
}

- (void)init_UI
{
    UIView *backView = [UIView new];
    [self.contentView addSubview:backView];
    backView.frame = CGRectMake(14, 0, ScreenWidth-28, 101);
    self.backView = backView;
    backView.backgroundColor = UICOLOR_RGB_SAME(255);
    backView.layer.cornerRadius = 5;
    
    UIImageView *headerImageView = [UIImageView new];
    [backView addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    UILabel *nameLab = [UILabel new];
    [backView addSubview:nameLab];
    nameLab.textColor = UICOLOR_RGB_SAME(13);
    nameLab.font = label_font_PingFang_SC(16.5);
    self.nameLab = nameLab;
    
    UILabel *UIDLab = [UILabel new];
    [backView addSubview:UIDLab];
    UIDLab.textColor = UICOLOR_RGB_SAME(92);
    UIDLab.font = label_font_PingFang_SC(11.5);
    self.UIDLab = UIDLab;
    
    UILabel *gradeLab = [UILabel new];
    [backView addSubview:gradeLab];
    gradeLab.textColor = UICOLOR_RGB_SAME(92);
    gradeLab.font = label_font_PingFang_SC(11.5);
    self.gradeLab = gradeLab;
    
    UIImageView *navImageView = [UIImageView new];
    [backView addSubview:navImageView];
    self.navImageView = navImageView;
}

- (void)layoutViewAndLondingData:(id)model
{
    JJUserModel *userModel = model;
    if (!userModel) return;
    
    self.headerImageView.frame = CGRectMake(12.5, 20.5, 61, 61);
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar] placeholderImage:[UIImage imageNamed:@"e9978955638ca71877822b0c4d23913c"]];
    
    self.nameLab.frame = CGRectMake(self.headerImageView.right+17, 23, 100, 12.5);
    self.nameLab.text = userModel.mobile;
    
    self.UIDLab.frame = CGRectMake(self.headerImageView.right+17, self.nameLab.bottom+16, 100, 9);
    self.UIDLab.text = [NSString stringWithFormat:@"UID:%@",userModel.uid];
    
    self.gradeLab.frame = CGRectMake(self.headerImageView.right+17, self.UIDLab.bottom+11.5, 100, 11);
    self.gradeLab.text = [NSString stringWithFormat:@"%@:%@",GCLocalizedString(@"等级"),userModel.level_name];
    
    self.navImageView.frame = CGRectMake(self.backView.width-6-18, 45, 6, 11.5);
    self.navImageView.image = [UIImage imageNamed:@"fangxiang"];
}
@end

@interface JJUserVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *userTableView;
@property (nonatomic ,strong)NSArray *userArray;
@property (nonatomic ,strong)NSArray *userImageArray;
@property (nonatomic ,strong)JJUserModel *userModel;
@property (nonatomic ,strong)JJUserHeaderView *headerView;

@end

@implementation JJUserVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self networking_get_user_info];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self init_UI];
}

- (void)init_UI
{
    self.naviTitle = GCLocalizedString(@"我的");
    self.topNavBar.backBtn.hidden = YES;
    self.topNavBar.backgroundColor = UICOLOR_RGB_SAME(245);
    self.userArray = [ZDPayFuncTool userTitleArray];
    self.userImageArray = [ZDPayFuncTool userImageArray];
    
    [self userTableView];
}

#pragma mark - lazy loading
- (UITableView *)userTableView
{
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, mcStatusBarHeight+mcNavBarHeight, ScreenWidth, ScreenHeight-mcStatusBarHeight-mcNavBarHeight) style:UITableViewStylePlain];
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.bounces = NO;
        _userTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _userTableView.backgroundView = nil;
        _userTableView.backgroundColor = UICOLOR_RGB_SAME(245);
        [self.view addSubview:_userTableView];
        
        JJUserHeaderView *headerView = [[JJUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 101+15.5)];
        headerView.layer.cornerRadius = 5;
        _userTableView.tableHeaderView = headerView;
        self.headerView = headerView;
        headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTapAction:)];
        [headerView addGestureRecognizer:tap];
    }
    return _userTableView;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_id = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    JJUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[JJUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell layoutViewAndLondingData:self.userArray[indexPath.row] withImageModel:self.userImageArray[indexPath.row] withMyIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self.headerView layoutViewAndLondingData:self.userModel];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        JJMyTeamVC *vc = [JJMyTeamVC new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        JJRealNameAuthVC *vc = [JJRealNameAuthVC new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        JJSecurityCenterVC *vc = [JJSecurityCenterVC new];
        vc.model = self.userModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        JJInviteFriendsVC *vc = [JJInviteFriendsVC new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 5) {
        JJContactCustomerVC *vc = [JJContactCustomerVC new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 6) {
        JJUserSetUpVC *vc = [JJUserSetUpVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)headerViewTapAction:(UITapGestureRecognizer *)tap
{
    JJPersonalInfoVC *vc = [JJPersonalInfoVC new];
    vc.model = self.userModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - networking
- (void)networking_get_user_info
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypeGet urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GET_USER_INFO] parameters:nil successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            JJUserModel *model = [JJUserModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            self.userModel = model;
            [self.userTableView reloadData];
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
