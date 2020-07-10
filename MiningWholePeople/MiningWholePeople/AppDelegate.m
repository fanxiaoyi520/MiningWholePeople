//
//  AppDelegate.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/3.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "AppDelegate.h"
#import "JJMainTabBarVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    self.window = [[UIWindow alloc]init];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    if (userInfo.isLogin == YES) {
        [ZDPayFuncTool getLoginSwitch];
    } else {
        [ZDPayFuncTool getLogin];
    }
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)networking_Login
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    if (token) {
        [self networking_Login:token];
    } else {
        [ZDPayFuncTool getLogin];
    }
}

- (void)networking_Login:(NSString *)token {
    NSDictionary *params = @{
        @"token": token,
    };
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,@""] parameters:params successBlock:^(id  _Nonnull responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"200"]) {
            [ZDPayFuncTool getLoginSwitch];
        } else {
            [ZDPayFuncTool getLogin];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        [ZDPayFuncTool getLogin];
    }];
}
@end
