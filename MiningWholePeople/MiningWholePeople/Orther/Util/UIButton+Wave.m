//
//  UIButton+Wave.m
//  JJSliderViewController
//
//  Created by FANS on 2020/7/2.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "UIButton+Wave.h"
#import <objc/runtime.h>

@interface UIButton()
@property(nonatomic,strong) UIView *waveView;
@end

@implementation UIButton (Wave)
static const char *waveViewId = "waveView";
static const char *showWave = "showWave";

+ (void)load
{
    SwizzleMethod(self, @selector(initWithFrame:), @selector(mk_initWithFrame:));
    SwizzleMethod(self, @selector(setFrame:), @selector(mk_setFrame:));
    SwizzleMethod(self, @selector(beginTrackingWithTouch:withEvent:), @selector(mk_beginTrackingWithTouch:withEvent:));
}

void SwizzleMethod(Class c,SEL orignSEL,SEL replaceSEL)
{
    Method originMethod = class_getInstanceMethod(c, orignSEL);
    Method replaceMethod = class_getInstanceMethod(c, replaceSEL);
    if (class_addMethod(c, orignSEL, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod))) {
        class_replaceMethod(c, replaceSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, replaceMethod);
    }
}

#pragma mark- privateMethod
- (instancetype)mk_initWithFrame:(CGRect)frame
{
    self.waveView = [[UIView alloc] init];
    self.waveView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    self.waveView.alpha = 0;
    self.clipsToBounds = YES;
    return [self mk_initWithFrame:frame];
}


- (void)mk_setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat max = frame.size.width > frame.size.height ? frame.size.width : frame.size.height;
    self.waveView.frame = CGRectMake(0, 0, 2*max, 2*max);
    self.waveView.layer.cornerRadius = 2*max/2;
    self.waveView.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

#pragma mark - setter,getter
- (BOOL)mk_beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    [self addSubview:self.waveView];

    self.waveView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.waveView.transform = CGAffineTransformMakeScale(.3, .3);
    
    [UIView animateWithDuration:.1 animations:^{
        self.waveView.alpha = 1;
        self.alpha = .9;
    }];
    
    [UIView animateWithDuration:.4 animations:^{
        self.waveView.transform = CGAffineTransformMakeScale(1, 1);
        self.waveView.alpha = 0;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self.waveView removeFromSuperview];
    }];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)setIsShowWave:(BOOL)isShowWave
{
    self.waveView.hidden = isShowWave ? NO : YES;
    objc_setAssociatedObject(self, showWave, @(isShowWave), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isShowWave
{
    return objc_getAssociatedObject(self, showWave);
}

- (void)setWaveView:(UIView *)waveView
{
    objc_setAssociatedObject(self, waveViewId, waveView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)waveView
{
    return objc_getAssociatedObject(self, waveViewId);
}

@end
