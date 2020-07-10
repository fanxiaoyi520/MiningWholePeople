//
//  UserInfoContext.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "UserInfoContext.h"

@interface UserInfoContext ()

@property(nonatomic,strong) UserInfo *userInfo;
@end

@implementation UserInfoContext
//@synthesize userInfo;
static UserInfoContext *sharedUserInfoContext = nil;

+(UserInfoContext*)sharedUserInfoContext{
static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(sharedUserInfoContext == nil){
            sharedUserInfoContext = [[self alloc] init];
        }
    });
    return sharedUserInfoContext;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t token;
     dispatch_once(&token, ^{
         if(sharedUserInfoContext == nil){
             sharedUserInfoContext = [super allocWithZone:zone];
         }
     });
    return sharedUserInfoContext;
}

- (instancetype)init{
     self = [super init];
     if(self){
         sharedUserInfoContext.userInfo = [[UserInfo alloc] init];
     }
     return self;
}

- (UserInfo *)getUserInfo
{
    return sharedUserInfoContext.userInfo;
}

- (id)copy{
     return self;
}

- (id)mutableCopy{
     return self;
}
@end
