//
//  JJBaseController.m
//  JJSliderViewController
//
//  Created by 罗文琦 on 2017/4/15.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import "JJMainTabBarVC.h"

@interface JJMainTabBarVC ()

@property(nonatomic , strong) NSMutableArray<UINavigationController*> * controllers;
@end

@implementation JJMainTabBarVC

#pragma mark - 指定初始化方法
-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;

}

#pragma mark - 设置界面
-(void)setupUI{
    //这里使用json的方式,持久化所有的控制器,方便以后的复用
    NSURL* jsonURL = [[NSBundle mainBundle] URLForResource:@"controller.json" withExtension:nil];
    NSData* data = [NSData dataWithContentsOfURL:jsonURL];
    //获取到json中的数组
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //使用数组进行循环创建控制器
    [self creatViewController:jsonArray];
    self.viewControllers = self.controllers;
}


#pragma mark - 当左侧的编辑按钮被点击
//创建子控制器
-(void)creatViewController:(NSArray*)jsonArray{
    self.controllers = [NSMutableArray arrayWithCapacity:jsonArray.count];
    for (NSInteger i = 0; i< jsonArray.count; i++) {
        Class cls = NSClassFromString(jsonArray[i][@"className"]);
        UIViewController* VC = [[cls alloc]init];
        VC.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        //放到导航控制器里面
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:VC];
        [self.controllers addObject:nav];
        //设置文字
        VC.title = GCLocalizedString(jsonArray[i][@"title"]);
        //设置不同状态下的图片
        VC.tabBarItem.image = [[UIImage imageNamed:jsonArray[i][@"imageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        VC.tabBarItem.selectedImage = [[UIImage imageNamed:jsonArray[i][@"selectImageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置tabBar的字体颜色
        [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:67/255.0 green:85/255.0 blue:165/255.0 alpha:1.0]} forState:UIControlStateSelected];
        [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:155/255.0 green:154/255.0 blue:154/255.0 alpha:1.0]} forState:UIControlStateNormal];
        self.tabBar.barTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
}

@end
