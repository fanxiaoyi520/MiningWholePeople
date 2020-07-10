//
//  JJUserSetUpVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJUserSetUpVC.h"

@interface CacheTools : NSObject
/*
 *  获取path路径下文件夹的大小
 *  @param path 要获取的文件夹 路径
 *  @return 返回path路径下文件夹的大小
 */
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;
/**
 *  清除path路径下文件夹的缓存
 *  @param path  要清除缓存的文件夹 路径
 *
 */
+ (void)clearCacheWithFilePath:(NSString *)path;
@end

@implementation CacheTools
#pragma mark - 获取path路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path{
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}

#pragma mark - 清除path文件夹下缓存大小
+ (void)clearCacheWithFilePath:(NSString *)path{
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    return;
}
@end

@interface JJUserSetUpVC ()

@property (nonatomic ,strong)UIButton *clearCacheBtn;
@end

@implementation JJUserSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topNavBar.backBlock = ^{
        [ZDPayFuncTool getLoginSwitch];
    };

    [self init_UI];
}

- (void)init_UI
{
    self.naviTitle = GCLocalizedString(@"设置");
    UIImageView *headerView = [UIImageView new];
    headerView.frame = CGRectMake((ScreenWidth-55)/2, 125, 55, 55);
    [self.view addSubview:headerView];
    headerView.image = [UIImage imageNamed:@"tuceng_22"];
    
    UILabel *titleLab = [UILabel new];
    titleLab.textColor = UICOLOR_RGB_SAME(0);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = label_font_PingFang_SC(13);
    [self.view addSubview:titleLab];
    titleLab.text = GCLocalizedString(@"矿工家族");
    titleLab.frame = CGRectMake(0, headerView.bottom+7.5, ScreenWidth, 15);
    
    NSArray *clickArray = @[GCLocalizedString(@"语言选择"),GCLocalizedString(@"清除缓存")];
    [clickArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:clickBtn];
        clickBtn.tag = 100+i;
        clickBtn.frame = CGRectMake(0, titleLab.bottom+42+i*(53), ScreenWidth, 53);
        if (i==0) {
            [clickBtn addTarget:self action:@selector(languageSwitchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        CGRect btnLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:clickArray[i] withFont:label_font_PingFang_SC(13)];
        UILabel *btnLab = [UILabel new];
        btnLab.text = clickArray[i];
        [clickBtn addSubview:btnLab];
        btnLab.textColor = UICOLOR_RGB_SAME(0);
        btnLab.font = label_font_PingFang_SC(13);
        btnLab.frame = CGRectMake(14, 20, btnLabRect.size.width, 13);
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UICOLOR_RGB_SAME(243);
        [self.view addSubview:lineView];
        lineView.frame = CGRectMake(14, titleLab.bottom+95+i*(1+51), ScreenWidth-28, 1);
        
        UIImageView *fangxiangImageView = [UIImageView new];
        [clickBtn addSubview:fangxiangImageView];
        fangxiangImageView.image = [UIImage imageNamed:@"方向"];
        fangxiangImageView.frame = CGRectMake(ScreenWidth-6-18, 20, 6, 11.5);
        
    }];
    
    CGRect languageSwitchRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:GCLocalizedString(@"中文简体") withFont:label_font_PingFang_SC(13)];
    UIButton *languageSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:languageSwitchBtn];
    [ZDPayFuncTool setBtn:languageSwitchBtn Title:GCLocalizedString(@"中文简体") btnImage:@""];
    [languageSwitchBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
    languageSwitchBtn.titleLabel.font = label_font_PingFang_SC(13);
    languageSwitchBtn.frame = CGRectMake((ScreenWidth-languageSwitchRect.size.width-20-20), titleLab.bottom+61.5, languageSwitchRect.size.width+20, 12.5);
    languageSwitchBtn.userInteractionEnabled = NO;
    
    CGRect clearCacheBtnRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[self getCacheSize] withFont:label_font_PingFang_SC(13)];
    UIButton *clearCacheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:clearCacheBtn];
    [ZDPayFuncTool setBtn:clearCacheBtn Title:[self getCacheSize] btnImage:@""];
    [clearCacheBtn setTitleColor:UICOLOR_RGB(6, 101, 235, 1) forState:UIControlStateNormal];
    clearCacheBtn.titleLabel.font = label_font_PingFang_SC(13);
    clearCacheBtn.frame = CGRectMake((ScreenWidth-clearCacheBtnRect.size.width-20-20), titleLab.bottom+61.5+41+13, clearCacheBtnRect.size.width+20, 12.5);
    clearCacheBtn.userInteractionEnabled = NO;
    self.clearCacheBtn = clearCacheBtn;
    
    UIButton *exitLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitLoginBtn addTarget:self action:@selector(exitLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    exitLoginBtn.frame = CGRectMake(14.5,ScreenHeight-50.5-21,ScreenWidth-29,50.5);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,exitLoginBtn.size.width,exitLoginBtn.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:63/255.0 green:181/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:7/255.0 green:109/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [exitLoginBtn.layer addSublayer:gl];
    [self.view addSubview:exitLoginBtn];
    exitLoginBtn.layer.cornerRadius = 5;
    
    UILabel *btnLab = [UILabel new];
    [exitLoginBtn addSubview:btnLab];
    btnLab.textColor = UICOLOR_RGB_SAME(255);
    btnLab.font = label_font_PingFang_SC(15);
    btnLab.frame = CGRectMake(0, 18, exitLoginBtn.size.width, 14);
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = GCLocalizedString(@"退出登录");
}

#pragma mark - updateLabel
- (void)updateLabel {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.view addSubview:self.topNavBar];
    [self init_UI];
}

#pragma mark - actions
- (void)exitLoginBtnAction:(UIButton *)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:GCLocalizedString(@"提示")
                                                                   message:GCLocalizedString(@"此操作将退出当前账户,是否继续？")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:GCLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:GCLocalizedString(@"确认") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                            NSLog(@"action = %@", action);
                                                            
                                                            UserInfo *user = [[UserInfoContext sharedUserInfoContext] getUserInfo];
                                                            user.isLogin = NO;
                                                            user.phoneNumber = @"";
                                                            user.tabBarSelected = 0;
                                                            user.token = @"";
                                                            [Utilities SetNSUserDefaults:user];
                                                            [ZDPayFuncTool getLogin];
                                                          }];

    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clickBtnAction:(UIButton *)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:GCLocalizedString(@"提示")
                                                                   message:GCLocalizedString(@"此操作将清除缓存,是否继续？")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:GCLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:GCLocalizedString(@"确认") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                            NSLog(@"action = %@", action);
                                                            [self clearCache];
                                                          }];

    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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

#pragma mark - 计算缓冲大小，清理缓冲
// 计算缓冲大小
- (NSString *)getCacheSize {
    // 获取缓冲文件的沙盒路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"cachePath路径:%@", cachePath);
    // 1. 获取缓冲的大小
    NSString *cacheSize = [CacheTools getCacheSizeWithFilePath:cachePath];
    if ([cacheSize isEqualToString:@"0.00B"]) {
        cacheSize = @"0.00B";
    }
    NSLog(@"%@",cacheSize);
    return cacheSize;
}
// 清理缓冲
- (void)clearCache {
    // 获取缓冲文件的沙盒路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"有数据的情况下开始清理数据");
    dispatch_async(dispatch_get_main_queue(), ^{
        // 清除缓冲,进行缓冲操作
        [CacheTools clearCacheWithFilePath:cachePath];
        // 缓冲操作完成
        // 结束动画
        NSLog(@"清理数据完成");
        [self.clearCacheBtn setTitle:[self getCacheSize] forState:UIControlStateNormal];
    });
}
@end
