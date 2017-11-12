//
//  SPPersonalClubInfoViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/3.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalClubInfoViewController.h"

//更新俱乐部信息
#import "SPPersonalClubInfoUpdateViewController.h"

//Cell
#import "SPPersonaClubInfoSettingTableViewCell.h"

//剪裁图片
#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"

//相册服务
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

#import "SPSportBusinessUnit.h"

#import "SPClubPushPublicNoticeViewController.h"

@interface SPPersonalClubInfoViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate,SPPersonalClubInfoUpdateViewControllerProtocol,SPClubPushPublicNoticeViewControllerProtocol> {
    
    UIImageView *_header;
    
    NSInteger _updateIndex;     //1 更新封面
                                //2 更新队徽
    UIImage *_coverImage;
    UIImage *_teamImage;
    
    NSString *_clubName;
    NSString *_clubEvent;
    NSString *_clubExtend;
    NSString *_clubPublicNotice;
    
    NSString *_clubId;
    
    UIView *_footerView;
    UILabel *_publicNoticeCcontentLabel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalClubInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.automaticallyAdjustsScrollViewInsets = false;
    [self setUpTableView];
}

- (void)setUpTableView {

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    
    [self setUpTableViewHeader];
    [self setUpTableViewFooter];
}

- (void)setUpTableViewHeader {
    
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _header.image = _coverImage;
    _header.userInteractionEnabled = true;
    
    UIButton *updateCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updateCoverButton.frame = CGRectMake(SCREEN_WIDTH/2-60, SCREEN_WIDTH/2-20, 120, 40);
    updateCoverButton.titleLabel.font = [UIFont systemFontOfSize:13];
    updateCoverButton.layer.cornerRadius = 5;
    updateCoverButton.layer.masksToBounds = true;
    updateCoverButton.layer.borderWidth = 0.5;
    updateCoverButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [updateCoverButton setTitle:@"点击更换封面图片" forState:UIControlStateNormal];
    
    [updateCoverButton setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.56]];
    [updateCoverButton addTarget:self action:@selector(updateCoverButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_header addSubview:updateCoverButton];
    
    _tableView.tableHeaderView = _header;
}

- (void)setUpTableViewFooter {
    
    CGFloat width = SCREEN_WIDTH - 30;
    CGFloat height =
    [_clubPublicNotice boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                    context:nil].size.height;
    
    CGFloat footerheight = 10 + 20 + 5 + height + 10;
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, footerheight);
    _footerView = [[UIView alloc] initWithFrame:frame];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 20)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"公告";
    [_footerView addSubview:titleLabel];
    
    _publicNoticeCcontentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH-30, height)];
    _publicNoticeCcontentLabel.text = _clubPublicNotice;
    _publicNoticeCcontentLabel.font = [UIFont systemFontOfSize:14];
    _publicNoticeCcontentLabel.textColor = [SPGlobalConfig anyColorWithRed:153 green:153 blue:153 alpha:1];
    _publicNoticeCcontentLabel.numberOfLines = 0;
    [_footerView addSubview:_publicNoticeCcontentLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = _tableView.separatorColor;
    [_footerView addSubview:lineView];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, 12.5, 15, 15)];
    moreImageView.image = [UIImage imageNamed:@"Mine_More"];
    [_footerView addSubview:moreImageView];
    
    _tableView.tableFooterView = _footerView;
    
    UITapGestureRecognizer *tapPublicNotice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPublicNoticeViewAction:)];
    [_footerView addGestureRecognizer:tapPublicNotice];

}

- (void)setUpCoverImage:(UIImage *)coverImage
              teamImage:(UIImage *)teamImage
               clubName:(NSString *)clubName
              clubEvent:(NSString *)clubEvent
             clubExtend:(NSString *)clubExtend
       clubPublicNotice:(NSString *)clubPublicNotice
                 clubId:(NSString *)clubId {
    
    _clubId = clubId;
    
    _coverImage = coverImage;
    _teamImage = teamImage;
    
    _clubName = clubName;
    
    if ([clubEvent isEqualToString:@"1"]) {
        _clubEvent = @"羽毛球";
    } else if ([clubEvent isEqualToString:@"2"]) {
        _clubEvent = @"足球";
    } else if ([clubEvent isEqualToString:@"3"]) {
        _clubEvent = @"篮球";
    } else if ([clubEvent isEqualToString:@"4"]) {
        _clubEvent = @"网球";
    } else if ([clubEvent isEqualToString:@"5"]) {
        _clubEvent = @"跑步";
    } else if ([clubEvent isEqualToString:@"6"]) {
        _clubEvent = @"游泳";
    } else if ([clubEvent isEqualToString:@"7"]) {
        _clubEvent = @"壁球";
    } else if ([clubEvent isEqualToString:@"8"]) {
        _clubEvent = @"皮划艇";
    } else if ([clubEvent isEqualToString:@"9"]) {
        _clubEvent = @"棒球";
    } else if ([clubEvent isEqualToString:@"10"]) {
        _clubEvent = @"乒乓";
    } else if ([clubEvent isEqualToString:@"20"]) {
        _clubEvent = @"自定义";
        _clubExtend = clubExtend;
    } else {
        _clubEvent = @"数据有误";
    }
    _clubPublicNotice = clubPublicNotice;
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)updateCoverButtonAction:(UIButton *)sender {
    _updateIndex = 1;
    [self selectedImageAction];
}

- (void)selectedImageAction {
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

- (void)tapPublicNoticeViewAction:(UITapGestureRecognizer *)sender {
    
    SPClubPushPublicNoticeViewController *publicNoticeViewController = [[SPClubPushPublicNoticeViewController alloc] init];
    publicNoticeViewController.clubId = _clubId;
    publicNoticeViewController.viewControllerTitle = @"更新公告";
    publicNoticeViewController.delegate = self;
    [self.navigationController pushViewController:publicNoticeViewController animated:true];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonaClubInfoSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonaClubInfoSettingTableViewCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonaClubInfoSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonaClubInfoSettingTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonaClubInfoSettingTableViewCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SPPersonaClubInfoSettingTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [cell setUpCellStyle:SPPersonalClubInfoSettingTableViewCellSyleTeamImage];
        [cell setUpCellImage:_teamImage];
    } else if (indexPath.row == 1) {
        [cell setUpCellStyle:SPPersonalClubInfoSettingTableViewCellSyleClubName];
        [cell setUpCellContent:_clubName];
    } else if (indexPath.row == 2) {
        [cell setUpCellStyle:SPPersonalClubInfoSettingTableViewCellSyleClubEvent];
        if (![_clubEvent isEqualToString:@"自定义"]) {
            [cell setUpCellContent:_clubEvent];
        } else {
            [cell setUpCellContent:_clubExtend];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        _updateIndex = 2;
        [self selectedImageAction];
    } else if (indexPath.row == 1) {
        SPPersonalClubInfoUpdateViewController *updateViewController = [[SPPersonalClubInfoUpdateViewController alloc] initWithStyle:SPPersonalClubInfoUpdateViewControllerStyleUpdateClubName sourceString:_clubName clubId:_clubId];
        updateViewController.delegate = self;
        [self.navigationController pushViewController:updateViewController animated:true];
    } else if (indexPath.row == 2) {
        NSString *sourceString = nil;
        if (![_clubEvent isEqualToString:@"自定义"]) {
            sourceString = _clubEvent;
        } else {
            sourceString = _clubExtend;
        }
        
        SPPersonalClubInfoUpdateViewController *updateViewController = [[SPPersonalClubInfoUpdateViewController alloc] initWithStyle:SPPersonalClubInfoUpdateViewControllerStyleUpdateClubEvent sourceString:sourceString clubId:_clubId];
        updateViewController.delegate = self;
        [self.navigationController pushViewController:updateViewController animated:true];
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
    
    
    UIImage *croppedImage = [cropViewController.image croppedImageWithFrame:cropRect angle:angle circularClip:NO];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    if (_updateIndex == 1) {
        
        [MBProgressHUD showHUDAddedTo:cropViewController.view animated:true];
        [[SPSportBusinessUnit shareInstance] updateClubCoverWithUserId:userId clubId:_clubId coverImage:croppedImage successful:^(NSString *successsfulString) {
            [MBProgressHUD hideHUDForView:cropViewController.view animated:true];
            if ([successsfulString isEqualToString:@"successful"]) {
                _header.image = croppedImage;
                
                [cropViewController dismissViewControllerAnimated:true completion:^{
                    if ([_delegate respondsToSelector:@selector(updateClubCover:)]) {
                        [_delegate updateClubCover:croppedImage];
                    }
                }];
                
            } else {
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:cropViewController.view];
            }
            
        } failure:^(NSString *errorString) {
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:cropViewController.view];
        }];

    } else if (_updateIndex == 2) {
        
        [MBProgressHUD showHUDAddedTo:cropViewController.view animated:true];
        [[SPSportBusinessUnit shareInstance] updateClubTeamImageWithUserId:userId clubId:_clubId teamImage:croppedImage successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                SPPersonaClubInfoSettingTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                [cell setUpCellImage:croppedImage];
                
                [cropViewController dismissViewControllerAnimated:true completion:^{
                    if ([_delegate respondsToSelector:@selector(updateClubTeamImage:)]) {
                        [_delegate updateClubTeamImage:croppedImage];
                    }
                }];
                
            } else {
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:cropViewController.view];
            }
        } failure:^(NSString *errorString) {
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:cropViewController.view];
        }];
    }

}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - SPPersonalClubInfoUpdateViewControllerProtocol
- (void)finishedUpdateClubNameAction:(NSString *)clubName {
    _clubName = clubName;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    SPPersonaClubInfoSettingTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [cell setUpCellContent:_clubName];
    
    if ([_delegate respondsToSelector:@selector(updateClubName:)]) {
        [_delegate updateClubName:_clubName];
    }
}

- (void)finishedUpdateClubEventAction:(NSString *)clubEventString clubEventNum:(NSString *)clubEventNum {
    
    if ([clubEventNum isEqualToString:@"20"]) {
        _clubEvent = @"自定义";
        _clubExtend = clubEventString;
    } else {
        _clubEvent = clubEventString;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    SPPersonaClubInfoSettingTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [cell setUpCellContent:clubEventString];
    
    if ([_delegate respondsToSelector:@selector(updateClubEvent:clubEventString:)]) {
        [_delegate updateClubEvent:clubEventNum clubEventString:clubEventString];
    }
}

#pragma mark - SPClubPushPublicNoticeViewControllerProtocol
- (void)updatePublicNotice:(NSString *)publicNotice {
    _clubPublicNotice = publicNotice;
    
    CGFloat width = SCREEN_WIDTH - 30;
    CGFloat height =
    [_clubPublicNotice boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                    context:nil].size.height;
    
    CGFloat footerheight = 10 + 20 + 5 + height + 10;
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, footerheight);
    _footerView.frame = frame;
    
    _publicNoticeCcontentLabel.frame = CGRectMake(15, 35, SCREEN_WIDTH-30, height);
    _publicNoticeCcontentLabel.text = publicNotice;
    
    _tableView.tableFooterView = _footerView;
    
    if ([_delegate respondsToSelector:@selector(updateClubPublicNotice:)]) {
        [_delegate updateClubPublicNotice:publicNotice];
    }
}

@end
