//
//  SPSportsPageViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsPageViewController.h"
#import "SPSportsPageHotViewController.h"
#import "SPSportsPageFocusViewController.h"

#import "SPCreateSportsViewController.h"
#import "SPSportsPageActiveViewController.h"

#import "SPSportsNotificationViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

#import "FFDropDownMenuView.h"

@interface SPSportsPageViewController () <UIGestureRecognizerDelegate,CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
    AppDelegate *_appDelegate;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;


@property (weak, nonatomic) IBOutlet UIButton *createSportsEventButton;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;

@property (nonatomic, strong) FFDropDownMenuView *dropDownMenu;

@end

@implementation SPSportsPageViewController

- (void)defaultController {
    self.pageAnimatable = true;
    self.showOnNavigationBar = true;
}

- (void)viewDidLoad {
    [self defaultController];
    [super viewDidLoad];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpLocationManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPORTS_MAIN_CHANGE_TITLE object:nil];
}

#pragma mark - SetUp
- (void)setUp {
    [self setUpNav];
    [self setUpSegmentedControl];
    [self setUpLocationAuth];
    
    [_createSportsEventButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_notificationButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTitleView:) name:NOTIFICATION_SPORTS_MAIN_CHANGE_TITLE object:nil];
}

- (void)setUpNav {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)setUpSegmentedControl {
    [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}
                                     forState:UIControlStateNormal];
    [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}
                                     forState:UIControlStateSelected];
    [_segmentedControl setTintColor:[UIColor whiteColor]];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.layer.cornerRadius = 5;
    _segmentedControl.layer.masksToBounds = true;
    _segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    _segmentedControl.layer.borderWidth = 1.5;
    [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)setUpLocationAuth {
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            _locationManager = [[CLLocationManager alloc] init];
            [_locationManager requestWhenInUseAuthorization];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = 10;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        } else if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
            NSString *title = [NSString stringWithFormat:@"运动页还没有获取定位权限\n快去设置吧"];
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
    }
}

- (void)setUpLocationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 10;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [_locationManager startUpdatingLocation];
}

#pragma mark - Action
- (IBAction)createSportsEventAction:(id)sender {

    NSArray *menuModelsArr = [self getDropDownMenuModelsArray];
    self.dropDownMenu = [FFDropDownMenuView new];
    /** 下拉菜单模型数组 */
    self.dropDownMenu.menuModelsArray = menuModelsArr;
    /** cell的类名 */
    self.dropDownMenu.cellClassName = FFDefaultCell;
    /** 菜单的宽度(若不设置，默认为 150) */
    self.dropDownMenu.menuWidth = 123;
    /** 菜单的圆角半径(若不设置，默认为5) */
    self.dropDownMenu.menuCornerRadius = FFDefaultFloat;
    /** 每一个选项的高度(若不设置，默认为40) */
    self.dropDownMenu.eachMenuItemHeight = 45;
    /** 菜单条离屏幕右边的间距(若不设置，默认为10) */
    self.dropDownMenu.menuRightMargin = 10;
    /** 三角形颜色(若不设置，默认为白色) */
    self.dropDownMenu.triangleColor = [UIColor whiteColor];
    /** 三角形相对于keyWindow的y值,也就是相对于屏幕顶部的y值(若不设置，默认为64) */
    self.dropDownMenu.triangleY = FFDefaultFloat;
    /** 三角形距离屏幕右边的间距(若不设置，默认为20) */
    self.dropDownMenu.triangleRightMargin = FFDefaultFloat;
    /** 三角形的size  size.width:代表三角形底部边长，size.Height:代表三角形的高度(若不设置，默认为CGSizeMake(15, 10)) */
    self.dropDownMenu.triangleSize = FFDefaultSize;
    /** 背景颜色开始时的透明度(还没展示menu的透明度)(若不设置，默认为0.02) */
    self.dropDownMenu.bgColorbeginAlpha = 0;
    /** 背景颜色结束的的透明度(menu完全展示的透明度)(若不设置，默认为0.2) */
    self.dropDownMenu.bgColorEndAlpha = 0.4;
    /** 动画效果时间(若不设置，默认为0.2) */
    self.dropDownMenu.animateDuration = FFDefaultFloat;
    /** 菜单的伸缩类型 */
    //self.dropDownMenu.menuScaleType = FFDefaultMenuScaleType;
    [self.dropDownMenu setup];
    [self.dropDownMenu showMenu];
   
}

- (NSArray *)getDropDownMenuModelsArray {
    __weak SPSportsPageViewController *weakSelf = self;
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"创建运动页" menuItemIconName:@"Sports_main_createSport_create" menuBlock:^{
        SPCreateSportsViewController *createSportsViewController = [[SPCreateSportsViewController alloc] init];
        createSportsViewController.hidesBottomBarWhenPushed = true;
        [weakSelf.navigationController pushViewController:createSportsViewController animated:true];
    }];
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"激活运动页" menuItemIconName:@"Sports_main_createSport_active" menuBlock:^{
        SPSportsPageActiveViewController *activeSportsViewController = [[SPSportsPageActiveViewController alloc] init];
        activeSportsViewController.hidesBottomBarWhenPushed = true;
        [weakSelf.navigationController pushViewController:activeSportsViewController animated:true];
    }];
    NSArray *menuModelArr = @[menuModel0, menuModel1];
    return menuModelArr;
}

- (IBAction)notificationButtonAction:(UIButton *)sender {
    SPSportsNotificationViewController *notificationViewController = [[SPSportsNotificationViewController alloc] init];
    notificationViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:notificationViewController animated:true];
}


- (void)segmentedControlAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.selectIndex = 0;
    } else if (sender.selectedSegmentIndex == 1) {
        self.selectIndex = 1;
    }
}

- (void)changeTitleView:(NSNotification *)notification {
    NSString *actionStr = notification.userInfo[@"action"];
    if ([actionStr isEqualToString:@"presentSearchController"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _segmentedControl.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _searchLabel.alpha = 1;
            }];
        }];
    } else if ([actionStr isEqualToString:@"dismissSearchController"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _searchLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _segmentedControl.alpha = 1;
            }];
        }];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        return false;
    }
    return true;
}

#pragma mark - WMPageControllerDelegate
- (void)pageController:(WMPageController * _Nonnull)pageController didEnterViewController:(__kindof UIViewController * _Nonnull)viewController withInfo:(NSDictionary * _Nonnull)info {
    if (_segmentedControl.selectedSegmentIndex == 1 && [viewController isMemberOfClass:[SPSportsPageHotViewController class]]) {
        _segmentedControl.selectedSegmentIndex = 0;
    } else if (_segmentedControl.selectedSegmentIndex == 0 && [viewController isMemberOfClass:[SPSportsPageFocusViewController class]]) {
        _segmentedControl.selectedSegmentIndex = 1;
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NSLog(@"1");
    if (index == 0) {
        SPSportsPageHotViewController *hotViewController = [[SPSportsPageHotViewController alloc] init];
        hotViewController.pageViewController = self;
        return hotViewController;
    } else {
        SPSportsPageFocusViewController *focusViewController = [[SPSportsPageFocusViewController alloc] init];
        focusViewController.pageViewController = self;
        return focusViewController;
    }
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"热门";
    } else {
        return @"关注";
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray <CLLocation *>*)locations {
    NSLog(@"获取定位成功");
    CLLocation *location = locations.lastObject;
    _appDelegate.longitude = location.coordinate.longitude;
    _appDelegate.latitude = location.coordinate.latitude;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位获取失败:%@",error.localizedDescription);
    _appDelegate.longitude = 999;
    _appDelegate.latitude = 999;
}

@end
