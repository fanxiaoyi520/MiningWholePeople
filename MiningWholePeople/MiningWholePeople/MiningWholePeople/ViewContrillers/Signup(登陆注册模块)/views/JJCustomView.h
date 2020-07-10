//
//  JJCustomView.h
//  JJSliderViewController
//
//  Created by FANS on 2020/6/29.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ClickBlock)(void);
typedef void (^ClickTableBlock)(NSString *name);
@interface JJCustomView : UIView
+ (JJCustomView *)init_JJCustomViewWithVC:(ZDPayRootViewController *)vc;
- (void)showPopupViewWithData:(id)model;

@property (nonatomic ,copy)ClickBlock clickBlock;
@property (nonatomic ,copy)ClickTableBlock clickTableBlock;
@end

NS_ASSUME_NONNULL_END
