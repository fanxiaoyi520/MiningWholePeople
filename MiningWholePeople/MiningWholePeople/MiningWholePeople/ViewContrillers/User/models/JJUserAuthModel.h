//
//  JJUserAuthModel.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJUserAuthModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *real_name;
@property (nonatomic ,copy)NSString *id_card;
@property (nonatomic ,copy)NSString *front_pic;
@property (nonatomic ,copy)NSString *negative_pic;
@property (nonatomic ,copy)NSString *head_pic;
@end

NS_ASSUME_NONNULL_END
