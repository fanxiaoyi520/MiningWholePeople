//
//  JJContactCustomModel.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/10.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JJContactCustomModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *content;
@property (nonatomic ,copy)NSString *picture;
@end

NS_ASSUME_NONNULL_END
