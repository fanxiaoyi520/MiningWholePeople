//
//  JJUserModel.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/9.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJUserModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *avatar;
@property (nonatomic ,copy)NSString *level_name;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *uid;
@end

NS_ASSUME_NONNULL_END
