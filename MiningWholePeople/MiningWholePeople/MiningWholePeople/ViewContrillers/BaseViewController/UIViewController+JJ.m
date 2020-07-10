//
//  UIViewController+JJ.m
//  JJSliderViewController
//
//  Created by 罗文琦 on 2017/4/16.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import "UIViewController+JJ.h"
#import <objc/runtime.h>

@implementation UIViewController (JJ)

+ (void)load {
    swizzleMethod([self class], @selector(viewDidAppear:), @selector(swizzled_viewDidAppear:));
}

- (void)swizzled_viewDidAppear:(BOOL)animated
{
    // call original implementation
    [self swizzled_viewDidAppear:animated];
    
    if (self.navigationController.viewControllers.count == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"111" object:nil userInfo:@{@"key":@(1)}];
    }
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
