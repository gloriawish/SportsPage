//
//  SPCreateSportsViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateSportsViewController.h"

#import "SPCreateNextStepViewController.h"
#import "SPCreateLocationViewController.h"
#import "SPCreateCompleteViewController.h"

#import "AppDelegate.h"
#import "SPCreateEventView.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SPSportBusinessUnit.h"
#import "SPSportsCreateRequestModel.h"
#import "SPIMBusinessUnit.h"
#import "SPUserInfoModel.h"

#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"
#import "MBProgressHUD.h"

@interface SPCreateSportsViewController () <UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TOCropViewControllerDelegate,SPSportsCreateLocationProtocol> {
    BOOL _verfityImage;
    
    UILabel *_textPlaceHolder;
    
    CGFloat _keyboardHeight;
    NSTimeInterval _animationDuration;
    CGRect _textViewFrame;
    
    NSString *_sportsId;
    
    NSString *_latitudeStr;
    NSString *_longitudeStr;
    NSString *_addressStr;
}

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistanceConstraint;

@end

@implementation SPCreateSportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappearAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    _verfityImage = false;
    
    _nextStepButton.layer.cornerRadius = 5;
    _nextStepButton.layer.masksToBounds = true;
    [_nextStepButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
    _eventShowKeyboard = false;
    
    _nameTextField.delegate = self;
    _locationTextField.delegate = self;
    _eventTextField.delegate = self;
    
    _addImageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImage:)];
    [_addImageView addGestureRecognizer:tapGesture];

    _textView.font = [UIFont systemFontOfSize:13];
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [SPGlobalConfig anyColorWithRed:230 green:230 blue:230 alpha:1].CGColor;
    _textView.layer.cornerRadius = 6;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    
    _textPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, SCREEN_WIDTH-30, 20)];
    _textPlaceHolder.text = @"请在此输入详情描述";
    _textPlaceHolder.textColor = [SPGlobalConfig anyColorWithRed:135 green:135 blue:135 alpha:1];
    _textPlaceHolder.font = [UIFont systemFontOfSize:13];
    [_textView addSubview:_textPlaceHolder];
}

#pragma mark - Action
- (IBAction)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)selectedImage:(id)sender {
    
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
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

- (IBAction)nextStepAction:(id)sender {
    
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    
    if (_nameTextField.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"运动名称不能为空" ToView:self.view];
    } else if (_locationTextField.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"运动地址不能为空" ToView:self.view];
    } else if (_eventTextField.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"运动项目不能为空" ToView:self.view];
    } else if (_nameTextField.text.length > 12) {
        [SPGlobalConfig showTextOfHUD:@"运动名称最长12个字" ToView:self.view];
    } else if (!_verfityImage)
        [SPGlobalConfig showTextOfHUD:@"还未上传图片" ToView:self.view];
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPIMBusinessUnit shareInstance] getUserInfoWithUserId:userId success:^(JSONModel *model) {
            if (model) {
                if ([(SPUserInfoModel *)model mobile].length != 0) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    [self requestCreateSportsAction];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    SPCreateCompleteViewController *completeViewController = [[SPCreateCompleteViewController alloc] init];
                    [self.navigationController pushViewController:completeViewController animated:true];
                }
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络连接失败" ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络连接失败" ToView:self.view];
            });
        }];
    }
}

- (void)requestCreateSportsAction {
    if (_nameTextField.userInteractionEnabled == true) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        
        SPSportsCreateRequestModel *model = [[SPSportsCreateRequestModel alloc] init];
        
        model.title = _nameTextField.text;
        model.place = _locationTextField.text;
        
        if (_addressStr.length != 0) {
            model.location = _addressStr;
        } else {
            model.location = @"地址未填写";
        }
        
        if (_longitudeStr.length != 0) {
            model.longitude = _longitudeStr;
        } else {
            model.longitude = @"-999";
        }
        
        if (_latitudeStr.length != 0) {
            model.latitude = _latitudeStr;
        } else {
            model.latitude = @"-999";
        }
        
        if (_textView.text.length == 0) {
            model.summary = @"这个人很懒,还没有填写详情描述";
        } else {
            model.summary = _textView.text;
        }
        if ([_eventTextField.text isEqualToString:@"羽毛球"]) {
            model.sport_item = @"1";
            
        } else if ([_eventTextField.text isEqualToString:@"足球"]) {
            model.sport_item = @"2";
        } else if ([_eventTextField.text isEqualToString:@"篮球"]) {
            model.sport_item = @"3";
        } else if ([_eventTextField.text isEqualToString:@"网球"]) {
            model.sport_item = @"4";
        } else if ([_eventTextField.text isEqualToString:@"跑步"]) {
            model.sport_item = @"5";
        } else if ([_eventTextField.text isEqualToString:@"游泳"]) {
            model.sport_item = @"6";
        } else if ([_eventTextField.text isEqualToString:@"壁球"]) {
            model.sport_item = @"7";
        } else if ([_eventTextField.text isEqualToString:@"皮划艇"]) {
            model.sport_item = @"8";
        } else if ([_eventTextField.text isEqualToString:@"棒球"]) {
            model.sport_item = @"9";
        } else if ([_eventTextField.text isEqualToString:@"乒乓"]) {
            model.sport_item = @"10";
        } else {
            model.sport_item = @"20";
            model.extend = _eventTextField.text;
        }
        model.sport_type = @"1";
        NSString *jsonStr = model.toJSONString;
        
        [[SPSportBusinessUnit shareInstance] createSportWithUserId:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"] json:jsonStr image:_addImageView.image successful:^(NSString *code, NSString *resultStr) {
            if ([code isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                
                SPCreateNextStepViewController *nextViewController = [[SPCreateNextStepViewController alloc] init];
                _sportsId = resultStr;
                nextViewController.isFirstActive = true;
                nextViewController.sportId = _sportsId;
                nextViewController.uploadImage = _addImageView.image;
                nextViewController.sportsName = _nameTextField.text;
                nextViewController.sportsLocation = _locationTextField.text;
                nextViewController.sportsEvent = _eventTextField.text;
                if (_textView.text.length == 0) {
                    nextViewController.sportsSummary = @"发起人还没有填写详情描述";
                } else {
                    nextViewController.sportsSummary = _textView.text;
                }
                
                [self.navigationController pushViewController:nextViewController animated:true];
                
                _addImageView.userInteractionEnabled = false;
                _nameTextField.userInteractionEnabled = false;
                _locationTextField.userInteractionEnabled = false;
                _eventTextField.userInteractionEnabled = false;
                _textView.userInteractionEnabled = false;
                
                _nameTextField.textColor = [SPGlobalConfig anyColorWithRed:230 green:230 blue:230 alpha:1];
                _locationTextField.textColor = [SPGlobalConfig anyColorWithRed:230 green:230 blue:230 alpha:1];
                _eventTextField.textColor = [SPGlobalConfig anyColorWithRed:230 green:230 blue:230 alpha:1];
                _textView.textColor = [SPGlobalConfig anyColorWithRed:230 green:230 blue:230 alpha:1];
                
            } else {
                NSLog(@"%@",code);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:resultStr ToView:self.view];
                });
            }
            
        } failure:^(NSString *errorString) {
            NSLog(@"%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络连接失败" ToView:self.view];
            });
        }];
    } else {
        SPCreateNextStepViewController *nextViewController = [[SPCreateNextStepViewController alloc] init];
        nextViewController.isFirstActive = true;
        nextViewController.sportId = _sportsId;
        nextViewController.uploadImage = _addImageView.image;
        nextViewController.sportsName = _nameTextField.text;
        nextViewController.sportsLocation = _locationTextField.text;
        nextViewController.sportsEvent = _eventTextField.text;
        if (_textView.text.length == 0) {
            nextViewController.sportsSummary = @"这个人很懒,还没有填写详情描述";
        } else {
            nextViewController.sportsSummary = _textView.text;
        }
        
        [self.navigationController pushViewController:nextViewController animated:true];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _nameTextField) {
        return true;
    } else if (textField == _locationTextField) {
        SPCreateLocationViewController *locationViewController = [[SPCreateLocationViewController alloc] init];
        locationViewController.delegate = self;
        [self.navigationController pushViewController:locationViewController animated:true];
        return false;
    } else if (textField == _eventTextField) {
        if (_eventShowKeyboard) {
            _eventShowKeyboard = false;
            return true;
        } else {

            if ([_nameTextField isFirstResponder]) {
                [_nameTextField resignFirstResponder];
            }
            if ([_textView isFirstResponder]) {
                [_textView resignFirstResponder];
            }
            
            if (!_windowImageView) {
                _windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _windowImageView.image = [UIImage imageNamed:@"Sports_create_windowBG"];
                _windowImageView.alpha = 0;
            }
            [self.view addSubview:_windowImageView];
            
            SPCreateEventView *selectedView = [[[NSBundle mainBundle] loadNibNamed:@"SPCreateEventView" owner:nil options:nil] lastObject];
            selectedView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            selectedView.createSportsViewController = self;
            [self.view addSubview:selectedView];
            
            [UIView animateWithDuration:0.3 animations:^{
                _windowImageView.alpha = 1;
                self.navigationController.navigationBar.alpha = 0;
                selectedView.selectedEventView.alpha = 1;
                selectedView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
            
            return false;
        }
    } else {
        return false;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"begin");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTextField) {
        [_nameTextField resignFirstResponder];
        return true;
    } else if (textField == _eventTextField) {
        [_eventTextField resignFirstResponder];
        return true;
    } else {
        return false;
    }
}

#pragma mark ResignFirstResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_nameTextField isFirstResponder]) {
        [_nameTextField resignFirstResponder];
    } else if ([_eventTextField isFirstResponder]) {
        [_eventTextField resignFirstResponder];
    }
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
    //picker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
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
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

/*
 UIImagePickerControllerMediaType // 媒体类型（kUTTypeImage、kUTTypeMovie等）
 UIImagePickerControllerOriginalImage // 原始图片
 UIImagePickerControllerEditedImage // 编辑后图片
 UIImagePickerControllerCropRect // 裁剪尺寸
 UIImagePickerControllerMediaMetadata // 拍照的元数据
 UIImagePickerControllerMediaURL // 媒体的URL
 UIImagePickerControllerReferenceURL // 引用相册的URL
 UIImagePickerControllerLivePhoto // PHLivePhoto
 info
 */

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
        
        [picker dismissViewControllerAnimated:true completion:^{
            [self presentViewController:cropViewController animated:true completion:nil];
        }];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"信息提示" message:@"选择的不是一张图片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [picker presentViewController:alertController animated:true completion:nil];
    }
}

#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController
        didCropImageToRect:(CGRect)cropRect
                     angle:(NSInteger)angle {
    
    UIImage *croppedImage = [cropViewController.image croppedImageWithFrame:cropRect angle:angle circularClip:NO];
    [cropViewController dismissViewControllerAnimated:true completion:^{
        _addImageView.image = croppedImage;
        _verfityImage = true;
    }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (_textView.text.length == 0) {
        _textPlaceHolder.hidden = true;
    }
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (_textView.text.length == 0) {
        _textPlaceHolder.hidden = false;
    } else {
        
    }
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return false;
    }
    return true;
}

#pragma mark Keyboard
- (void)keyboardAppearAction:(NSNotification *)notification {
    if ([_textView isFirstResponder]) {
        NSDictionary *userInfo = [notification userInfo];
        _keyboardHeight = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
        [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] getValue:&_animationDuration];
        _textViewFrame = _textView.frame;
        CGFloat yPosition = _textViewFrame.origin.y + 90;
        CGFloat keyboardYPosition = SCREEN_HEIGHT - _keyboardHeight;
        if (yPosition > keyboardYPosition) {
            _topDistanceConstraint.constant = - (yPosition - keyboardYPosition) - 10;
            [UIView animateWithDuration:_animationDuration animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
}

- (void)keyboardDisappearAction:(NSNotification *)notification {
    if ([_textView isFirstResponder]) {
        _topDistanceConstraint.constant = 0;
        [UIView animateWithDuration:_animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - SPSportsCreateLocationProtocol
- (void)receiveDataWithName:(NSString *)locationName
                    address:(NSString *)address
                   latitude:(NSString *)latitude
                  longitude:(NSString *)longitude {
    _locationTextField.text = locationName;
    _addressStr = address;
    _latitudeStr = latitude;
    _longitudeStr = longitude;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
