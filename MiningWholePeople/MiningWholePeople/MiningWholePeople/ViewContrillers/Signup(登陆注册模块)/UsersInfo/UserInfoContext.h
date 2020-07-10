//
//  UserInfoContext.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserInfoContext : NSObject

+(UserInfoContext*)sharedUserInfoContext;

- (UserInfo *)getUserInfo;
@end

NS_ASSUME_NONNULL_END
