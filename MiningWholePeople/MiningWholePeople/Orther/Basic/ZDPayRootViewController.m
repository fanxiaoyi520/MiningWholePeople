//
//  ZDPayRootViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootViewController.h"
#import "EncryptAndDecryptTool.h"
#import "UIView+Toast.h"
#import "ZDPayFuncTool.h"
#import "JJHomeVC.h"
#import "JJTaskVC.h"
#import "JJAssetsVC.h"
#import "JJUserVC.h"

@interface ZDPayRootViewController ()


@end

@implementation ZDPayRootViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    if (self.navigationController.navigationBar.height == 0) {
        _topNavBar.alpha = 0;
    }
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
        forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.clipsToBounds = YES;
    // 将导航放到最顶部,不然后面有其它的层会被覆盖
    [self.view bringSubviewToFront:_topNavBar];
    
    if (![self isKindOfClass:[JJHomeVC class]] && ![self isKindOfClass:[JJTaskVC class]] && ![self isKindOfClass:[JJAssetsVC class]] && ![self isKindOfClass:[JJUserVC class]]) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (![self isKindOfClass:[JJHomeVC class]] && ![self isKindOfClass:[JJTaskVC class]] && ![self isKindOfClass:[JJAssetsVC class]] && ![self isKindOfClass:[JJUserVC class]]) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self activityIndicator];
    self.activityIndicator.layer.zPosition = 10;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    // 所有界面隐藏导航栏,用自定义的导航栏代替
    // drawUI
    [self drawTopNaviBar];
    if (self.switchNavigationBarHidden == NO) {
        self.topNavBar.hidden = NO;
    } else {
        self.topNavBar.hidden = YES;
    }
}

#pragma mark - 自定义导航栏
- (void)drawTopNaviBar {

    if (_topNavBar) {
        [_topNavBar removeFromSuperview];
    }
    // 添加自定义的导航条
    ZDNaviBarView *naviBar = [[ZDNaviBarView alloc] initWithController:self];
    [self.view addSubview:naviBar];
    self.topNavBar = naviBar;
    //返回点击事件
    @WeakObj(self);
    naviBar.backBlock = ^{
        @StrongObj(self)
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    if ([self isKindOfClass:[ZDPayRootViewController class]]) {
        [_topNavBar addBackBtn];
    }
}

- (void)setNaviTitle:(NSString *)naviTitle{
    if ([self isKindOfClass:[ZDPayRootViewController class]]) {
        [_topNavBar addBackBtn];
        [_topNavBar setNavigationTitle:naviTitle];
        // 添加底部分割线 - 如果不需要添加,这里处理即可
        //[_topNavBar addBottomSepLine];
    }
}

- (void)setNaviTitleColor:(UIColor *)color {
    if ([self isKindOfClass:[ZDPayRootViewController class]]) {
        [_topNavBar setNavigationTitleColor:color];
    }
}

- (void)setBackBtnImage:(NSString *)imageStr {
    [_topNavBar setBackBtnImage:imageStr];
}

/**
 没有数据默认界面提示
 */
- (void)noDataDefaultInterfacePrompt:(NSString *_Nullable)text {
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = ZD_Fout_Regular(16);
    NSString *str = text;
    textLabel.text = str;
    textLabel.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(ScreenWidth-40, 9999);
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    if (expectSize.width<ScreenWidth) {
        expectSize.width = ScreenWidth - 40;
    }
    textLabel.frame = CGRectMake(20, mcNavBarAndStatusBarHeight+100, expectSize.width, expectSize.height);
    
    if (text) {
        [self.view addSubview:textLabel];
    }
}

#pragma mark - 隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    //BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - 简单弹出视图
/** 简单弹窗功能 */
- (void)showMessage:(NSString *)msg target:(id __nullable)target{
    [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter
                   title:nil image:nil style:nil completion:nil];
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [self.view addSubview:_activityIndicator];
        _activityIndicator.frame= CGRectMake((ScreenWidth-100)/2, (ScreenHeight-100)/2, 100, 100);
        _activityIndicator.color = [UIColor grayColor];
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
