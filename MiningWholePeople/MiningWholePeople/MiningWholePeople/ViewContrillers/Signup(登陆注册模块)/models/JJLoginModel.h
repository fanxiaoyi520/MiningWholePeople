//
//  JJLoginModel.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/7.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJLoginModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *password;
@end

NS_ASSUME_NONNULL_END
