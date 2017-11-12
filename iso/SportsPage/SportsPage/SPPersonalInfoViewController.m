//
//  SPPersonalInfoViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/14.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalInfoViewController.h"
#import "SPPersonalInfoSettingViewController.h"
#import "SPPersonalInfoTableViewCell.h"

#import "SPPersonalInputViewController.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "SPUserBusinessUnit.h"
#import "SPAuthBusinessUnit.h"

#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

@interface SPPersonalInfoViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate,WXApiManagerDelegate> {
    UIImageView *_headImageView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUpUI {
    [WXApiManager sharedManager].delegate = self;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2*SCREEN_WIDTH/5)];
    headerView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _headImageView.center = CGPointMake(headerView.center.x, headerView.center.y-5);
    _headImageView.userInteractionEnabled = true;
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImageViewAction:)];
    [_headImageView addGestureRecognizer:tapGesture];
    [headerView addSubview:_headImageView];
    _headImageView.layer.cornerRadius = 50;
    _headImageView.layer.masksToBounds = true;
    if (_userInfoModel.portrait.length == 0) {
        _headImageView.image = [UIImage imageNamed:@"Mine_headerImageView"];
    } else {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.portrait] placeholderImage:[UIImage imageNamed:@"Mine_headerImageView"]];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _headImageView.frame.origin.y+105, SCREEN_WIDTH, 10)];
    label.font = [UIFont systemFontOfSize:9];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点击修改头像";
    [headerView addSubview:label];
    
    _tableView.tableHeaderView = headerView;
}

#pragma mark - Action
- (IBAction)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)tapHeadImageViewAction:(UITapGestureRecognizer *)sender {
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalInfoCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imageNameStr = nil;
    NSString *titleStr = nil;
    NSString *contentStr = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            imageNameStr = @"Mine_personal_username";
            titleStr = @"用户名";
            contentStr = _userInfoModel.uname;
            ((SPPersonalInfoTableViewCell *)cell).moreImageView.hidden = true;
            cell.userInteractionEnabled = false;
        } else if (indexPath.row == 1) {
            imageNameStr = @"Mine_personal_nick";
            titleStr = @"昵称";
            if (_userInfoModel.nick.length == 0) {
                contentStr = @"未填写";
            } else {
                contentStr = _userInfoModel.nick;
            }
        } else if (indexPath.row == 2) {
            imageNameStr = @"Mine_personal_sex";
            titleStr = @"性别";
            if ([_userInfoModel.sex isEqualToString:@"保密"]) {
                contentStr = @"未填写";
            } else {
                contentStr = _userInfoModel.sex;
            }
            ((SPPersonalInfoTableViewCell *)cell).lineView.hidden = true;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            imageNameStr = @"Mine_personal_mobile";
            titleStr = @"手机号";
            if (_userInfoModel.mobile.length == 0) {
                contentStr = @"未绑定";
            } else {
                contentStr = @"已绑定";
                ((SPPersonalInfoTableViewCell *)cell).moreImageView.hidden = true;
                cell.userInteractionEnabled = false;
            }
        } else if (indexPath.row == 1) {
            imageNameStr = @"Mine_personal_wechat";
            titleStr = @"微信";
            
            if ([WXApi isWXAppInstalled]) {
                if (_userInfoModel.unionid.length == 0) {
                    contentStr = @"未绑定";
                } else {
                    contentStr = @"已绑定";
                    ((SPPersonalInfoTableViewCell *)cell).moreImageView.hidden = true;
                    cell.userInteractionEnabled = false;
                }
            } else {
                contentStr = @"未安装微信";
                ((SPPersonalInfoTableViewCell *)cell).moreImageView.hidden = true;
                cell.userInteractionEnabled = false;
            }
        } else if (indexPath.row == 2) {
            imageNameStr = @"Mine_personal_email";
            titleStr = @"邮箱";
            if (_userInfoModel.email.length == 0) {
                contentStr = @"未填写";
            } else {
                contentStr = _userInfoModel.email;
            }
            ((SPPersonalInfoTableViewCell *)cell).lineView.hidden = true;
        }
    } else {
        if (indexPath.row == 0) {
            imageNameStr = @"Mine_personal_address";
            titleStr = @"地址";
            NSString *temp = [NSString stringWithFormat:@"%@ %@",_userInfoModel.city,_userInfoModel.area];
            if (temp.length == 1) {
                contentStr = @"未填写";
            } else {
                contentStr = temp;
            }
        }
//        else {
//            imageNameStr = @"Mine_personal_nameConfirm";
//            titleStr = @"实名认证";
//            
//            if ([_userInfoModel.valid isEqualToString:@"1"]) {
//                contentStr = @"未认证";
//            } else if ([_userInfoModel.valid isEqualToString:@"2"]) {
//                contentStr = @"认证中";
//                ((SPPersonalInfoTableViewCell *)cell).moreImageView.hidden = true;
//                cell.userInteractionEnabled = false;
//            } else if ([_userInfoModel.valid isEqualToString:@"3"]) {
//                contentStr = @"已认证";
//                ((SPPersonalInfoTableViewCell *)cell).moreImageView.hidden = true;
//                cell.userInteractionEnabled = false;
//            }
//            ((SPPersonalInfoTableViewCell *)cell).lineView.hidden = true;
//        }
    }
    [((SPPersonalInfoTableViewCell *)cell) setUpWithTitle:titleStr content:contentStr imageName:imageNameStr];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 15)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    return view;
//    if (section == 0 || section == 1) {
//        
//    } else {
//        return nil;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 15;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            SPPersonalInputViewController *inputViewController = [[SPPersonalInputViewController alloc] init];
            inputViewController.navTitleStr = @"昵称设置";
            SPPersonalInfoTableViewCell *cell = (SPPersonalInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            inputViewController.contentStr = cell.contentLabel.text;
            inputViewController.personalInfoCell = cell;
            [self.navigationController pushViewController:inputViewController animated:true];
        } else if (indexPath.row == 2) {
            SPPersonalInputViewController *inputViewController = [[SPPersonalInputViewController alloc] init];
            inputViewController.navTitleStr = @"性别设置";
            inputViewController.personalInfoCell = (SPPersonalInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self.navigationController pushViewController:inputViewController animated:true];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            SPPersonalInputViewController *inputViewController = [[SPPersonalInputViewController alloc] init];
            inputViewController.navTitleStr = @"手机绑定";
            inputViewController.personalInfoCell = (SPPersonalInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self.navigationController pushViewController:inputViewController animated:true];
        } else if (indexPath.row == 1) {
            if ([WXApi isWXAppInstalled]) {
                [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo"
                                                    State:@"sportspage"
                                                   OpenID:@""
                                         InViewController:self];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有安装微信" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:true completion:nil];
            }
        } else {
            SPPersonalInputViewController *inputViewController = [[SPPersonalInputViewController alloc] init];
            inputViewController.navTitleStr = @"邮箱设置";
            SPPersonalInfoTableViewCell *cell = (SPPersonalInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            inputViewController.contentStr = cell.contentLabel.text;
            inputViewController.personalInfoCell = cell;
            [self.navigationController pushViewController:inputViewController animated:true];
        }
    } else {
        if (indexPath.row == 0) {
            SPPersonalInfoSettingViewController *personalInfoSettingViewController = [[SPPersonalInfoSettingViewController alloc] init];
            personalInfoSettingViewController.personalInfoCell = [tableView cellForRowAtIndexPath:indexPath];
            [self.navigationController pushViewController:personalInfoSettingViewController animated:true];
        }
//        else {
//            SPPersonalInputViewController *inputViewController = [[SPPersonalInputViewController alloc] init];
//            inputViewController.navTitleStr = @"实名认证";
//            inputViewController.personalInfoCell = (SPPersonalInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//            [self.navigationController pushViewController:inputViewController animated:true];
//        }
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
        cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    UIImage *croppedImage = [cropViewController.image croppedImageWithFrame:cropRect angle:angle circularClip:NO];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPUserBusinessUnit shareInstance] updatePortraitWithUserId:userId image:croppedImage successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [cropViewController dismissViewControllerAnimated:true completion:^{
                _headImageView.image = croppedImage;
            }];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        NSLog(@"%@",errorString);
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    if(response.errCode == 0) {
        NSLog(@"用户同意授权");
        [self getAccesToken:response.code];
    } else if(response.errCode == -2) {
        NSLog(@"用户取消授权");
    } else if(response.errCode == -4) {
        NSLog(@"用户拒绝授权");
    } else {
        NSLog(@"todo");
    }
}

-(void)getAccesToken:(NSString *)code {
    NSString* base = @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code";
    NSString *url =[NSString stringWithFormat:base,KEY_WEIXIN,KEY_SECRET,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *access_token = [dic objectForKey:@"access_token"];
                NSString *openid = [dic objectForKey:@"openid"];
                NSString *unionid = dic[@"unionid"];
                [self getUserInfo:access_token withOpenId:openid withUnionId:unionid];
            }
        });
    });
}

//通过AccessToken获取用户信息
-(void)getUserInfo:(NSString *)access_token withOpenId:(NSString *)openid withUnionId:(NSString *)unionid {
    NSString* base = @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@";
    NSString *url =[NSString stringWithFormat:base,access_token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *jsonStr = [self DataTOjsonString:dic];
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                [[SPAuthBusinessUnit shareInstance] addWxclientWithJsonStr:jsonStr openid:openid successful:^(NSString *successsfulString) {
                    if ([successsfulString isEqualToString:@"200"]) {
                        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
                        [[SPUserBusinessUnit shareInstance] bindWexinWithUserId:userId openId:openid unionid:unionid successful:^(NSString *successsfulString) {
                            if ([successsfulString isEqualToString:@"successful"]) {
                                NSLog(@"绑定成功");
                                [MBProgressHUD hideHUDForView:self.view animated:true];
                                SPPersonalInfoTableViewCell *cell = (SPPersonalInfoTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                                cell.contentLabel.text = @"已绑定";
                                cell.moreImageView.hidden = true;
                                cell.userInteractionEnabled = false;
                            } else {
                                [MBProgressHUD hideHUDForView:self.view animated:true];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                                });
                            }
                        } failure:^(NSString *errorString) {
                            NSLog(@"bindWechat AFN ERROR:%@",errorString);
                            [MBProgressHUD hideHUDForView:self.view animated:true];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                            });
                        }];
                    } else {
                        NSLog(@"%@",successsfulString);
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                        });
                    }
                } failure:^(NSString *errorString) {
                    NSLog(@"addWxclientWithJsonStr AFN ERROR");
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                    });
                }];
                
            }
        });
    });
}

- (NSString*)DataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
