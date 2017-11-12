//
//  SPPersonalInputViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalInputViewController.h"

#import "MBProgressHUD.h"
#import "SPUserBusinessUnit.h"
#import "SPAuthBusinessUnit.h"

#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"

@interface SPPersonalInputViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate,UITextFieldDelegate> {
    UITextField *_textField;
    UIImageView *_imageView1;
    UIImageView *_imageView2;
    UIImageView *_imageView3;
    BOOL _veriftyImage1;
    BOOL _veriftyImage2;
    BOOL _veriftyImage3;
    NSInteger _currentImageViewNum;
    
    UITextField *_confirmCodeTextField;
    UIButton *_confirmCodeButton;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;

@end

@implementation SPPersonalInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval confirmCodeTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"bindConfirmTime"];
    if (nowTime - confirmCodeTime < 60) {
        _confirmCodeButton.userInteractionEnabled = false;
        [_confirmCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        NSString *dataStr = [NSString stringWithFormat:@"(%ds)",59 - (int)(nowTime-confirmCodeTime)];
        [_confirmCodeButton setTitle:dataStr forState:UIControlStateNormal];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmCodeCountDown) userInfo:nil repeats:true];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _confirmCodeButton.userInteractionEnabled = true;
            [_confirmCodeButton setTitleColor:[SPGlobalConfig themeColor] forState:UIControlStateNormal];
            [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
    }
}

#pragma mark _ SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    _navTitleLabel.text = _navTitleStr;
    if ([_navTitleStr isEqualToString:@"性别设置"]) {
        _finishedButton.hidden = true;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)
                                                              style:UITableViewStylePlain];
        tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        header.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
        tableView.tableHeaderView = header;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        
    } else if ([_navTitleStr isEqualToString:@"实名认证"]) {
        [_finishedButton setTitle:@"认证" forState:UIControlStateNormal];
        CGFloat imageWidth = SCREEN_WIDTH-40;
        CGFloat imageHeight = (SCREEN_WIDTH-40)*9/16;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        scrollView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 20+imageHeight*3+150);
        [self.view addSubview:scrollView];
        
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, imageWidth, imageHeight)];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+imageHeight, SCREEN_WIDTH, 20)];
        
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+imageHeight+50, imageWidth, imageHeight)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+imageHeight*2+50, SCREEN_WIDTH, 20)];
        
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+imageHeight*2+100, imageWidth, imageHeight)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+imageHeight*3+100, SCREEN_WIDTH, 20)];
        
        _imageView1.image = [UIImage imageNamed:@"Sports_mask"];
        _imageView2.image = [UIImage imageNamed:@"Sports_mask"];
        _imageView3.image = [UIImage imageNamed:@"Sports_mask"];
        label1.font = [UIFont systemFontOfSize:15];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"身份证正面";
        label2.font = [UIFont systemFontOfSize:15];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"身份证背面";
        label3.font = [UIFont systemFontOfSize:15];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.text = @"手持身份证照";
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImage:)];
        _imageView1.userInteractionEnabled = true;
        [_imageView1 addGestureRecognizer:tapGesture1];
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImage:)];
        _imageView2.userInteractionEnabled = true;
        [_imageView2 addGestureRecognizer:tapGesture2];
        UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImage:)];
        _imageView3.userInteractionEnabled = true;
        [_imageView3 addGestureRecognizer:tapGesture3];
        
        [scrollView addSubview:_imageView1];
        [scrollView addSubview:label1];
        [scrollView addSubview:_imageView2];
        [scrollView addSubview:label2];
        [scrollView addSubview:_imageView3];
        [scrollView addSubview:label3];
        
    } else if ([_navTitleStr isEqualToString:@"手机绑定"]) {
        [_finishedButton setTitle:@"绑定" forState:UIControlStateNormal];
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
        scrollview.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
        scrollview.showsVerticalScrollIndicator = false;
        [self.view addSubview:scrollview];
        
        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 45)];
        textView.backgroundColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 45)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = @"填写手机号";
        _textField.keyboardType = UIKeyboardTypePhonePad;
        [textView addSubview:_textField];
        //[_textField becomeFirstResponder];
        [scrollview addSubview:textView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44.5, SCREEN_WIDTH-20, 0.5)];
        lineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
        [textView addSubview:lineView];
        
        UIView *confirmCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 45)];
        confirmCodeView.backgroundColor = [UIColor whiteColor];
        _confirmCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15-100, 45)];
        _confirmCodeTextField.delegate = self;
        _confirmCodeTextField.borderStyle = UITextBorderStyleNone;
        _confirmCodeTextField.font = [UIFont systemFontOfSize:14];
        _confirmCodeTextField.placeholder = @"填写验证码";
        _confirmCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [confirmCodeView addSubview:_confirmCodeTextField];
        
        _confirmCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmCodeButton.frame = CGRectMake(SCREEN_WIDTH-15-100, 0, 100, 45);
        _confirmCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _confirmCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_confirmCodeButton setTitleColor:[SPGlobalConfig themeColor] forState:UIControlStateNormal];
        [_confirmCodeButton addTarget:self action:@selector(getConfirmCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        [confirmCodeView addSubview:_confirmCodeButton];
        [scrollview addSubview:confirmCodeView];
    } else {
        [_finishedButton setTitle:@"确认" forState:UIControlStateNormal];
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
        scrollview.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
        scrollview.showsVerticalScrollIndicator = false;
        [self.view addSubview:scrollview];
        
        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 45)];
        textView.backgroundColor = [UIColor whiteColor];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 45)];
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.text = _contentStr;
        [textView addSubview:_textField];
        //[_textField becomeFirstResponder];
        [scrollview addSubview:textView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action
- (IBAction)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (BOOL)isMobileNumber:(NSString*)mobileNum {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return[regextestmobile evaluateWithObject:mobileNum];
}

- (void)getConfirmCodeAction:(UIButton *)sender {
    if ([self isMobileNumber:_textField.text]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [[SPAuthBusinessUnit shareInstance] getVerifyWithMobile:_textField.text successful:^(NSString *successsfulString) {
            
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"验证码已发送" ToView:self.view];
                });
                NSTimeInterval confirmCodeTime = [[NSDate date] timeIntervalSince1970];
                [[NSUserDefaults standardUserDefaults] setDouble:confirmCodeTime forKey:@"bindConfirmTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                sender.userInteractionEnabled = false;
                [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [sender setTitle:@"(59s)" forState:UIControlStateNormal];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmCodeCountDown) userInfo:nil repeats:true];
            } else {
                NSLog(@"%@",successsfulString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"获取验证码失败" ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
        
    } else {
        [SPGlobalConfig showTextOfHUD:@"填写正确的手机号" ToView:self.view];
    }
}

- (void)confirmCodeCountDown {
    NSString *titleStr = _confirmCodeButton.titleLabel.text;
    int  timeNum= [[titleStr substringWithRange:NSMakeRange(1, 2)] intValue] - 1;
    if (timeNum == 0) {
        [_timer invalidate];
        _timer = nil;
        _confirmCodeButton.userInteractionEnabled = true;
        [_confirmCodeButton setTitleColor:[SPGlobalConfig themeColor] forState:UIControlStateNormal];
        [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        titleStr = [NSString stringWithFormat:@"(%ds)",timeNum];
        [_confirmCodeButton setTitle:titleStr forState:UIControlStateNormal];
    }
}

- (void)selectedImage:(UITapGestureRecognizer *)sender {
    if (sender.view == _imageView1) {
        _currentImageViewNum = 0;
    } else if (sender.view == _imageView2) {
        _currentImageViewNum = 1;
    } else if (sender.view == _imageView3) {
        _currentImageViewNum = 2;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestCameraAuthorization];
    }];
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestPhotoAuthorization];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionCamera];
    [alertController addAction:actionPhoto];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:true completion:nil];

}

- (IBAction)finishedAction {
    if ([_navTitleStr isEqualToString:@"昵称设置"]) {
        if (_textField.text.length == 0) {
            [SPGlobalConfig showTextOfHUD:@"请输入内容" ToView:self.view];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
            [[SPUserBusinessUnit shareInstance] updateNickWithUserId:userId nickName:_textField.text successful:^(NSString *successsfulString) {
                if ([successsfulString isEqualToString:@"successful"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    _personalInfoCell.contentLabel.text = _textField.text;
                    [self.navigationController popViewControllerAnimated:true];
                } else {
                    NSLog(@"%@",successsfulString);
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    });
                }
            } failure:^(NSString *errorString) {
                NSLog(@"AFN ERROR:%@",errorString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                });
            }];
        }
    } else if ([_navTitleStr isEqualToString:@"邮箱设置"]) {
        if (_textField.text.length == 0) {
            [SPGlobalConfig showTextOfHUD:@"请输入内容" ToView:self.view];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
            [[SPUserBusinessUnit shareInstance] updateEmailWithUserId:userId email:_textField.text successful:^(NSString *successsfulString) {
                if ([successsfulString isEqualToString:@"successful"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    _personalInfoCell.contentLabel.text = _textField.text;
                    [self.navigationController popViewControllerAnimated:true];
                } else {
                    NSLog(@"%@",successsfulString);
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    });
                }
            } failure:^(NSString *errorString) {
                NSLog(@"AFN ERROR:%@",errorString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                });
            }];
        }
    } else if ([_navTitleStr isEqualToString:@"实名认证"]) {
        if (_veriftyImage1 && _veriftyImage2 && _veriftyImage3) {
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            NSArray *imageArray = @[_imageView1.image,_imageView2.image,_imageView3.image];
            NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
            [[SPUserBusinessUnit shareInstance] realNameCheckWithUserId:userId images:imageArray successful:^(NSString *successsfulString) {
                if ([successsfulString isEqualToString:@"successful"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    [_personalMainCell setUpMoreImageHidden:true];
                    [_personalMainCell setUpWithContent:@"认证中"];
                    [self.navigationController popViewControllerAnimated:true];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    });
                }
            } failure:^(NSString *errorString) {
                NSLog(@"AFN ERROR:%@",errorString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                });
            }];
        } else {
            [SPGlobalConfig showTextOfHUD:@"请确认图片图片" ToView:self.view];
        }
    } else if ([_navTitleStr isEqualToString:@"手机绑定"]) {
        if (_confirmCodeTextField.text.length != 0) {
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
            [[SPUserBusinessUnit shareInstance] bindMobileWithUserId:userId mobile:_textField.text verify:_confirmCodeTextField.text successful:^(NSString *successsfulString) {
                if ([successsfulString isEqualToString:@"successful"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    NSLog(@"绑定成功");
                    _personalInfoCell.contentLabel.text = @"已绑定";
                    _personalInfoCell.moreImageView.hidden = true;
                    [self.navigationController popViewControllerAnimated:true];
                } else {
                    NSLog(@"绑定失败,%@",successsfulString);
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    });
                }
            } failure:^(NSString *errorString) {
                NSLog(@"bindMobile AFN ERROR:%@",errorString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                });
            }];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identification = @"SexIdentificationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identification];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identification];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
    } else {
        cell.textLabel.text = @"女";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSString *sexStr = nil;
    if (indexPath.row == 0) {
        sexStr = @"男";
    } else {
        sexStr = @"女";
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPUserBusinessUnit shareInstance] updateSexWithUserId:userId sex:sexStr successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            _personalInfoCell.contentLabel.text = sexStr;
            [self.navigationController popViewControllerAnimated:true];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
        
    } failure:^(NSString *errorString) {
        NSLog(@"updateSex AFN ERROR:%@",errorString);
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

#pragma mark - PhotoAuthorization
- (void)requestPhotoAuthorization {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
            [self requestPhotoAuthorizationStatus];
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            [self settingUrlWithString:@"相册"];
            break;
        case PHAuthorizationStatusAuthorized:
            [self checkPhotoAuthorizationSuccess];
            break;
        default:
            break;
    }
}

- (void)requestPhotoAuthorizationStatus {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                    [self checkPhotoAuthorizationSuccess];
                    break;
                default:
                    break;
            }
        });
    }];
}

- (void)settingUrlWithString:(NSString *)string {
    NSString *title = [NSString stringWithFormat:@"运动页还没有获取%@权限\n快去设置吧",string];
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionSetting = [UIAlertAction actionWithTitle:@"马上设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
            [[UIApplication sharedApplication] openURL:settingUrl];
        }
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionSetting];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)checkPhotoAuthorizationSuccess {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - CameraAuthorization
- (void)requestCameraAuthorization {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            [self requestCameraAuthorizationStatus];
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            [self settingUrlWithString:@"相机"];
            break;
        case AVAuthorizationStatusAuthorized:
            [self checkCameraAuthorizationSuccess];
            break;
        default:
            break;
    }
    
}

- (void)requestCameraAuthorizationStatus {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self checkCameraAuthorizationSuccess];
            }
        });
    }];
}

- (void)checkCameraAuthorizationSuccess {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    picker.videoMaximumDuration = 30;
    picker.delegate = self;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = (UIImage *)info[@"UIImagePickerControllerOriginalImage"];
        
        TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
        cropViewController.delegate = self;
        cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPreset16x9;
        cropViewController.aspectRatioLockEnabled = true;
        cropViewController.aspectRatioPickerButtonHidden = true;
        cropViewController.resetAspectRatioEnabled = false;
        [picker pushViewController:cropViewController animated:true];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"信息提示" message:@"选择的不是一张图片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [picker presentViewController:alertController animated:true completion:^{
            
        }];
    }
}

#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController
        didCropImageToRect:(CGRect)cropRect
                     angle:(NSInteger)angle {
    
    UIImage *croppedImage = [cropViewController.image croppedImageWithFrame:cropRect angle:angle circularClip:NO];
    [cropViewController.navigationController dismissViewControllerAnimated:true completion:^{
        if (_currentImageViewNum == 0) {
            _veriftyImage1 = true;
            _imageView1.image = croppedImage;
        } else if (_currentImageViewNum == 1) {
            _veriftyImage2 = true;
            _imageView2.image = croppedImage;
        } else if (_currentImageViewNum == 2) {
            _veriftyImage3 = true;
            _imageView3.image = croppedImage;
        }
    }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
