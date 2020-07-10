//
//  ZDNaviBarView.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BackBlock)(void);
typedef void (^BankJumpBlock)(UIButton *sender);
@interface ZDNaviBarView : UIView

@property (strong, nonatomic) UIView *statusBar;    // 状态栏
@property (strong, nonatomic) UIView *navigationBar;    // 导航条
@property (strong, nonatomic) UIButton *rightWishBtn;   // 右侧分享按钮
@property (strong, nonatomic) UIButton *leftMenuBtn;    // 左侧菜单栏
@property (strong, nonatomic) UIButton *backBtn;    // 返回按钮
@property (strong, nonatomic) UILabel *titleLabel;  // 标题
@property(nonatomic, strong)UIView *lineView;   // 底部分割线

@property (nonatomic, copy) BackBlock backBlock;
@property (nonatomic, copy) BankJumpBlock bankJumpBlock;

- (instancetype)initWithController:(UIViewController *)controller;

// 添加返回按钮
- (void)addBackBtn;
- (void)setBackBtnImage:(NSString *)imageStr;
//添加银行卡按钮
- (void)addBankCardBTnTitle:(NSString *__nullable)title
                   btnImage:(NSString *__nullable)imageStr
              BankJumpBlock:(void (^)(UIButton *sender))bankJumpBlock;
// 设置标题
- (void)setNavigationTitle:(NSString *)title;
- (void)setNavigationTitleColor:(UIColor *)color;
// 设置导航条透明
- (void)clearNavBarBackgroundColor;
// 设置导航条透明
- (void)changeBackImage:(NSString *)imageStr;
- (void)setNavAndStatusBarColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
