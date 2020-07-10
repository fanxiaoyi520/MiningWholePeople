//
//  UserInfo.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject<NSCoding,NSSecureCoding>{
    BOOL isLogin;//判断是否登录
    NSString *phoneNumber;//手机号
    NSString *cookie;//cookie
    NSInteger tabBarSelected;//tabbar
    NSString *deviceid;//设备号
    NSString *token;//设备号
    NSString *lang;
}

@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *cookie;
@property (nonatomic,assign) NSInteger tabBarSelected;
@property (nonatomic,copy) NSString *deviceid;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *lang;
@end

NS_ASSUME_NONNULL_END
