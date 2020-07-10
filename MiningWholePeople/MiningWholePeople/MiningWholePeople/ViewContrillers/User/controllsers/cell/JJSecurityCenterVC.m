//
//  JJSecurityCenterVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJSecurityCenterVC.h"
#import "JJFundPasswordVC.h"
#import "JJLoginPasswordVC.h"

@interface JJSecurityCenterCell : UITableViewCell

@property (nonatomic ,strong)UILabel *titleLab;
@property (nonatomic ,strong)UILabel *contentLab;
@property (nonatomic ,strong)UIImageView *directionImageView;
@property (nonatomic ,strong)UIView *lineView;

- (void)layoutViewAndLondingData:(NSString *)model withMyIndexPath:(NSIndexPath *)myIndexPath;
@end
@implementation JJSecurityCenterCell
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
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    titleLab.textColor = UICOLOR_RGB_SAME(0);
    titleLab.font = label_font_PingFang_SC(13);

    UILabel *contentLab = [UILabel new];
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    contentLab.textColor = UICOLOR_RGB_SAME(0);
    contentLab.font = label_font_PingFang_SC(13);
    
    UIImageView * directionImageView = [UIImageView new];
    self.directionImageView = directionImageView;
    [self.contentView addSubview:directionImageView];

    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = UICOLOR_RGB_SAME(243);
}

- (void)layoutViewAndLondingData:(NSString *)model withMyIndexPath:(NSIndexPath *)myIndexPath
{
    NSDictionary *dic = (NSDictionary *)model;
    
    CGRect titleLabRect =[ZDPayFuncTool getStringWidthAndHeightWithStr:[dic objectForKey:@"title"] withFont:label_font_PingFang_SC(13)];
    self.titleLab.frame = CGRectMake(15.5, 19, titleLabRect.size.width, 13);
    self.titleLab.text = [dic objectForKey:@"title"];
    
    CGRect contentLabRect =[ZDPayFuncTool getStringWidthAndHeightWithStr:[dic objectForKey:@"headerContent"] withFont:label_font_PingFang_SC(13)];
        
    self.contentLab.frame = CGRectMake(ScreenWidth-contentLabRect.size.width-38.5, 19, contentLabRect.size.width, 13);
    self.contentLab.text = [dic objectForKey:@"headerContent"];
    
    if (myIndexPath.row != 2) {
        self.directionImageView.frame = CGRectMake(ScreenWidth-6-18, 19, 6, 11.5);
        self.directionImageView.image = [UIImage imageNamed:@"fangxiang"];
    }

    self.lineView.frame = CGRectMake(14, 48.5, ScreenWidth-28, 1);
}
@end

@interface JJSecurityCenterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *personalTableView;
@property (nonatomic ,strong)NSArray *personalArray;
@end

@implementation JJSecurityCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = GCLocalizedString(@"安全中心");
    self.personalArray = @[@{@"title":GCLocalizedString(@"资金密码"),@"headerContent":GCLocalizedString(@"设置"),},
                           @{@"title":GCLocalizedString(@"登陆密码"),@"headerContent":GCLocalizedString(@"修改")},
                           @{@"title":GCLocalizedString(@"手机"),@"headerContent":[NSString stringWithFormat:@"%@",self.model.mobile]}];
    [self init_UI];
}

- (void)init_UI
{
    [self personalTableView];
}

#pragma mark - lazy loading
- (UITableView *)personalTableView
{
    if (!_personalTableView) {
        _personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, mcStatusBarHeight+mcNavBarHeight, ScreenWidth, ScreenHeight-mcStatusBarHeight-mcNavBarHeight) style:UITableViewStylePlain];
        _personalTableView.delegate = self;
        _personalTableView.dataSource = self;
        _personalTableView.bounces = NO;
        _personalTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _personalTableView.backgroundView = nil;
        [self.view addSubview:_personalTableView];
    }
    return _personalTableView;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_id = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    JJSecurityCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[JJSecurityCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell layoutViewAndLondingData:self.personalArray[indexPath.row] withMyIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        JJFundPasswordVC *vc = [JJFundPasswordVC new];
        vc.fundPasswordBlock = ^(NSString * _Nonnull msg) {
            [self showMessage:msg target:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        JJLoginPasswordVC *vc = [JJLoginPasswordVC new];
        vc.loginPasswordBlock = ^(NSString * _Nonnull msg) {
            [self showMessage:msg target:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
