//
//  JJPersonalInfoVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/9.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJPersonalInfoVC.h"
#import "JJNicknameVC.h"

@interface JJPersonalCell : UITableViewCell

@property (nonatomic ,strong)UILabel *titleLab;
@property (nonatomic ,strong)UILabel *contentLab;
@property (nonatomic ,strong)UIImageView *headerImageView;
@property (nonatomic ,strong)UIImageView *directionImageView;
@property (nonatomic ,strong)UIView *lineView;

- (void)layoutViewAndLondingData:(NSString *)model withMyIndexPath:(NSIndexPath *)myIndexPath;
@end
@implementation JJPersonalCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self init_UI];
    }
    return self;
}

- (void)init_UI
{
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    titleLab.textColor = UICOLOR_RGB_SAME(0);
    titleLab.font = label_font_PingFang_SC(13);

    UILabel *contentLab = [UILabel new];
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    contentLab.textColor = UICOLOR_RGB_SAME(0);
    contentLab.font = label_font_PingFang_SC(13);
    
    UIImageView * headerImageView = [UIImageView new];
    self.headerImageView = headerImageView;
    [self.contentView addSubview:headerImageView];
    
    UIImageView * directionImageView = [UIImageView new];
    self.directionImageView = directionImageView;
    [self.contentView addSubview:directionImageView];

    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = UICOLOR_RGB_SAME(243);
}

- (void)layoutViewAndLondingData:(NSString *)model withMyIndexPath:(NSIndexPath *)myIndexPath
{
    NSDictionary *dic = (NSDictionary *)model;
    
    CGRect titleLabRect =[ZDPayFuncTool getStringWidthAndHeightWithStr:[dic objectForKey:@"title"] withFont:label_font_PingFang_SC(13)];
    self.titleLab.frame = CGRectMake(15.5, 19, titleLabRect.size.width, 13);
    self.titleLab.text = [dic objectForKey:@"title"];
    
    CGRect contentLabRect =[ZDPayFuncTool getStringWidthAndHeightWithStr:[dic objectForKey:@"headerContent"] withFont:label_font_PingFang_SC(13)];
    if (myIndexPath.row != 0) {
        self.contentLab.frame = CGRectMake(ScreenWidth-contentLabRect.size.width-38.5, 19, contentLabRect.size.width, 13);
        self.contentLab.text = [dic objectForKey:@"headerContent"];
    }
    
    if (myIndexPath.row == 0) {
        self.headerImageView.frame = CGRectMake(ScreenWidth - 40 - 37.5, 5, 40, 40);
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headerContent"]] placeholderImage:[UIImage imageNamed:[dic objectForKey:@"headerContent"]]];
    }
    
    if (myIndexPath.row != 2) {
        self.directionImageView.frame = CGRectMake(ScreenWidth-6-18, 19, 6, 11.5);
        self.directionImageView.image = [UIImage imageNamed:@"fangxiang"];
    }

    self.lineView.frame = CGRectMake(14, 48.5, ScreenWidth-28, 1);
}
@end

@interface JJPersonalInfoVC ()<UITableViewDelegate ,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic ,strong)UITableView *personalTableView;
@property (nonatomic ,strong)NSArray *personalArray;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (copy, nonatomic) NSString *avatar;
@end

@implementation JJPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.model.nickname isEqualToString:@""]) self.model.nickname = GCLocalizedString(@"设置昵称");
    if ([self.model.avatar isEqualToString:@""]) self.model.avatar = @"e9978955638ca71877822b0c4d23913c";
    self.naviTitle = GCLocalizedString(@"个人信息");
    self.personalArray = @[@{@"title":GCLocalizedString(@"头像"),@"headerContent":self.model.avatar,},
                           @{@"title":GCLocalizedString(@"昵称"),@"headerContent":[NSString stringWithFormat:@"%@",self.model.nickname]},
                           @{@"title":GCLocalizedString(@"UID"),@"headerContent":[NSString stringWithFormat:@"%@",self.model.uid]}];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    
    [self init_UI];
}

- (void)init_UI
{
    [self personalTableView];
}

#pragma mark - lazy loading
- (UITableView *)personalTableView
{
    if (!_personalTableView) {
        _personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, mcStatusBarHeight+mcNavBarHeight, ScreenWidth, ScreenHeight-mcStatusBarHeight-mcNavBarHeight) style:UITableViewStylePlain];
        _personalTableView.delegate = self;
        _personalTableView.dataSource = self;
        _personalTableView.bounces = NO;
        _personalTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _personalTableView.backgroundView = nil;
        [self.view addSubview:_personalTableView];
    }
    return _personalTableView;
}

- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
    }
    return _picker;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_id = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    JJPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[JJPersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell layoutViewAndLondingData:self.personalArray[indexPath.row] withMyIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BOOL isPicker = NO;
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.modalPresentationStyle = 0;
        isPicker = true;
        if (isPicker) {
            [self presentViewController:self.picker animated:YES completion:nil];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if (indexPath.row == 1) {
        JJNicknameVC *vc = [JJNicknameVC new];
        @weakify(self)
        vc.resetNicknameBlock = ^(NSString * _Nonnull name, NSString * _Nonnull msg) {
            @strongify(self)
            if ([self.model.nickname isEqualToString:@""]) self.model.nickname = GCLocalizedString(@"设置昵称");
            if ([self.model.avatar isEqualToString:@""]) self.model.avatar = @"e9978955638ca71877822b0c4d23913c";
            self.personalArray = @[@{@"title":GCLocalizedString(@"头像"),@"headerContent":self.model.avatar,},
                                   @{@"title":GCLocalizedString(@"昵称"),@"headerContent":[NSString stringWithFormat:@"%@",name]},
                                   @{@"title":GCLocalizedString(@"UID"),@"headerContent":[NSString stringWithFormat:@"%@",self.model.uid]}];
            [self showMessage:msg target:nil];
            [self.personalTableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [YQImageCompressTool CompressToImageAtBackgroundWithImage:image ShowSize:CGSizeMake(40, 40) FileSize:100 block:^(UIImage *resultImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self personalUploadHeadImgInterfaceWithImage:resultImage withPicker:picker];
        });
    }];
}

- (void)personalUploadHeadImgInterfaceWithImage:(UIImage *)uploadImage  withPicker:(UIImagePickerController *)picker {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",DOMAINNAME,GET_FILE];
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    [mgr.requestSerializer setValue:userInfo.token forHTTPHeaderField:@"token"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(uploadImage, 1.0);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *msg = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
        self.avatar = msg;
        [self showMessage:GCLocalizedString(@"上传成功") target:nil];
        [self networking_set_user_avatar];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showMessage:GCLocalizedString(@"上传失败") target:nil];
    }];
}

#pragma mark - networking
- (void)networking_set_user_avatar
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"avatar":self.avatar};
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,SET_USER_AVATAR] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            if ([self.model.nickname isEqualToString:@""]) self.model.nickname = GCLocalizedString(@"设置昵称");
            self.personalArray = @[@{@"title":GCLocalizedString(@"头像"),@"headerContent":[responseObject objectForKey:@"data"],},
                                   @{@"title":GCLocalizedString(@"昵称"),@"headerContent":[NSString stringWithFormat:@"%@",self.model.nickname]},
                                   @{@"title":GCLocalizedString(@"UID"),@"headerContent":[NSString stringWithFormat:@"%@",self.model.uid]}];
            [self.personalTableView reloadData];
        } else {
            [self showMessage:[responseObject objectForKey:@"msg"] target:nil];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *responseData = error.userInfo[NSLocalizedDescriptionKey];
            [self showMessage:responseData target:nil];
        }
    }];
}
@end
