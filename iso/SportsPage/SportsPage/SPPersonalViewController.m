 //
//  SPPersonalViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalViewController.h"

//个人信息ViewController
#import "SPPersonalInfoViewController.h"
//系统设置ViewController
#import "SPPersonalSysSettingViewController.h"

//请求数据
#import "SPUserBusinessUnit.h"
#import "SPPersonalInfoModel.h"
//Flag请求
#import "SPAuthBusinessUnit.h"

//HeaderView
#import "SPPersonalMainHeaderView.h"
//表单Cell
#import "SPPersonalMainTableViewCell.h"

//我的运动页ViewController
#import "SPPersonalMainSportsPageViewController.h"
//创建运动页ViewController
#import "SPCreateSportsViewController.h"
//进行中,待结算,待评价,全部记录ViewController
#import "SPPersonalEventStatusViewController.h"
//我的钱包ViewController
#import "SPPersonalAccountViewController.h"

//我的俱乐部ViewController
#import "SPPersonalClubViewController.h"

//实名认证ViewController
#import "SPPersonalInputViewController.h"
//意见反馈ViewController
#import "SPPersonalFeedbackViewController.h"
//关于我们ViewController
#import "SPPersonalAboutUsViewController.h"

//透明指示器View
#import "MBProgressHUD.h"

//分享
#import "SPSportsPageShareView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface SPPersonalViewController () <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,personalMainHeaderProtocol,SPSportsPageShareViewProtocol,TencentSessionDelegate> {
    SPPersonalInfoModel *_personalInfoModel;
    
    BOOL _flag;
    
    SPPersonalMainHeaderView *_mainHeaderView;
    
    UIImageView *_windowImageViewBG;
    SPSportsPageShareView *_shareView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sysSettingButton;

@end

@implementation SPPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self checkFlag];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self networkRequset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)checkFlag {
    _flag = false;
    [[SPAuthBusinessUnit shareInstance] getGlobalConfSuccessful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"on"]) {
            [UIView animateWithDuration:0.3 animations:^{
                _flag = true;
                [_tableView reloadData];
            }];
        } else {
            NSLog(@"网络请求失败");
        }
    } failure:^(NSString *errorString) {
        NSLog(@"网络请求失败");
    }];
}

- (void)networkRequset {
//    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPUserBusinessUnit shareInstance] getMineInfoWithUserId:userId successful:^(NSString *successsfulString, JSONModel *model) {
        if ([successsfulString isEqualToString:@"successful"]) {
            _personalInfoModel = (SPPersonalInfoModel *)model;
            [_mainHeaderView setUpHeaderImageView:_personalInfoModel.user.portrait userName:_personalInfoModel.user.nick];
            NSLog(@"Mine页面刷新数据");
            [_tableView reloadData];
//            [MBProgressHUD hideHUDForView:self.view animated:true];
        } else {
            NSLog(@"%@",successsfulString);
//            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        NSLog(@"%@",errorString);
//        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        return false;
    }
    return true;
}


#pragma mark -SetUp
- (void)setUp {
    [self setUpNav];
    [self setUpUI];
    [self setUpTableView];
}

- (void)setUpNav {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)setUpUI {
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    [_sysSettingButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

- (void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    [self setUpHeader];
}

- (void)setUpHeader {
    _mainHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"SPPersonalMainHeaderView" owner:nil options:nil] lastObject];
    _mainHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*362/375);
    _mainHeaderView.delegate = self;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*362/375)];
    [header addSubview:_mainHeaderView];
    _tableView.tableHeaderView = header;
}

#pragma mark - Action
- (IBAction)systemSettingAction:(UIButton *)sender {
    SPPersonalSysSettingViewController *sysSettingViewController = [[SPPersonalSysSettingViewController alloc] init];
    sysSettingViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:sysSettingViewController animated:true];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH*2/15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != 3) {
        return SCREEN_WIDTH*2/125;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*2/125)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalMainCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalMainTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalMainCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalMainCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [(SPPersonalMainTableViewCell *)cell setUpWithImageName:@"Mine_main_wallet" title:@"我的钱包"];
        [(SPPersonalMainTableViewCell *)cell setUpWithContent:[NSString stringWithFormat:@"余额%@",_personalInfoModel.account.balance]];
    } else if (indexPath.section == 1) {
        [(SPPersonalMainTableViewCell *)cell setUpWithImageName:@"Mine_main_club" title:@"我的俱乐部"];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [(SPPersonalMainTableViewCell *)cell setUpWithImageName:@"Mine_main_nameConfirm" title:@"实名认证"];
            if ([_personalInfoModel.user.valid isEqualToString:@"1"]) {
                [(SPPersonalMainTableViewCell *)cell setUpWithContent:@"未认证"];
                [(SPPersonalMainTableViewCell *)cell setUpMoreImage:@"Mine_More"];
                //[(SPPersonalMainTableViewCell *)cell setUpMoreImageHidden:false];
                cell.userInteractionEnabled = true;
            } else if ([_personalInfoModel.user.valid isEqualToString:@"2"]) {
                [(SPPersonalMainTableViewCell *)cell setUpWithContent:@"认证中"];
                [(SPPersonalMainTableViewCell *)cell setUpMoreImage:@"Mine_personal_nameConfirm_ing"];
                //[(SPPersonalMainTableViewCell *)cell setUpMoreImageHidden:true];
                cell.userInteractionEnabled = false;
            } else if ([_personalInfoModel.user.valid isEqualToString:@"3"]) {
                [(SPPersonalMainTableViewCell *)cell setUpWithContent:@"已认证"];
                [(SPPersonalMainTableViewCell *)cell setUpMoreImage:@"Mine_personal_nameConfirm_successful"];
                //[(SPPersonalMainTableViewCell *)cell setUpMoreImageHidden:true];
                cell.userInteractionEnabled = false;
            }
        } else if (indexPath.row == 1) {
            [(SPPersonalMainTableViewCell *)cell setUpWithImageName:@"Mine_main_feedback" title:@"意见反馈"];
        } else if (indexPath.row == 2) {
            [(SPPersonalMainTableViewCell *)cell setUpWithImageName:@"Mine_main_aboutus" title:@"关于我们"];
        }
    } else if (indexPath.section == 3) {
        [(SPPersonalMainTableViewCell *)cell setUpWithImageName:@"Mine_main_share" title:@"分享App"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        SPPersonalAccountViewController *accountViewController = [[SPPersonalAccountViewController alloc] init];
        if (_personalInfoModel.account.balance.length != 0) {
            accountViewController.balanceStr = _personalInfoModel.account.balance;
        } else {
            accountViewController.balanceStr = @"";
        }
        accountViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:accountViewController animated:true];
    } else if (indexPath.section == 1) {
        
        SPPersonalClubViewController *personalClubViewController = [[SPPersonalClubViewController alloc] init];
        personalClubViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:personalClubViewController animated:true];
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            SPPersonalInputViewController *inputViewController = [[SPPersonalInputViewController alloc] init];
            inputViewController.navTitleStr = @"实名认证";
            inputViewController.personalMainCell = (SPPersonalMainTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            inputViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:inputViewController animated:true];
        } else if (indexPath.row == 1) {
            SPPersonalFeedbackViewController *feedbackViewController = [[SPPersonalFeedbackViewController alloc] init];
            feedbackViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:feedbackViewController animated:true];
        } else if (indexPath.row == 2) {
            SPPersonalAboutUsViewController *aboutUsViewController = [[SPPersonalAboutUsViewController alloc] init];
            aboutUsViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:aboutUsViewController animated:true];
        }
    } else if (indexPath.section == 3) {
        
        if (!_windowImageViewBG) {
            _windowImageViewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _windowImageViewBG.image = [UIImage imageNamed:@"Sports_create_windowBG"];
            _windowImageViewBG.alpha = 0;
        }
        [self.view addSubview:_windowImageViewBG];
        
        if (!_shareView) {
            _shareView = [[[NSBundle mainBundle] loadNibNamed:@"SPSportsPageShareView" owner:nil options:nil] lastObject];
            [_shareView isNotNeedToSportsPageShareType];
            _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            _shareView.delegate = self;
        }
        [self.view addSubview:_shareView];
    
        [UIView animateWithDuration:0.3 animations:^{
            _windowImageViewBG.alpha = 1;
            _shareView.shareView.alpha = 1;
            _shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.tabBarController.tabBar.alpha = 0;
        }];
    }
}

#pragma mark - PersonalMainHeaderProtocol
- (void)sendActionWithTitle:(NSString *)title {
    if ([title isEqualToString:@"头像"]) {
        SPPersonalInfoViewController *personalInfoViewController = [[SPPersonalInfoViewController alloc] init];
        personalInfoViewController.hidesBottomBarWhenPushed = true;
        personalInfoViewController.userInfoModel = _personalInfoModel.user;
        [self.navigationController pushViewController:personalInfoViewController animated:true];
    } else if ([title isEqualToString:@"我的运动页"]) {
        SPPersonalMainSportsPageViewController *sportsPageViewController = [[SPPersonalMainSportsPageViewController alloc] init];
        sportsPageViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:sportsPageViewController animated:true];
    } else if ([title isEqualToString:@"创建运动页"]) {
        SPCreateSportsViewController *createSportsViewController = [[SPCreateSportsViewController alloc] init];
        createSportsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:createSportsViewController animated:true];
    } else if ([title isEqualToString:@"进行中"]) {
        SPPersonalEventStatusViewController *eventViewController = [[SPPersonalEventStatusViewController alloc] init];
        eventViewController.selectIndex = 1;
        eventViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:eventViewController animated:true];
    } else if ([title isEqualToString:@"待结算"]) {
        SPPersonalEventStatusViewController *eventViewController = [[SPPersonalEventStatusViewController alloc] init];
        eventViewController.selectIndex = 2;
        eventViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:eventViewController animated:true];
    } else if ([title isEqualToString:@"待评价"]) {
        SPPersonalEventStatusViewController *eventViewController = [[SPPersonalEventStatusViewController alloc] init];
        eventViewController.selectIndex = 3;
        eventViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:eventViewController animated:true];
    } else if ([title isEqualToString:@"全部记录"]) {
        SPPersonalEventStatusViewController *eventViewController = [[SPPersonalEventStatusViewController alloc] init];
        eventViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:eventViewController animated:true];
    }
}

#pragma mark - SPSportsPageShareViewProtocol
- (void)cancelShareView {
    [UIView animateWithDuration:0.5 animations:^{
        _windowImageViewBG.alpha = 0;
        _shareView.shareView.alpha = 0;
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.tabBarController.tabBar.alpha = 1;
    } completion:^(BOOL finished) {
        _windowImageViewBG.alpha = 1;
        [_windowImageViewBG removeFromSuperview];
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_shareView removeFromSuperview];
    }];
}

- (void)finishedShareToSportsPage {
    
}

- (void)finishedShareToWeChatFriends {
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.sportspage";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"运动页";
    message.description = @"您的运动管理平台";
    UIImage *thumbImage = [self imageWithImage:[UIImage imageNamed:@"icon_appIcon"] scaledToSize:CGSizeMake(100, 100)];
    [message setThumbImage:thumbImage];
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = false;
    req.message = message;
    req.scene = WXSceneSession;
    if (![WXApi sendReq:req]) {
        [SPGlobalConfig showTextOfHUD:@"分享失败" ToView:self.view];
    }
}

- (void)finishedShareToWeChatTimeLine {
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.sportspage";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"运动页";
    message.description = @"您的运动管理平台";
    UIImage *thumbImage = [self imageWithImage:[UIImage imageNamed:@"icon_appIcon"] scaledToSize:CGSizeMake(100, 100)];
    [message setThumbImage:thumbImage];
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = false;
    req.message = message;
    req.scene = WXSceneTimeline;
    if (![WXApi sendReq:req]) {
        [SPGlobalConfig showTextOfHUD:@"分享失败" ToView:self.view];
    }
}

- (void)finishedShareToQQ {
    [[TencentOAuth alloc] initWithAppId:KEY_TENCENT andDelegate:self];
    
    NSString *url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.sportspage";
    
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:@"运动页"
                                                     description:@"您的运动管理平台"
                                                previewImageURL:[NSURL URLWithString:@"http://www.sportspage.cn/home/Tpl//Index/images/logo.jpg"]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    if (sent == EQQAPISENDSUCESS) {
        NSLog(@"分享成功");
    } else if (sent == EQQAPIVERSIONNEEDUPDATE) {
        NSLog(@"当前QQ版本太低，需要更新至新版本才可以支持");
    } else {
        NSLog(@"分享失败");
    }
}

- (void)finishedShareToQQZone {
    [[TencentOAuth alloc] initWithAppId:KEY_TENCENT andDelegate:self];
    
    NSString *url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.sportspage";
    
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:@"运动页"
                                                     description:@"您的运动管理平台"
                                                previewImageURL:[NSURL URLWithString:@"http://www.sportspage.cn/home/Tpl//Index/images/logo.jpg"]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    if (sent == EQQAPISENDSUCESS) {
        NSLog(@"分享成功");
    } else if (sent == EQQAPIVERSIONNEEDUPDATE) {
        NSLog(@"当前QQ版本太低，需要更新至新版本才可以支持");
    } else {
        NSLog(@"分享失败");
    }
}

- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(newImage, 0.3);
    return [UIImage imageWithData:data];
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

@end
