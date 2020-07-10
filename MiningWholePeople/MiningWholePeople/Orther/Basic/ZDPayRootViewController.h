//
//  ZDPayRootViewController.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDNaviBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPayRootViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic ,assign)CGFloat leftMargin;
@property (nonatomic ,assign)CGFloat buttonWidth;
@property (nonatomic ,assign)NSInteger titleArrayCount;
@property (nonatomic ,assign)NSInteger btnTag;
@property (nonatomic ,strong)UIActivityIndicatorView *activityIndicator;
#pragma mark - 自定义导航条相关
@property(nonatomic, assign)BOOL switchNavigationBarHidden;  // 标题
@property(nonatomic, copy)NSString *naviTitle;  // 标题
- (void)setNaviTitleColor:(UIColor *)color;
- (void)setBackBtnImage:(NSString *)imageStr;
/** 导航条 */
@property(nonatomic, strong)ZDNaviBarView *topNavBar;
/** 内容视图 */
@property (strong, nonatomic) UIView *containerView;

- (void)showMessage:(NSString *)msg target:(id __nullable)target;
/**
没有数据默认界面提示
*/
- (void)noDataDefaultInterfacePrompt:(NSString *_Nullable)text;
@end

NS_ASSUME_NONNULL_END
