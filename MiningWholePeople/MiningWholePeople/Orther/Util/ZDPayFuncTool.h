//
//  ZDPayFuncTool.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//


#define ZDScreen_Width ([UIScreen mainScreen].bounds.size.width)
#define ZDScreen_Height ([UIScreen mainScreen].bounds.size.height)

#define mc_Is_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define mc_Is_iphoneX ZDScreen_Width >=375.0f && ZDScreen_Height >=812.0f&& mc_Is_iphone
    
/*状态栏高度*/
//#define mcStatusBarHeight (CGFloat)(mc_Is_iphoneX?(44.0):(20.0))
#define mcStatusBarHeight 20
/*导航栏高度*/
#define mcNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define mcNavBarAndStatusBarHeight (CGFloat)(mc_Is_iphoneX?(88.0):(64.0))
#define DEFAULT_IMAGE [UIImage imageNamed:@"alipay-hk"]

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44.f
#define NavHeight (StatusBarHeight + NavBarHeight)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define REImageName(imageName) [UIImage imageNamed:imageName]
#define TagBackBtn 5555;
//#define ZD_Fout_Medium(x) [UIFont fontWithName:@"PingFangSC-Medium" size:x]
#define ZD_Fout_Medium(x) [UIFont systemFontOfSize:x]
#define ZD_Fout_Regular(x) [UIFont fontWithName:@"PingFangSC-Regular" size:x]
#define ZD_Fount_System(x) [UIFont systemFontOfSize:x]
//默认图片
#define PlaceholderImage [UIImage imageNamed:@""]
#define PlaceholderHead_Image [UIImage imageNamed:@"re_default_head"]
#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define ratioH(H)   H
#define ratioW(W)   W
#define SETUPPAYMENTFEED @"Set up payment feed"
#define BINDBANKCARDSUCCEEDED @"Bind bank card succeeded"

#import <Foundation/Foundation.h>
#import "EncryptAndDecryptTool.h"
#import "CountDown.h"
#import "UIView+Frame.h"
#import "UIView+Toast.h"
#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "NNValidationCodeView.h"

#import "AppDelegate.h"
#import "JJMainTabBarVC.h"
#import "JJLoginVC.h"


NS_ASSUME_NONNULL_BEGIN
//域名
FOUNDATION_EXPORT NSString *_Nullable const DOMAINNAME;//域名
//FOUNDATION_EXPORT NSString * _Nullable DOMAINNAME(NSString * _Nullable urlStr);//域名


//接口
FOUNDATION_EXPORT NSString * _Nullable const INDEX;//首页接口
FOUNDATION_EXPORT NSString * _Nullable const LOGIN;//登陆接口- 登陆接口
FOUNDATION_EXPORT NSString * _Nullable const REGISTER;//注册接口
FOUNDATION_EXPORT NSString * _Nullable const GET_REGISTER_CODE;//注册验证码接口
FOUNDATION_EXPORT NSString * _Nullable const FORGET_GET_CODE;//忘记密码-获取验证码接口
FOUNDATION_EXPORT NSString * _Nullable const FORGET;//重置密码

//我的
FOUNDATION_EXPORT NSString * _Nullable const GET_FILE;//七牛云图片上传(文件上传)
FOUNDATION_EXPORT NSString * _Nullable const CERTIFICATION;//实名认证（提交）
FOUNDATION_EXPORT NSString * _Nullable const GET_USER_CERTIFICATION;//获取实名认证信息
FOUNDATION_EXPORT NSString * _Nullable const GET_USER_INFO;//用户信息接口
FOUNDATION_EXPORT NSString * _Nullable const SET_USER_NICKNAME;//设置昵称
FOUNDATION_EXPORT NSString * _Nullable const SET_USER_AVATAR;//设置头像
FOUNDATION_EXPORT NSString * _Nullable const SET_PAY_PWD;//修改支付密码
FOUNDATION_EXPORT NSString * _Nullable const SET_PWD;//修改登陆密码
FOUNDATION_EXPORT NSString * _Nullable const PUT_ORDER;//联系客服
FOUNDATION_EXPORT NSString * _Nullable const USER_REFERRAL;//推广码



FOUNDATION_EXPORT UIColor * _Nullable COLORWITHHEXSTRING(NSString * _Nullable hexString,CGFloat alpha);


@interface ZDPayFuncTool : NSObject
#pragma mark - 定时器相关

#pragma mark - public method
//获取字符串宽高-------推荐
+ (CGRect)getStringWidthAndHeightWithStr:(NSString *)str withFont:(UIFont *)font;
//获取字符串的宽度
+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;
//获得字符串的高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
//保留小数点位数
+(NSString *)getRoundFloat:(double)number withPrecisionNum:(NSInteger)position;
//设置不同字体颜色和大小
+(void)LabelAttributedString:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor * __nullable)vaColor;
//切圆角
+ (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner borderColor:(UIColor *__nullable)borderColor cutCornerRadii:(CGSize)radiiSize borderWidth:(CGFloat)borderWidth viewColor:(UIColor *__nullable)viewColor;
//修改UIImage的大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
/**
    金额分转元
 */
+ (NSString *)formatToTwoDecimal:(id)count;
/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString;
+ (void)setBtn:(UIButton *)btn Title:(NSString *)btnTitle btnImage:(NSString *)imageStr;
+ (void)setAttributeStringForPriceLabel:(UILabel *)label text:(NSString *)text;
+ (NSString*)getPreferredLanguage;
+ (void)getLoginSwitch;
+ (void)getLogin;
//个人中心---我的数组
+ (NSArray *)userTitleArray;
+ (NSArray *)userImageArray;
//判断字符串是否包含数字
+ (BOOL)isStringContainNumberWith:(NSString *)str;
//判断字符串中是否包含英文字母
+ (BOOL)isStringContainCharWith:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
