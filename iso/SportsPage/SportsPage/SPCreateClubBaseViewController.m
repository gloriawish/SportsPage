//
//  SPCreateClubBaseViewController.m
//  SportsPage
//
//  Created by Qin on 2017/2/17.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPCreateClubBaseViewController.h"

//创建俱乐部ViewController2
#import "SPCreateClubExtendViewController.h"

//EventView
#import "SPCreateSportsPageEventView.h"

//剪裁图片
#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"

//相册服务
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SPCreateClubBaseViewController () <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate,SPCreateSportsPageEventViewProtocol> {
    BOOL _verfityImage;
    
    BOOL _showEventKeyBoard;
    
    //Window
    UIImageView *_windowImageView;
    //View
    SPCreateSportsPageEventView *_createSportsPageEventView;
}

@property (weak, nonatomic) IBOutlet UIImageView *clubTeamImageView;

@property (weak, nonatomic) IBOutlet UIView *clubNameView;
@property (weak, nonatomic) IBOutlet UITextField *clubNameTextField;

@property (weak, nonatomic) IBOutlet UIView *clubEventView;
@property (weak, nonatomic) IBOutlet UITextField *clubEventTextField;


@property (weak, nonatomic) IBOutlet UIButton *createClubNextButton;

@end

@implementation SPCreateClubBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - SetUp
- (void)setUp {
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
    
    _clubTeamImageView.layer.cornerRadius = 10;
    _clubTeamImageView.layer.masksToBounds = true;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImageAction:)];
    [_clubTeamImageView addGestureRecognizer:tapGesture];
    _clubTeamImageView.userInteractionEnabled = true;
    
    _clubNameView.layer.cornerRadius = 5;
    _clubNameView.layer.masksToBounds = true;
    
    _clubEventView.layer.cornerRadius = 5;
    _clubEventView.layer.masksToBounds = true;
    
    _createClubNextButton.layer.cornerRadius = 5;
    _createClubNextButton.layer.masksToBounds = true;
    [_createClubNextButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_createClubNextButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
    _clubNameTextField.delegate = self;
    _clubEventTextField.delegate = self;
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)selectImageAction:(UITapGestureRecognizer *)sender {
    if ([_clubNameTextField isFirstResponder]) {
        [_clubNameTextField resignFirstResponder];
    } else if ([_clubEventTextField isFirstResponder]) {
        [_clubEventTextField resignFirstResponder];
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

- (IBAction)createClubNextButtonAction:(id)sender {
    
    if (_clubNameTextField.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"请输入俱乐部名称" ToView:self.view];
        return;
    }
    
    if (_clubEventTextField.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"请选择运动类型" ToView:self.view];
        return;
    }
    
    if (!_verfityImage) {
        [SPGlobalConfig showTextOfHUD:@"请上传俱乐部徽章" ToView:self.view];
        return;
    }
    
    SPCreateClubExtendViewController *createClubExtentViewController = [[SPCreateClubExtendViewController alloc] init];
    createClubExtentViewController.clubTeamIconImage = _clubTeamImageView.image;
    createClubExtentViewController.clubName = _clubNameTextField.text;
    createClubExtentViewController.clubEvent = _clubEventTextField.text;
    [self.navigationController pushViewController:createClubExtentViewController animated:true];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField != _clubEventTextField) {
        return true;
    } else {
        if (!_showEventKeyBoard) {
            
            if ([_clubNameTextField isFirstResponder]) {
                [_clubNameTextField resignFirstResponder];
            }
            
            if (!_windowImageView) {
                _windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _windowImageView.image = [UIImage imageNamed:@"Sports_create_windowBG"];
                _windowImageView.alpha = 0;
            }
            [self.view addSubview:_windowImageView];
            
            if (!_createSportsPageEventView) {
                _createSportsPageEventView = [[[NSBundle mainBundle] loadNibNamed:@"SPCreateSportsPageEventView" owner:nil options:nil] lastObject];
                _createSportsPageEventView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                _createSportsPageEventView.delegate = self;
            }
            [self.view addSubview:_createSportsPageEventView];
            
            [UIView animateWithDuration:0.3 animations:^{
                _windowImageView.alpha = 1;
                _createSportsPageEventView.eventView.alpha = 1;
                _createSportsPageEventView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
            
            return false;
        } else {
            _showEventKeyBoard = false;
            return true;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = (UIImage *)info[@"UIImagePickerControllerOriginalImage"];
        
        TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
        cropViewController.delegate = self;
        cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        cropViewController.aspectRatioLockEnabled = true;
        cropViewController.aspectRatioPickerButtonHidden = true;
        cropViewController.resetAspectRatioEnabled = false;
        
        [picker dismissViewControllerAnimated:true completion:^{
            [self presentViewController:cropViewController animated:true completion:nil];
        }];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"您选择的不是一张图片" preferredStyle:UIAlertControllerStyleAlert];
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
        _clubTeamImageView.image = croppedImage;
        _verfityImage = true;
    }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - SPCreateSportsPageEventViewProtocol
- (void)receivedContentString:(NSString *)string {
    
    [UIView animateWithDuration:0.5 animations:^{
        _windowImageView.alpha = 0;
        _createSportsPageEventView.eventView.alpha = 0;
        _createSportsPageEventView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        _windowImageView.alpha = 1;
        [_windowImageView removeFromSuperview];
        _createSportsPageEventView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_createSportsPageEventView removeFromSuperview];
    }];
    
    if ([string isEqualToString:@"自定义"]) {
        _showEventKeyBoard = true;
        [_clubEventTextField becomeFirstResponder];
    } else if ([string isEqualToString:@"取消"]) {
        
    } else {
        _clubEventTextField.text = string;
    }
}

#pragma mark - TouchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_clubEventTextField isFirstResponder]) {
        [_clubEventTextField resignFirstResponder];
    } else if ([_clubNameTextField isFirstResponder]) {
        [_clubNameTextField resignFirstResponder];
    }
}

@end
