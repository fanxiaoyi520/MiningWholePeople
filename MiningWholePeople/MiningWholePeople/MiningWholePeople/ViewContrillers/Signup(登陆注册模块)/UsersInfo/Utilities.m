//
//  Utilities.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

//存储单例Models(UserInfo)到NSUserDefaults
+(void)SetNSUserDefaults:(UserInfo *)userInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo requiringSecureCoding:YES error:nil];
        [defaults setObject:data forKey:@"user"];
    } else {
        // Fallback on earlier versions
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        [defaults setObject:data forKey:@"user"];
    }
    [defaults synchronize];
}

//读取NSUserDefaults存储内容return到单例Modesl(UserInfo)中
+(UserInfo *)GetNSUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    
    if (@available(iOS 11.0, *)) {
        return [NSKeyedUnarchiver unarchivedObjectOfClass:[[[UserInfoContext sharedUserInfoContext] getUserInfo] class] fromData:data error:nil];
    } else {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

@end
