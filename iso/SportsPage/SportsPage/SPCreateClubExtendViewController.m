//
//  SPCreateClubExtendViewController.m
//  SportsPage
//
//  Created by Qin on 2017/2/17.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPCreateClubExtendViewController.h"

#import "SPClubPushPublicNoticeViewController.h"

#import "SPSportBusinessUnit.h"

//剪裁图片
#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"

//相册服务
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "MBProgressHUD.h"

@interface SPCreateClubExtendViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate> {
    BOOL _verfityImage;
    
    NSString *_retClubId;
}

@property (weak, nonatomic) IBOutlet UIImageView *clubCoverImageView;
@property (weak, nonatomic) IBOutlet UIButton *createClubNextButton;

@end

@implementation SPCreateClubExtendViewController

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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImageAction:)];
    [_clubCoverImageView addGestureRecognizer:tapGesture];
    _clubCoverImageView.userInteractionEnabled = true;
    
    _createClubNextButton.layer.cornerRadius = 5;
    _createClubNextButton.layer.masksToBounds = true;
    [_createClubNextButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_createClubNextButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)selectImageAction:(UITapGestureRecognizer *)sender {
    
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

    if (_clubCoverImageView.userInteractionEnabled) {
        if (!_verfityImage) {
            [SPGlobalConfig showTextOfHUD:@"请上传俱乐部封面" ToView:self.view];
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        
        NSString *sportItem = nil;
        NSString *extend = nil;
        
        if ([_clubEvent isEqualToString:@"羽毛球"]) {
            sportItem = @"1";
        } else if ([_clubEvent isEqualToString:@"足球"]) {
            sportItem = @"2";
        } else if ([_clubEvent isEqualToString:@"篮球"]) {
            sportItem = @"3";
        } else if ([_clubEvent isEqualToString:@"网球"]) {
            sportItem = @"4";
        } else if ([_clubEvent isEqualToString:@"跑步"]) {
            sportItem = @"5";
        } else if ([_clubEvent isEqualToString:@"游泳"]) {
            sportItem = @"6";
        } else if ([_clubEvent isEqualToString:@"壁球"]) {
            sportItem = @"7";
        } else if ([_clubEvent isEqualToString:@"皮划艇"]) {
            sportItem = @"8";
        } else if ([_clubEvent isEqualToString:@"棒球"]) {
            sportItem = @"9";
        } else if ([_clubEvent isEqualToString:@"乒乓"]) {
            sportItem = @"10";
        } else {
            sportItem = @"20";
            extend = _clubEvent;
        }
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        
        [[SPSportBusinessUnit shareInstance] createClubWithUserId:userId name:_clubName description:nil sportItem:sportItem capacity:nil type:nil extend:extend iconImage:_clubTeamIconImage coverImage:_clubCoverImageView.image successful:^(NSString *code, NSString *resultString) {
            if ([code isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                SPClubPushPublicNoticeViewController *pushPublicNoticeViewController = [[SPClubPushPublicNoticeViewController alloc] init];
                pushPublicNoticeViewController.clubId = resultString;
                pushPublicNoticeViewController.viewControllerTitle = @"发布第一条公告";
                [self.navigationController pushViewController:pushPublicNoticeViewController animated:true];
                
                _clubCoverImageView.userInteractionEnabled = false;
                _retClubId = resultString;
                
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:resultString ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
    } else {
        SPClubPushPublicNoticeViewController *pushPublicNoticeViewController = [[SPClubPushPublicNoticeViewController alloc] init];
        pushPublicNoticeViewController.clubId = _retClubId;
        pushPublicNoticeViewController.viewControllerTitle = @"发布第一条公告";
        [self.navigationController pushViewController:pushPublicNoticeViewController animated:true];
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
        _clubCoverImageView.image = croppedImage;
        _verfityImage = true;
    }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:true completion:nil];
}

@end
