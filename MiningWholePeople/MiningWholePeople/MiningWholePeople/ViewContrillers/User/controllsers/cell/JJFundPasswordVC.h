//
//  JJFundPasswordVC.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/9.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^FundPasswordBlock)(NSString *msg);
@interface JJFundPasswordVC : ZDPayRootViewController

@property (nonatomic ,copy)FundPasswordBlock fundPasswordBlock;
@end

NS_ASSUME_NONNULL_END
