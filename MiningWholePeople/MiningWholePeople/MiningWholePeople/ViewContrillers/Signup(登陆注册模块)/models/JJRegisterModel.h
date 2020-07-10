//
//  JJRegisterModel.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/7.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJRegisterModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *password;
@property (nonatomic ,copy)NSString *confirmpwd;
@property (nonatomic ,copy)NSString *tuijian;
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *prefix;

@end

NS_ASSUME_NONNULL_END
