//
//  JJLoginPasswordVC.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/10.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^LoginPasswordBlock)(NSString *msg);
@interface JJLoginPasswordVC : ZDPayRootViewController

@property (nonatomic ,copy)LoginPasswordBlock loginPasswordBlock;
@end

NS_ASSUME_NONNULL_END
