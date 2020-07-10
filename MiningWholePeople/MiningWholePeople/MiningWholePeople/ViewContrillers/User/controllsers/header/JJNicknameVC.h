//
//  JJNicknameVC.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/9.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^ResetNicknameBlock)(NSString *name,NSString *msg);
@interface JJNicknameVC : ZDPayRootViewController

@property (nonatomic ,copy)ResetNicknameBlock resetNicknameBlock;
@end

NS_ASSUME_NONNULL_END
