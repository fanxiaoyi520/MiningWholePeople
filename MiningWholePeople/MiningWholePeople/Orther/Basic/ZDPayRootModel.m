//
//  ZDPayRootModel.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

@implementation ZDPayRootModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue||[oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return oldValue;
}

@end
