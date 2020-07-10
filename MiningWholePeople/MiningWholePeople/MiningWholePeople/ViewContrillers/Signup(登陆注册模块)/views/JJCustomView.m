//
//  JJCustomView.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/29.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJCustomView.h"
@interface JJCustomView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak)UIWindow *myWindow;
@property (nonatomic ,strong)ZDPayRootViewController *vc;
@property (nonatomic ,strong)UITableView *letfTableView;
@property (nonatomic ,strong)NSArray *dataList;
@property (nonatomic ,strong)UIView *maskView;
@end

@implementation JJCustomView

- (instancetype)initWithFrame:(CGRect)frame withVC:(ZDPayRootViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vc = vc;
        self.backgroundColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:0.96/1.0];

        [self init_UI];
    }
    return self;
}

- (void)init_UI {
    self.myWindow = [UIApplication sharedApplication].keyWindow;
    self.maskView = [UIView new];
    [self.myWindow addSubview:self.maskView];
    self.maskView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.maskView.backgroundColor = UICOLOR_RGB(76, 76, 76, .8);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
    [self.maskView addGestureRecognizer:tap];
    
    [self messageTableView];
}

#pragma mark - lazy loading
- (UITableView *)messageTableView
{
    if (!_letfTableView) {
        _letfTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _letfTableView.delegate = self;
        _letfTableView.dataSource = self;
        _letfTableView.showsVerticalScrollIndicator = NO;
        _letfTableView.showsHorizontalScrollIndicator = NO;
        _letfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _letfTableView.scrollEnabled = NO;
        _letfTableView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_letfTableView];
    }
    return _letfTableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        

        cell.textLabel.text = _dataList[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.clickTableBlock) {
        NSLog(@"%@",cell.textLabel.text);
        self.clickTableBlock(cell.textLabel.text);
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, (self.dataList.count+1)*50);
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
        self.hidden = YES;
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

#pragma mark - public
+ (JJCustomView *)init_JJCustomViewWithVC:(ZDPayRootViewController *)vc {
    return [[JJCustomView alloc] initWithFrame:CGRectZero withVC:vc];
}

- (void)showPopupViewWithData:(id)model
{
    _dataList = (NSArray *)model;
    [self.myWindow addSubview:self];
    self.frame = CGRectMake(0,ScreenHeight, ScreenWidth, (_dataList.count+1)*50);
    self.letfTableView.frame = self.bounds;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0,ScreenHeight-(self.dataList.count+1)*50, ScreenWidth, (self.dataList.count+1)*50);
        self.letfTableView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)closeThePopupView {
    if (self.clickBlock) {
        self.clickBlock();
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, (self.dataList.count+1)*50);
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
        self.hidden = YES;
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

@end
