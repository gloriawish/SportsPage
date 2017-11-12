//
//  SPSportsPageBaseViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/14.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsPageBaseViewController.h"

#import "SPSportBusinessUnit.h"
#import "SPSportsPageBaseModel.h"

#import "MBProgressHUD.h"
#import "JZLocationConverter.h"
#import "UIImageView+WebCache.h"

#import "AppDelegate.h"
#import "SPCreateNextStepViewController.h"

@interface SPSportsPageBaseViewController () {
    SPSportsPageBaseModel *_sportPageModel;
    UIButton *_activeButton;
    BOOL _isSelfCreate;
    NSString *_activeTimesStr;
}

@property (weak, nonatomic) IBOutlet UIImageView *navBarImageView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *initiateView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *initiateImageView;

@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@property (weak, nonatomic) IBOutlet UIView *eventDetailLineView;

@property (weak, nonatomic) IBOutlet UILabel *eventDetailLabel;

@end

@implementation SPSportsPageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkRequest];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)updateViewConstraints {
    CGFloat fixedHeight = SCREEN_WIDTH*9/16 + 330 + 240;
    _scrollViewHeightConstraint.constant = fixedHeight;
    [super updateViewConstraints];
}

#pragma mark - Observes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat yPosition = [(NSValue *)change[@"new"] CGPointValue].y;
        if (yPosition <= 0) {
            _navBarImageView.alpha = 1;
            _navBarView.alpha = 0;
        } else if (yPosition > 0 && yPosition <= 64) {
            _navBarImageView.alpha = 1-yPosition/64;
            _navBarView.alpha = yPosition/64;
        } else {
            _navBarImageView.alpha = 0;
            _navBarView.alpha = 1;
        }
    }
}

#pragma mark - Request
- (void)networkRequest {
    _activeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _activeButton.hidden = true;
    
    _scrollView.hidden = true;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] getSportWithSportId:_sportId userId:userId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            _sportPageModel = (SPSportsPageBaseModel *)jsonModel;
            [self scrollViewReload];
        } else {
            NSLog(@"%@",successsfulString);
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

#pragma mark - SetUp
- (void)setUp {
    [self setUpNav];
    [self setUpScrollView];
    [self setUpUI];
}

- (void)setUpNav {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    _navBarView.backgroundColor = [SPGlobalConfig anyColorWithRed:88 green:87 blue:86 alpha:0.9];
    _navBarView.alpha = 0;
}

- (void)setUpScrollView {
    _focusButton.layer.cornerRadius = 6;
    _focusButton.layer.masksToBounds = true;
    
    _eventDetailLineView.backgroundColor = [SPGlobalConfig themeColor];
    
    [self addGestureWithImageView:_locationView SEL:@selector(tapLocationAction:)];
    [self addGestureWithImageView:_initiateImageView SEL:@selector(tapTelophoneAction:)];
}

- (void)addGestureWithImageView:(UIView *)sender SEL:(SEL)sel {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    sender.userInteractionEnabled = true;
    [sender addGestureRecognizer:tapGesture];
}

- (void)setUpUI {
    [self setUpButtonWithButton:_activeButton
                          frame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)
                backgroundColor:[SPGlobalConfig anyColorWithRed:24 green:155 blue:250 alpha:1]
                       fontSize:16
                       norTitle:@"马上激活"
                  norTitleColor:[UIColor whiteColor]
            highlightTitleColor:[UIColor lightGrayColor]
                      imageName:@"Sports_signup_nor"
                     edgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)
                       selector:@selector(activeButtonAction:)];
}

- (void)setUpButtonWithButton:(UIButton *)sender
                        frame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor
                     fontSize:(NSInteger)fontSize
                     norTitle:(NSString *)title
                norTitleColor:(UIColor *)norTitleColor
          highlightTitleColor:(UIColor *)highlightTitleColor
                    imageName:(NSString *)imageName
                   edgeInsets:(UIEdgeInsets)edgeInsets
                     selector:(SEL)selector {

    sender.frame = frame;
    sender.backgroundColor = backgroundColor;
    sender.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:norTitleColor forState:UIControlStateNormal];
    [sender setTitleColor:highlightTitleColor forState:UIControlStateHighlighted];
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [sender setImageEdgeInsets:edgeInsets];
    [sender addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender];
}

- (void)scrollViewReload {
    //顶部图片
    if (_sportPageModel.portrait.length != 0) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_sportPageModel.portrait]
                          placeholderImage:[UIImage imageNamed:@"Sports_main_mask"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"Sports_main_mask"];
    }
    
    //标题
    if (_sportPageModel.title.length != 0) {
        _titleLabel.text = _sportPageModel.title;
    } else {
        _titleLabel.text = @"";
    }
    
    //评星
    NSString *gradeStr = nil;
    if (_sportPageModel.grade.length != 0) {
        if ([_sportPageModel.grade isEqualToString:@"0"]) {
            gradeStr = @"Sports_star_0.5";
        } else {
            gradeStr = [NSString stringWithFormat:@"Sports_star_%@",_sportPageModel.grade];
        }
    } else {
        gradeStr = @"Sports_star_4";
    }
    _starImageView.image = [UIImage imageNamed:gradeStr];
    
    //关注按钮
    if ([_sportPageModel.attetion isEqualToString:@"0"]) {
        [_focusButton setBackgroundColor:[SPGlobalConfig anyColorWithRed:24 green:155 blue:250 alpha:1]];
        [_focusButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    } else {
        [_focusButton setBackgroundColor:[UIColor grayColor]];
        [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        _focusButton.userInteractionEnabled = false;
    }
    
    //场馆名称
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *latitude = _sportPageModel.latitude;
    NSString *longitude = _sportPageModel.longitude;
    NSString *distanceStr = nil;
    if ([latitude isEqualToString:@"999"] && [longitude isEqualToString:@"999"]) {
        distanceStr = @"";
    } else {
        CLLocation *locationNow = [[CLLocation alloc] initWithLatitude:delegate.latitude longitude:delegate.longitude];
        double distance = [locationNow distanceFromLocation:[[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]]]/1000.0;
        distanceStr = [NSString stringWithFormat:@"(%.1fkm)",distance];
    }
    
    if (_sportPageModel.place.length != 0) {
        _locationLabel.text = [NSString stringWithFormat:@"场地描述: %@%@",_sportPageModel.place,distanceStr];
    } else {
        _locationLabel.text = @"场地描述: 发起人还没有填写场地描述";
    }
    
    //场馆地址
    if (_sportPageModel.location.length != 0) {
        _addressLabel.text = _sportPageModel.location;
    } else {
        _addressLabel.text = @"地址待定";
    }
    
    //发起人
    if (_sportPageModel.user_id.nick.length != 0) {
        _nameLabel.text = _sportPageModel.user_id.nick;
    } else {
        _nameLabel.text = _sportPageModel.user_id.uname;
    }
    
    //运动项目&图标
    NSString *contentStr = nil;
    NSString *imageStr = nil;
    if ([_sportPageModel.sport_item isEqualToString:@"1"]) {
        contentStr = @"羽毛球";
        imageStr = @"Sports_event_badminton";
    } else if ([_sportPageModel.sport_item isEqualToString:@"2"]) {
        contentStr = @"足球";
        imageStr = @"Sports_event_football";
    } else if ([_sportPageModel.sport_item isEqualToString:@"3"]) {
        contentStr = @"篮球";
        imageStr = @"Sports_event_basketball";
    } else if ([_sportPageModel.sport_item isEqualToString:@"4"]) {
        contentStr = @"网球";
        imageStr = @"Sports_event_tennis";
    } else if ([_sportPageModel.sport_item isEqualToString:@"5"]) {
        contentStr = @"跑步";
        imageStr = @"Sports_event_jogging";
    } else if ([_sportPageModel.sport_item isEqualToString:@"6"]) {
        contentStr = @"游泳";
        imageStr = @"Sports_event_swimming";
    } else if ([_sportPageModel.sport_item isEqualToString:@"7"]) {
        contentStr = @"壁球";
        imageStr = @"Sports_event_squash";
    } else if ([_sportPageModel.sport_item isEqualToString:@"8"]) {
        contentStr = @"皮划艇";
        imageStr = @"Sports_event_kayak";
    } else if ([_sportPageModel.sport_item isEqualToString:@"9"]) {
        contentStr = @"棒球";
        imageStr = @"Sports_event_baseball";
    } else if ([_sportPageModel.sport_item isEqualToString:@"10"]) {
        contentStr = @"乒乓";
        imageStr = @"Sports_event_pingpang";
    } else if ([_sportPageModel.sport_item isEqualToString:@"20"]) {
        contentStr = _sportPageModel.extend;
        imageStr = @"Sports_event_custom";
    }
    _eventLabel.text = contentStr;
    _eventImageView.image = [UIImage imageNamed:imageStr];
    
    //活动详情
    if (_sportPageModel.summary.length != 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        CGSize size = [_sportPageModel.summary boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                      NSParagraphStyleAttributeName:paragraphStyle}
                                                            context:nil].size;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_sportPageModel.summary];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_sportPageModel.summary length])];
        _eventDetailLabel.attributedText = attributedString;
        _eventDetailLabel.text = _sportPageModel.summary;
        CGFloat changeHeight = size.height + 5;
        if (changeHeight > 240) {
            _scrollViewHeightConstraint.constant = SCREEN_WIDTH*9/16 + 330 + changeHeight;
        }
    } else {
        _eventDetailLabel.text = @"";
    }
    
    //激活次数
    _activeTimesStr = @"";
    if (_sportPageModel.active_times.length != 0) {
        if ([_sportPageModel.active_times isEqualToString:@"0"]) {
            _activeTimesStr = @"(从未激活过)";
        } else {
            _activeTimesStr = [NSString stringWithFormat:@"(已激活%@次)",_sportPageModel.active_times];
        }
    }
    
    //激活按钮状态
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    _isSelfCreate = [userId isEqualToString:_sportPageModel.user_id.userId];
    if (_isSelfCreate) {
        _activeButton.hidden = false;
        NSString *contentStr = [NSString stringWithFormat:@"马上激活%@",_activeTimesStr];
        NSMutableAttributedString *attributedString  = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:18]
                                 range:NSMakeRange(0, 4)];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:11]
                                 range:NSMakeRange(4, contentStr.length-4)];
        [_activeButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
    
    _scrollView.hidden = false;
    
}

#pragma mark - Action
#pragma mark 返回
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark 关注按钮
- (IBAction)focusButtonAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"+ 关注"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPSportBusinessUnit shareInstance] followWithUserId:userId sportId:_sportId successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                [sender setBackgroundColor:[UIColor grayColor]];
                sender.userInteractionEnabled = false;
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
}

#pragma mark 场地导航
- (void)tapLocationAction:(UITapGestureRecognizer *)sender {
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([_sportPageModel.latitude doubleValue], [_sportPageModel.longitude doubleValue]);
    NSArray *array = [self getInstalledMapAppWithEndLocation:locationCoordinate];
    
    if (array.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还没有安装任何地图" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    } else {
        UIAlertController *alertSheetController = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertSheetController addAction:actionCancel];
        for (int i=0; i<array.count; i++) {
            NSString *title = [array[i] valueForKey:@"title"];
            if ([title isEqualToString:@"苹果地图"]) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self navAppleMap];
                }];
                [alertSheetController addAction:action];
            } else {
                UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *urlStr = [array[i] valueForKey:@"url"];
                    
                    NSString *version = [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0];
                    if ([version isEqualToString:@"10"]) {
                        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
                        #endif
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
                [alertSheetController addAction:action];
            }
        }
        [self presentViewController:alertSheetController animated:true completion:nil];
    }
}

- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation {
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *url = @"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02";
        NSString *urlStr = [NSString stringWithFormat:url,endLocation.latitude,endLocation.longitude];
        NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *url = @"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2";
        NSString *urlStr = [NSString stringWithFormat:url,@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude];
        NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *url = @"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving";
        NSString *urlStr = [NSString stringWithFormat:url,@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude];
        NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *url = @"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0";
        NSString *urlStr = [NSString stringWithFormat:url,endLocation.latitude,endLocation.longitude];
        NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    return maps;
}

- (void)navAppleMap {
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([_sportPageModel.latitude doubleValue], [_sportPageModel.longitude doubleValue]);
    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:locationCoordinate];
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

#pragma mark 电话
- (void)tapTelophoneAction:(UITapGestureRecognizer *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    if (_sportPageModel.user_id.mobile.length != 0) {
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",_sportPageModel.user_id.mobile];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [self.view addSubview:callWebview];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"对方没有填写电话" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

#pragma mark 激活按钮
- (void)activeButtonAction:(UIButton *)sender {
    SPCreateNextStepViewController *activeViewController = [[SPCreateNextStepViewController alloc] init];
    if (_activeTimesStr.length == 0) {
        activeViewController.isFirstActive = true;
    } else {
        if ([_activeTimesStr isEqualToString:@"(从未激活过)"]) {
            activeViewController.isFirstActive = true;
        } else {
            activeViewController.isFirstActive = false;
        }
    }

    activeViewController.sportId = _sportId;
    activeViewController.uploadImage = _headImageView.image;
    activeViewController.sportsName = _sportPageModel.title;
    activeViewController.sportsLocation = _sportPageModel.place;
    activeViewController.sportsEvent = _eventLabel.text;
    activeViewController.sportsSummary = _eventDetailLabel.text;
    [self.navigationController pushViewController:activeViewController animated:true];
}


#pragma mark -

@end
