//
//  JJContactCustomerVC.m
//  MiningWholePeople
//
//  Created by FANS on 2020/7/10.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "JJContactCustomerVC.h"
#import "JJContactCustomModel.h"
@interface JJContactCustomerVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>

@property (nonatomic ,strong)UIScrollView *contactCustomScrollView;
@property (nonatomic ,strong)UICollectionView *imageCollectionView;
@property (nonatomic ,strong)NSMutableArray *imageDataList;
@property (nonatomic ,strong)NSMutableArray *uploadImageDataList;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,strong)JJContactCustomModel *contactCustomModel;

@end

@implementation JJContactCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = GCLocalizedString(@"联系客服");
    self.mutableDic = [NSMutableDictionary dictionary];
    [self init_UI];
}

- (void)init_UI
{
    [self contactCustomScrollView];
    
    UIButton *newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newsButton.frame = CGRectMake(ScreenWidth - 14-13, 40, 14, 16);
    [newsButton setImage:[UIImage imageNamed:@"铃铛"] forState:UIControlStateNormal];
    [newsButton addTarget:self action:@selector(newsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topNavBar addSubview:newsButton];
    
    NSArray *titleArray = @[GCLocalizedString(@"标题"),GCLocalizedString(@"内容"),GCLocalizedString(@"反馈截图")];
    __block CGFloat title_2_top = 0;
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        CGRect titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:titleArray[i] withFont:label_font_PingFang_SC(13)];
        
        UILabel *titleLab1 = [UILabel new];
        [self.contactCustomScrollView addSubview:titleLab1];
        titleLab1.font = label_font_PingFang_SC(13);
        titleLab1.textColor = UICOLOR_RGB_SAME(3);
        titleLab1.text = titleArray[i];
        if (i != 2) titleLab1.frame = CGRectMake(15.5, mcNavBarHeight+mcStatusBarHeight+30+i*(64.5+13), titleRect.size.width, 13);
        if (i==1) title_2_top = titleLab1.bottom;
        if (i == 2) titleLab1.frame = CGRectMake(15.5, title_2_top+146, titleRect.size.width, 13);
        
        if (i==0) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, titleLab1.bottom+15.5, ScreenWidth-30, 37)];
            textField.backgroundColor = UICOLOR_RGB(241, 245, 255, 1);
            [self.contactCustomScrollView addSubview:textField];
            textField.layer.cornerRadius = 5;
            UIView *emptyView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
            textField.leftView = emptyView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:GCLocalizedString(@"请输入您要反馈的问题") attributes:@{NSForegroundColorAttributeName : UICOLOR_RGB(118, 119, 124, 1),NSFontAttributeName:label_font_PingFang_SC(13)
            }];
            [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        }
        
        if (i==1) {
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, titleLab1.bottom+15.5, ScreenWidth-30, 117.5)];
            [self.contactCustomScrollView addSubview:textView];
            textView.text = GCLocalizedString(@" 请输入您要反馈的内容及建议");
            textView.backgroundColor = UICOLOR_RGB(241, 245, 255, 1);
            textView.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:@{NSForegroundColorAttributeName : UICOLOR_RGB(118, 119, 124, 1),NSFontAttributeName:label_font_PingFang_SC(13)
            }];
            textView.delegate = self;
            textView.layer.cornerRadius = 5;
        }

        if (i==2) {
            UIView *backView = [UIView new];
            [self.contactCustomScrollView addSubview:backView];
            backView.layer.cornerRadius = 5;
            backView.backgroundColor = UICOLOR_RGB(241, 245, 255, 1);
            backView.frame = CGRectMake(15, titleLab1.bottom+14, ScreenWidth-30, 96);
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 10;
            layout.minimumLineSpacing = 10;
            layout.itemSize = CGSizeMake(79, 79);
            layout.sectionInset = UIEdgeInsetsMake(10, 10 ,10, 10);
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView.scrollEnabled = YES;
            self.imageCollectionView = collectionView;
            self.imageCollectionView.delegate = self;
            self.imageCollectionView.dataSource = self;
            self.imageCollectionView.frame = CGRectMake(0, 0, backView.width, backView.height);
            [self.imageCollectionView registerClass:[UICollectionViewCell class]
                       forCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID"];
            [self.imageCollectionView registerClass:[UICollectionViewCell class]
                       forCellWithReuseIdentifier:@"addCell"];
            [backView addSubview:collectionView];
        }
    }];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.frame = CGRectMake(14.5,478,ScreenWidth-29,50.5);
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,commitBtn.size.width,commitBtn.size.height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:63/255.0 green:181/255.0 blue:251/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:7/255.0 green:109/255.0 blue:237/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [commitBtn.layer addSublayer:gl];
    [self.contactCustomScrollView addSubview:commitBtn];
    commitBtn.layer.cornerRadius = 5;
    
    UILabel *btnLab = [UILabel new];
    [commitBtn addSubview:btnLab];
    btnLab.textColor = UICOLOR_RGB_SAME(255);
    btnLab.font = label_font_PingFang_SC(15);
    btnLab.frame = CGRectMake(0, 18, commitBtn.size.width, 14);
    btnLab.textAlignment = NSTextAlignmentCenter;
    btnLab.text = GCLocalizedString(@"提交反馈");
}

#pragma mark - lazy loading
- (UIScrollView *)contactCustomScrollView
{
    if (!_contactCustomScrollView) {
        _contactCustomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:_contactCustomScrollView];
        _contactCustomScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        _contactCustomScrollView.showsVerticalScrollIndicator = NO;
        _contactCustomScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contactCustomScrollView;
}

- (NSMutableArray *)imageDataList {
    if (!_imageDataList) {
        _imageDataList = [NSMutableArray array];
    }
    return _imageDataList;
}

- (NSMutableArray *)uploadImageDataList {
    if (!_uploadImageDataList) {
        _uploadImageDataList = [NSMutableArray array];
    }
    return _uploadImageDataList;
}

#pragma mark - actions
- (void)commitBtnAction:(UIButton *)sender
{
    JJContactCustomModel *model = [JJContactCustomModel mj_objectWithKeyValues:self.mutableDic];
    self.contactCustomModel = model;
    
    if ([model.title isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请输入您要反馈的问题") target:nil];
        return;
    }
    
    if ([model.content isEqualToString:@""] || [model.content isEqualToString:GCLocalizedString(@" 请输入您要反馈的内容及建议")]) {
        [self showMessage:GCLocalizedString(@"请输入您要反馈的内容及建议") target:nil];
        return;
    }
    
    if (model.content.length < 3) {
        [self showMessage:GCLocalizedString(@"反馈内容过于简单") target:nil];
        return;
    }
    
    if ([model.picture isEqualToString:@""]) {
        [self showMessage:GCLocalizedString(@"请选择图片") target:nil];
        return;
    }
    
    [self networking_set_pay_pwd];
}

- (void)textFieldAction:(UITextField *)textField
{
    [self.mutableDic setValue:textField.text forKey:@"title"];
}

- (void)newsButtonAction:(UIButton *)sender
{
    
}

#pragma mark - delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self.mutableDic setValue:textView.text forKey:@"content"];
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length<1) {
        textView.text = @" 请输入您要反馈的内容及建议";
        textView.textColor = UICOLOR_RGB(118, 119, 124, 1);
    }
    [self.mutableDic setValue:textView.text forKey:@"content"];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@" 请输入您要反馈的内容及建议"]) {
        textView.text = @"";
        textView.textColor = UICOLOR_RGB_SAME(3);
    }
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageDataList.count+1;
}

 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
      if (indexPath.row == self.imageDataList.count)
      {
          UICollectionViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
          
          UIImageView *addImage = [UIImageView new];
          [addCell addSubview:addImage];
          addImage.frame = CGRectMake((addCell.width-85)/2, (addCell.height-85)/2, 85, 85);
          addImage .userInteractionEnabled = YES;
          addImage.image = REImageName(@"shizijia");
          return addCell;
      }

     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MAINCOLLECTIONVIEWID" forIndexPath:indexPath];
     cell.backgroundColor = UICOLOR_RGB_SAME(255);
     cell.layer.cornerRadius = 8;
     
     UIImageView *imageView = [UIImageView new];
     imageView.frame = CGRectMake(0, 0, cell.width, cell.height);
     imageView.userInteractionEnabled = YES;
     [cell addSubview:imageView];
     
     UIButton *deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [deleButton setImage:REImageName(@"login_icon_delect_nor") forState:UIControlStateNormal];
     deleButton.frame = CGRectMake(cell.width-20, 0, 20, 20);
     [deleButton addTarget:self action:@selector(deleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [imageView addSubview:deleButton];
     
     if (self.imageDataList.count != 0) {
         ZZPhoto *zzPhoto = self.imageDataList[indexPath.item];
         imageView.image = zzPhoto.originImage;
     }
     return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.imageDataList.count) {
        [self.imageDataList removeAllObjects];
        ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
        photoController.selectPhotoOfMax = 3;
        [photoController showIn:self result:^(id responseObject){
            NSArray *array = (NSArray *)responseObject;
            [self.imageDataList addObjectsFromArray:array];
            [self uploadMultiplePictures:array];
        }];
    }
}

- (void)deleButtonAction:(UIButton *)sender {
    [self.imageDataList removeObjectAtIndex:sender.tag];
    if (self.imageDataList.count == 0) {
        [self.mutableDic setValue:@"" forKey:@"picture"];
    }
    if (@available(iOS 10.0, *)) {
        [self.imageCollectionView refreshControl];
    }
    [self.imageCollectionView reloadData];
}

#pragma mark - 上传图片
- (void)uploadMultiplePictures:(NSArray *)array {
    [self.uploadImageDataList removeAllObjects];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    if (userInfo.token)[manager.requestSerializer setValue:userInfo.token forHTTPHeaderField:@"token"];
    if (userInfo.lang)[manager.requestSerializer setValue:userInfo.lang forHTTPHeaderField:@"lang"];
    NSString *url = [NSString stringWithFormat:@"%@%@",DOMAINNAME,GET_FILE];
    for (int i = 0; i < array.count; i++) {
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            ZZPhoto *zzPhoto = array[i];
            UIImage *image = zzPhoto.originImage;
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"---上传进度--- %@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"```上传成功``` %@",responseObject);
            NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [self.uploadImageDataList addObject:msg];
            if (i==array.count-1) {
                
                NSString *picture = [self.uploadImageDataList componentsJoinedByString:@","];
                [self.mutableDic setValue:picture forKey:@"picture"];
                [self showMessage:GCLocalizedString(@"上传成功") target:nil];
                [self.imageCollectionView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"xxx上传失败xxx %@", error);
            if (i==array.count-1) {
                [self showMessage:GCLocalizedString(@"上传失败") target:nil];
                [self.imageCollectionView reloadData];
            }
        }];
    }
}

#pragma mark - networking
- (void)networking_set_pay_pwd
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *title = [NSString stringWithFormat:@"%@",self.contactCustomModel.title];
    NSString *content = [NSString stringWithFormat:@"%@",self.contactCustomModel.content];
    NSString *picture = [NSString stringWithFormat:@"%@",self.contactCustomModel.picture];
    NSDictionary *params = @{@"title":title,@"content":content,@"picture":picture};
    [AFNetworkingManager requestWithType:SkyHttpRequestTypePost urlString:[NSString stringWithFormat:@"%@%@",DOMAINNAME,PUT_ORDER] parameters:params successBlock:^(id  _Nonnull responseObject) {
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
@end
