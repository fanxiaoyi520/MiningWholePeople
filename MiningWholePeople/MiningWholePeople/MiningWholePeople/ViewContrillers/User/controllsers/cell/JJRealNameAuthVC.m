//
//  JJRealNameAuthVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJRealNameAuthVC.h"
#import "JJUserAuthModel.h"

@interface JJRealNameAuthVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic ,strong)UIScrollView *realNameAutoScrollView;
@property (nonatomic ,assign)CGFloat submitTopHeight;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)JJUserAuthModel *userAuthModel;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (assign, nonatomic) NSInteger clickUploadTag;
@property (copy, nonatomic) NSString *stateStr;
@end

@implementation JJRealNameAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    self.naviTitle = GCLocalizedString(@"实名认证");
    self.mutableDic = [NSMutableDictionary dictionary];
    [self.mutableDic setValue:@"" forKey:@"real_name"];
    [self.mutableDic setValue:@"" forKey:@"id_card"];
    [self.mutableDic setValue:@"" forKey:@"front_pic"];
    [self.mutableDic setValue:@"" forKey:@"negative_pic"];
    [self.mutableDic setValue:@"" forKey:@"head_pic"];
    
    [self networking_get_user_certification];
}

- (void)init_UI
{
    [self realNameAutoScrollView];
    [self.view bringSubviewToFront:self.topNavBar];
    
    NSArray *titleArray = @[GCLocalizedString(@"基本信息"),GCLocalizedString(@"认证信息")];
    NSArray *defaultArray = @[GCLocalizedString(@"请输入你的姓名"),GCLocalizedString(@"请输入你的身份证号码")];
    NSArray *status_basicArrcy = nil;
    if([self.stateStr isEqualToString:@"2"]) status_basicArrcy = @[self.userAuthModel.real_name,self.userAuthModel.id_card];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        
        CGRect titleLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:titleArray[i] withFont:label_font_PingFang_SC(16)];
        UILabel *titleLab = [UILabel new];
        [self.realNameAutoScrollView addSubview:titleLab];
        titleLab.frame = CGRectMake(14.5, 89+i*(15.5+151.5), titleLabRect.size.width, 15.5);
        titleLab.text = titleArray[i];
        titleLab.font = label_font_PingFang_SC(16);
        titleLab.textColor = UICOLOR_RGB_SAME(0);
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15.5, 141-9+i*(13.5+50), ScreenWidth-31, 13.5+18)];
        [self.realNameAutoScrollView addSubview:textField];
        textField.placeholder = defaultArray[i];
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        textField.tag = 100 + i;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        if([self.stateStr isEqualToString:@"2"]) textField.text = status_basicArrcy[i];
        
        UIView *lineView = [UIView new];
        [self.realNameAutoScrollView addSubview:lineView];
        lineView.backgroundColor = UICOLOR_RGB_SAME(243);
        lineView.frame = CGRectMake(14.5, 172+i*(1+64), ScreenWidth-29, 1);
    }];
    
    NSArray *imageTitleArray = @[GCLocalizedString(@"点击上传身份证正面照"),GCLocalizedString(@"点击上传身份证反面照片"),GCLocalizedString(@"点击上传人脸正面图片")];
    NSArray *status_imageArray = nil;
    if([self.stateStr isEqualToString:@"2"]) status_imageArray = @[self.userAuthModel.front_pic,self.userAuthModel.negative_pic,self.userAuthModel.head_pic];
    [imageTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        
        UIButton *backview = [[UIButton alloc] init];
        backview.frame = CGRectMake(15,290+i*(188+19),ScreenWidth-30,188);
        backview.backgroundColor = UICOLOR_RGB(241, 245, 253, 1);
        backview.layer.cornerRadius = 5;
        [self.realNameAutoScrollView addSubview:backview];
        [backview addTarget:self action:@selector(clickUploadAction:) forControlEvents:UIControlEventTouchUpInside];
        backview.tag = 1000+i;
        
        UIImageView *peopleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((backview.width-102)/2, 37, 102, 72)];
        [backview addSubview:peopleImageView];
        if([self.stateStr isEqualToString:@"2"]) {
            UIImage * image = nil;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:status_imageArray[i]]];
            image = [UIImage imageWithData:data];
            CGFloat x = (image.size.width*100)/image.size.height;
            if (x>= backview.width-40) x = backview.width-40;
            peopleImageView.frame = CGRectMake((backview.width-x)/2, (backview.height-100)/2, x, 100);
            peopleImageView.image = image;
            
            backview.userInteractionEnabled = NO;
        } else {
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *resourcePath = [bundle resourcePath];
            peopleImageView.tag = 300;
            NSString *filePath = [resourcePath stringByAppendingPathComponent:GCLocalizedString(@"上传身份证正面")];
            peopleImageView.image = [UIImage imageWithContentsOfFile:filePath];
        }

        CGRect imageTitleLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:imageTitleArray[i] withFont:label_font_PingFang_SC(13)];
        UILabel *imageTitleLab = [UILabel new];
        [backview addSubview:imageTitleLab];
        imageTitleLab.frame = CGRectMake((backview.width-imageTitleLabRect.size.width)/2, peopleImageView.bottom+24.5, imageTitleLabRect.size.width, 13);
        imageTitleLab.text = imageTitleArray[i];
        imageTitleLab.font = label_font_PingFang_SC(13);
        imageTitleLab.textColor = UICOLOR_RGB_SAME(0);
        imageTitleLab.tag = 400;
        if([self.stateStr isEqualToString:@"2"]) imageTitleLab.hidden = YES;
        if (i==2) self.submitTopHeight = backview.bottom+19;
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.frame = CGRectMake(14.5,self.submitTopHeight,ScreenWidth-29,50.5);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,submitBtn.size.width,submitBtn.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:63/255.0 green:181/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:7/255.0 green:109/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [submitBtn.layer addSublayer:gl];
    [self.realNameAutoScrollView addSubview:submitBtn];
    submitBtn.layer.cornerRadius = 5;
    
    UILabel *btnLab = [UILabel new];
    [submitBtn addSubview:btnLab];
    btnLab.textColor = UICOLOR_RGB_SAME(255);
    btnLab.font = label_font_PingFang_SC(15);
    btnLab.frame = CGRectMake(0, 18, submitBtn.size.width, 14);
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = GCLocalizedString(@"提交申请");
    if([self.stateStr isEqualToString:@"2"]) {
        btnLab.text = GCLocalizedString(@"待审核");
        submitBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - lazy loading
- (UIScrollView *)realNameAutoScrollView
{
    if (!_realNameAutoScrollView) {
        _realNameAutoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _realNameAutoScrollView.contentSize = CGSizeMake(ScreenWidth, 991.5);
        _realNameAutoScrollView.showsVerticalScrollIndicator = NO;
        _realNameAutoScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_realNameAutoScrollView];
    }
    return _realNameAutoScrollView;;
}

- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
    }
    return _picker;
}

#pragma mark - delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CGFloat x = (image.size.width*100)/image.size.height;
    [YQImageCompressTool CompressToImageAtBackgroundWithImage:image ShowSize:CGSizeMake(x, 100) FileSize:100 block:^(UIImage *resultImage) {
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
        [self showMessage:GCLocalizedString(@"上传成功") target:nil];
        UIButton *backView = [self.realNameAutoScrollView viewWithTag:self.clickUploadTag];
        UIImageView *peopleImageView = [backView viewWithTag:300];
        peopleImageView.image = uploadImage;
        CGFloat x = (uploadImage.size.width*100)/uploadImage.size.height;
        if (x>= backView.width-40) x = backView.width-40;
        peopleImageView.frame = CGRectMake((backView.width-x)/2, (backView.height-100)/2, x, 100);
        
        UILabel *imageTitleLab = [backView viewWithTag:400];
        imageTitleLab.hidden = YES;
        
        if (self.clickUploadTag == 1000) {
            [self.mutableDic setValue:msg forKey:@"front_pic"];
        } else if (self.clickUploadTag == 1001){
            [self.mutableDic setValue:msg forKey:@"negative_pic"];
        } else {
            [self.mutableDic setValue:msg forKey:@"head_pic"];
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showMessage:GCLocalizedString(@"上传失败") target:nil];
    }];
}

//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - actions
- (void)textFieldAction:(UITextField *)textField
{
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"real_name"];
    } else {
        [self.mutableDic setValue:textField.text forKey:@"id_card"];
    }
}

- (void)submitBtnAction:(UIButton *)sender
{
    JJUserAuthModel *model = [JJUserAuthModel mj_objectWithKeyValues:self.mutableDic];
    self.userAuthModel = model;
    
    if ([model.real_name isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入姓名") target:nil];
        return;
    }
    
    if ([model.id_card isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入身份证号码") target:nil];
        return;
    }

    if ([model.front_pic isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请上传身份证正面照") target:nil];
        return;
    }
    
    if ([model.negative_pic isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请上传身份证反面照片") target:nil];
        return;
    }
    
    if ([model.head_pic isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请上传人脸正面照片") target:nil];
        return;
    }
    [self networking_certification];
}

- (void)clickUploadAction:(UIButton *)sender
{
    self.clickUploadTag = sender.tag;
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
}

#pragma mark - networking
- (void)networking_get_file
{
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    NSDictionary *params = @{@"token":userInfo.token};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GET_FILE] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {

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

- (void)networking_certification
{
    NSString *real_name = [NSString stringWithFormat:@"%@",self.userAuthModel.real_name];
    NSString *id_card = [NSString stringWithFormat:@"%@",self.userAuthModel.id_card];
    NSString *front_pic = [NSString stringWithFormat:@"%@",self.userAuthModel.front_pic];
    NSString *negative_pic = [NSString stringWithFormat:@"%@",self.userAuthModel.negative_pic];
    NSString *head_pic = [NSString stringWithFormat:@"%@",self.userAuthModel.head_pic];
    NSDictionary *params = @{
                            @"real_name":real_name,
                            @"id_card":id_card,
                            @"front_pic":front_pic,
                            @"negative_pic":negative_pic,
                            @"head_pic":head_pic,
                            };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,CERTIFICATION] parameters:params successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self showMessage:[responseObject objectForKey:@"msg"] target:nil];
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

- (void)networking_get_user_certification
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GET_USER_CERTIFICATION] parameters:nil successBlock:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!responseObject) {
            return;
        }
        
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            JJUserAuthModel *model = [JJUserAuthModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            self.userAuthModel = model;
            self.stateStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
            [self init_UI];
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
