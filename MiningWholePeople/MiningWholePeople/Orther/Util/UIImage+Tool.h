//
//  UIImage+Tool.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/10.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Tool)

+ (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
