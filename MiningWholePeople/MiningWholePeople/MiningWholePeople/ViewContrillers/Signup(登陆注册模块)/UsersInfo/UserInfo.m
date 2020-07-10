//
//  UserInfo.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize isLogin;
@synthesize phoneNumber;
@synthesize cookie;
@synthesize tabBarSelected;
@synthesize deviceid;
@synthesize token;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.isLogin forKey:@"isLogin"];
    [aCoder encodeObject:self.phoneNumber     forKey:@"phoneNumber"];
    [aCoder encodeObject:self.cookie forKey:@"cookie"];
    [aCoder encodeInteger:self.tabBarSelected forKey:@"tabBarSelected"];
    [aCoder encodeObject:self.deviceid forKey:@"deviceid"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.lang forKey:@"lang"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =[super init]) {
        self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
        self.phoneNumber = [aDecoder     decodeObjectForKey:@"phoneNumber"];
        self.cookie = [aDecoder decodeObjectForKey:@"cookie"];
        self.tabBarSelected = [aDecoder     decodeIntegerForKey:@"tabBarSelected"];
        self.deviceid = [aDecoder decodeObjectForKey:@"deviceid"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.lang = [aDecoder decodeObjectForKey:@"lang"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
