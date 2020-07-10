//
//  MWPHeader.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/3.
//  Copyright © 2020 FANS. All rights reserved.
//

#ifndef MWPHeader_h
#define MWPHeader_h

#import "AFNetworkingManager.h"
#import "ZDPayFuncTool.h"
#import "ZDPayRootViewController.h"
#import "ZDPayRootModel.h"
#import "ZDNaviBarView.h"
#import <MBProgressHUD.h>
#import <IQKeyboardManager.h>
#import <SDWebImage/SDWebImage.h>
#import <MJRefresh/MJRefresh.h>
#import <TYAttributedLabel/TYAttributedLabel.h>
#import "UIView+BorderLine.h"
#import "UIButton+Wave.h"
#import "UILabel+Add.h"
#import <MJExtension/MJExtension.h>
#import "NSBundle+Language.h"
#import "Utilities.h"
#import <AFNetworking/AFNetworking.h>
#import "YQImageCompressTool.h"
#import "JJCustomView.h"
#import "ZZPhotoKit.h"
#import "UIImage+Tool.h"

//打印
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

//弱-强引用
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

//颜色
#define UICOLOR_HEX(hexString) [UIColor colorWithRed:((float)((hexString & 0xFF0000) >> 16))/255.0 green:((float)((hexString & 0xFF00) >> 8))/255.0 blue:((float)(hexString & 0xFF))/255.0 alpha:1.0]
#define UICOLOR_RGB(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define UICOLOR_RGB_SAME(A) [UIColor colorWithRed:A/255.0 green:A/255.0 blue:A/255.0 alpha:1.0]
#define UICOLOR_RANDOM  [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]

//字体
#define label_font_PingFang_SC(x) [UIFont fontWithName:@"PingFang SC" size: (x)]
#define label_font_Microsoft_YaHei(x) [UIFont fontWithName:@"Microsoft YaHei" size: (x)]

//系统
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define ABOVE_IOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

//目录宏
#define PATH_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_CACHE [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_DATABASE_CACHE [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//区分不同版本的文字宽度处理
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    #define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
        sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
    #define MB_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    #define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
        boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
        attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
    #define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
        sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#define Default_Image [UIImage imageNamed:@""]
#endif /* MWPHeader_h */
