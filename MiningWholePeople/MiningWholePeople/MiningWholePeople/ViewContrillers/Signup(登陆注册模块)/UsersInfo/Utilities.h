//
//  Utilities.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "UserInfoContext.h"
NS_ASSUME_NONNULL_BEGIN

@interface Utilities : NSObject

//单例-> NSUserDefaults
+(void)SetNSUserDefaults:(UserInfo *)userInfo;
//NSUserDefaults-> 单例
+(UserInfo *)GetNSUserDefaults;

@end

NS_ASSUME_NONNULL_END
