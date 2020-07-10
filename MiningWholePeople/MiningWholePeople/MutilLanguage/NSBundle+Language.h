//
//  NSBundle+Language.h
//  MiningWholePeople
//
//  Created by FANS on 2020/7/7.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GCLocalizedString(KEY) [[NSBundle mainBundle] localizedStringForKey:KEY value:nil table:@"Localizable"]
NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language;
@end

NS_ASSUME_NONNULL_END
