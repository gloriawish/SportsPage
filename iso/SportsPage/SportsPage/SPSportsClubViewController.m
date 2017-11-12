//
//  SPSportsClubViewController.m
//  SportsPage
//
//  Created by Qin on 2017/2/8.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsClubViewController.h"

//HeaderView
#import "SPSportsClubHeaderView.h"

//TrendCell
#import "SPSportsClubTrendTableViewCell.h"

#import "SPPersonalClubSettingViewController.h"

#import "SPSportBusinessUnit.h"

#import "SPClubDetailResponseModel.h"

#import "MBProgressHUD.h"

//成员列表
#import "SPSportsClubMembersListViewController.h"

//分享
#import "SPSportsPageShareView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//关联运动页列表
#import "SPSportsClubRelationSportsPageViewController.h"

#import "SPSportsEventViewController.h"
#import "SPSportsPageBaseViewController.h"

#import <RongIMKit/RongIMKit.h>
#import "SPChatGroupViewController.h"

#import "AppDelegate.h"

#import "SPSportsShareViewController.h"

#import "SPIMSendMessageShareClubModel.h"

#import "SPChatViewController.h"
#import "SPChatGroupViewController.h"

#import "SPIMMessageContentShareClub.h"

@interface SPSportsClubViewController () <UITableViewDelegate,UITableViewDataSource,SPSportsClubHeaderViewProtocol,SPPersonalClubSettingViewControllerProtocol,SPSportsPageShareViewProtocol,TencentSessionDelegate,SPSportsClubRelationSportsPageViewControllerProtocol> {
    SPSportsClubHeaderView *_clubHeaderView;
    
    SPClubDetailResponseModel *_clubDetailResponseModel;
    
    NSMutableArray <SPClubDetailActiveModel *> *_clubDetailActiveArray;
    
    UIImageView *_windowImageViewBG;
    SPSportsPageShareView *_shareView;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *navBarImageView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIButton *clubSettingButton;

@end

@implementation SPSportsClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CLUB_SHARE object:nil];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
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

#pragma mark - SetUp
- (void)setUp {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationShareAction:) name:NOTIFICATION_CLUB_SHARE object:nil];
    
    [self setUpNav];
    [self networkRequest];
}

- (void)setUpNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    _navBarView.backgroundColor = [SPGlobalConfig anyColorWithRed:88 green:87 blue:86 alpha:0.9];
    _navBarView.alpha = 0;
    _clubSettingButton.hidden = true;
}

- (void)setUpTableView {
    
    _tableView.hidden = false;
    _tableView.userInteractionEnabled = true;
    
    [self setUpActiveArray];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpTableViewHeader];
    [self setUpTableViewFooter];
}

- (void)setUpActiveArray {
    _clubDetailActiveArray = _clubDetailResponseModel.actives;
    
    if (_clubDetailActiveArray.count == 0) {
        SPClubDetailActiveModel *model = [[SPClubDetailActiveModel alloc] init];
        model.desc = @"俱乐部还没有运动动态。";
        model.time = @"";
        [_clubDetailActiveArray addObject:model];
    }
    
}

- (void)setUpTableViewHeader {
    UIView *headerView = [[UIView alloc] init];
    if (_clubDetailResponseModel.sports.count != 0) {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*(1164+15)/375);
        _clubHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"SPSportsClubHeaderView" owner:nil options:nil] firstObject];
        _clubHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*(1164+15)/375);
        _clubHeaderView.delegate = self;
    } else {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*(986+15)/375);
        _clubHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"SPSportsClubHeaderView" owner:nil options:nil] lastObject];
        _clubHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*(986+15)/375);
        _clubHeaderView.delegate = self;
    }
    [_clubHeaderView setUpClubDetailResponseModel:_clubDetailResponseModel];
    [headerView addSubview:_clubHeaderView];
    _tableView.tableHeaderView = headerView;
}

- (void)setUpTableViewFooter {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    _tableView.tableFooterView = footerView;
}

- (void)setUpClubSettingButton {
    if (!([_clubDetailResponseModel.op_permission isEqualToString:@"0"]
          || [_clubDetailResponseModel.op_permission isEqualToString:@"1"])) {
        _clubSettingButton.hidden = false;
    }
}

- (void)networkRequest {
    
    _tableView.hidden = true;
    _tableView.userInteractionEnabled = false;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] getClubDetailWithUserId:userId clubId:_clubId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
            _clubDetailResponseModel = (SPClubDetailResponseModel *)jsonModel;
            _clubDetailResponseModel.member_count = [NSString stringWithFormat:@"%ld",[_clubDetailResponseModel.member_count integerValue] + 1];
            [self reloadViewController];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

- (void)reloadViewController {
    [self setUpClubSettingButton];
    [self setUpTableView];
}

#pragma mark - Action
- (IBAction)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)clubSettingAction:(id)sender {
    
    SPPersonalClubSettingViewControllerStyle style;
    
    if ([_clubDetailResponseModel.op_permission isEqualToString:@"2"]) {
        style = SPPersonalClubSettingViewControllerStyleAdmin;
    } else if ([_clubDetailResponseModel.op_permission isEqualToString:@"3"]) {
        style = SPPersonalClubSettingViewControllerStyleCreator;
    }
    
    SPPersonalClubSettingViewController *settingViewController = [[SPPersonalClubSettingViewController alloc] initWithViewControllerType:style];
    settingViewController.delegate = self;
    
    [settingViewController setUpCoverImage:_clubHeaderView.getClubCoverImageView
                                 teamImage:_clubHeaderView.getClubTeamImageView
                                  clubName:_clubDetailResponseModel.name
                                 clubEvent:_clubDetailResponseModel.sport_item
                                clubExtend:_clubDetailResponseModel.extend
                          clubPublicNotice:_clubDetailResponseModel.ann.content
                              clubJoinType:_clubDetailResponseModel.join_type];
    
    [settingViewController setUpClubMembersArray:_clubDetailResponseModel.top_member
                                clubMembersCount:_clubDetailResponseModel.member_count
                                          clubId:_clubId];
    
    [self.navigationController pushViewController:settingViewController animated:true];
}

#pragma mark - ShareNotification
- (void)notificationShareAction:(NSNotification *)notification {
    NSString *type = notification.userInfo[@"type"];
    NSString *targetId = notification.userInfo[@"targetId"];
    NSString *title = notification.userInfo[@"title"];
    
    SPIMSendMessageShareClubModel *model = [[SPIMSendMessageShareClubModel alloc] init];
    model.clubId = _clubId;
    model.imageUrl = _clubDetailResponseModel.icon;
    model.shareTitle = _clubDetailResponseModel.name;
    model.content = [NSString stringWithFormat:@"一起来%@俱乐部运动吧",_clubDetailResponseModel.name];
    
    RCConversationType conversationType;
    RCConversationModel *conversationModel = [[RCConversationModel alloc] init];
    conversationModel.conversationTitle = title;
    conversationModel.targetId = targetId;
    
    if ([type isEqualToString:@"person"]) {
        conversationType = ConversationType_PRIVATE;
    } else {
        conversationType = ConversationType_GROUP;
    }
    conversationModel.conversationType = conversationType;
    
    RCConversationViewController *conversationViewConntroller = nil;
    if (conversationType == ConversationType_PRIVATE) {
        SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:conversationType
                                                                                                 targetId:targetId];
        chatViewController.hidesBottomBarWhenPushed = true;
        chatViewController.model = conversationModel;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        chatViewController.indexPath = indexPath;
        conversationViewConntroller = chatViewController;
    } else if (conversationType == ConversationType_GROUP) {
        SPChatGroupViewController *groupChatViewController = [[SPChatGroupViewController alloc] initWithConversationType:ConversationType_GROUP targetId:targetId];
        groupChatViewController.hidesBottomBarWhenPushed = true;
        groupChatViewController.model = conversationModel;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        groupChatViewController.indexPath = indexPath;
        conversationViewConntroller = groupChatViewController;
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ((UITabBarController *)delegate.window.rootViewController).selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:false];
    [((UITabBarController *)delegate.window.rootViewController).selectedViewController pushViewController:conversationViewConntroller animated:true];
    
    SPIMMessageContentShareClub *messageContent = [SPIMMessageContentShareClub messageWithContent:model.content];
    messageContent.clubId = model.clubId;
    messageContent.imageUrl = model.imageUrl;
    messageContent.shareTitle = model.shareTitle;
    messageContent.content = model.content;
    [conversationViewConntroller sendMessage:messageContent pushContent:@"一条分享消息"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _clubDetailActiveArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsClubTrendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubTrendCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPSportsClubTrendTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ClubTrendCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ClubTrendCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *content = _tempArray[indexPath.row];
    NSString *content = _clubDetailActiveArray[indexPath.row].desc;
    CGFloat cellHeaderImageViewWidth = SCREEN_WIDTH*7/75;
    CGFloat width = SCREEN_WIDTH - (cellHeaderImageViewWidth + 20 + 30);
    CGFloat labelHeightValue = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                        context:nil].size.height;
    
    CGFloat bottomPointY = 10 + labelHeightValue + 5;
    
    if (bottomPointY >= cellHeaderImageViewWidth) {
        return bottomPointY + 35 + 5;
    } else {
        return cellHeaderImageViewWidth + 35 + 5;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SPSportsClubTrendTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setActivesModel:_clubDetailActiveArray[indexPath.row] headerImageUrl:_clubDetailResponseModel.icon];
    if (indexPath.row == _clubDetailActiveArray.count-1) {
        [cell setBottomLineViewHidden:true];
    }
}

#pragma mark - SPSportsClubHeaderViewProtocol
- (void)clubHeaderJoinAction {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] applyJoinClubWithUserId:userId clubId:_clubId extend:@"附加消息" successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"加入请求已发送" ToView:self.view];
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

- (void)clubHeaderChattingActionWithTargetId:(NSString *)targetId {
    
    RCConversationModel *conversationModel = [[RCConversationModel alloc] init];
    conversationModel.conversationTitle = _clubDetailResponseModel.name;
    conversationModel.conversationType = ConversationType_GROUP;
    conversationModel.targetId = targetId;
    
    SPChatGroupViewController *groupChatViewController = [[SPChatGroupViewController alloc] initWithConversationType:ConversationType_GROUP targetId:targetId];
    
    groupChatViewController.hidesBottomBarWhenPushed = true;
    groupChatViewController.model = conversationModel;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    groupChatViewController.indexPath = indexPath;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ((UITabBarController *)delegate.window.rootViewController).selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:false];
    [((UITabBarController *)delegate.window.rootViewController).selectedViewController pushViewController:groupChatViewController animated:true];
}

- (void)clubHeaderShareAction {
    
    if (!_windowImageViewBG) {
        _windowImageViewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _windowImageViewBG.image = [UIImage imageNamed:@"Sports_create_windowBG"];
        _windowImageViewBG.alpha = 0;
    }
    [self.view addSubview:_windowImageViewBG];
    
    if (!_shareView) {
        _shareView = [[[NSBundle mainBundle] loadNibNamed:@"SPSportsPageShareView" owner:nil options:nil] lastObject];
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_shareView onlyNeedToSportsPageShareType];
        _shareView.delegate = self;
    }
    [self.view addSubview:_shareView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _windowImageViewBG.alpha = 1;
        _shareView.shareView.alpha = 1;
        _shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)clubHeaderMembersListAction {
    SPSportsClubMembersListViewController *membersListViewController = [[SPSportsClubMembersListViewController alloc] initWithClubId:_clubId];
    [self.navigationController pushViewController:membersListViewController animated:true];
}

- (void)clubHeaderReviewRelationSportsPageAction {
    if ([_clubDetailResponseModel.op_permission isEqualToString:@"0"]
        || [_clubDetailResponseModel.op_permission isEqualToString:@"1"]) {
        return;
    } else if ([_clubDetailResponseModel.op_permission isEqualToString:@"2"]
               || [_clubDetailResponseModel.op_permission isEqualToString:@"3"]) {
        SPSportsClubRelationSportsPageViewController *relationSportsPageViewController = [[SPSportsClubRelationSportsPageViewController alloc] initWithClubId:_clubId permission:_clubDetailResponseModel.op_permission];
        relationSportsPageViewController.delegate = self;
        [self.navigationController pushViewController:relationSportsPageViewController animated:true];
    }
}

- (void)clubHeaderClickRelationSportsPageAction:(NSString *)sportsPageId status:(NSString *)status eventId:(NSString *)eventId {
    if ([status isEqualToString:@"0"]) {
        SPSportsPageBaseViewController *sportsPageViewController = [[SPSportsPageBaseViewController alloc] init];
        sportsPageViewController.sportId = sportsPageId;
        [self.navigationController pushViewController:sportsPageViewController animated:true];
    } else if ([status isEqualToString:@"1"]) {
        SPSportsEventViewController *sportsEventViewController = [[SPSportsEventViewController alloc] init];
        sportsEventViewController.eventId = eventId;
        [self.navigationController pushViewController:sportsEventViewController animated:true];
    }
}

#pragma mark - SPPersonalClubSettingViewControllerProtocol
- (void)updateJoinType:(NSString *)joinType {
    _clubDetailResponseModel.join_type = joinType;
}

- (void)updateClubCoverImage:(UIImage *)coverImage {
    [_clubHeaderView setUpClubCoverImageView:coverImage];
}

- (void)updateClubTeamImage:(UIImage *)teamImage {
    [_clubHeaderView setUpClubTeamImageView:teamImage];
}

- (void)updateClubName:(NSString *)clubName {
    _clubDetailResponseModel.name = clubName;
    [_clubHeaderView setUpClubName:clubName];
}

- (void)updateClubEvent:(NSString *)clubEvent clubEventExtend:(NSString *)clubEventExtend {
    _clubDetailResponseModel.sport_item = clubEvent;
    
    if ([clubEvent isEqualToString:@"20"]) {
        _clubDetailResponseModel.extend = clubEventExtend;
    } else {
        _clubDetailResponseModel.extend = @"";
    }
    
}

- (void)updateClubPublicNotice:(NSString *)publicNotice {
    _clubDetailResponseModel.ann.content = publicNotice;
    [_clubHeaderView setUpClubPublicNotice:publicNotice];
}

#pragma mark - SPSportsPageShareViewProtocol
- (void)cancelShareView {
    [UIView animateWithDuration:0.5 animations:^{
        _windowImageViewBG.alpha = 0;
        _shareView.shareView.alpha = 0;
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        _windowImageViewBG.alpha = 1;
        [_windowImageViewBG removeFromSuperview];
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_shareView removeFromSuperview];
    }];
}

- (void)finishedShareToSportsPage {
    SPSportsShareViewController *shareViewController = [[SPSportsShareViewController alloc] init];
    shareViewController.type = @"clubShare";
    [self.navigationController pushViewController:shareViewController animated:true];
}

- (void)finishedShareToWeChatFriends {
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"https://www.baidu.com";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _clubDetailResponseModel.name;
    UIImage *thumbImage = [self imageWithImage:_clubHeaderView.getClubTeamImageView scaledToSize:CGSizeMake(100, 100)];
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
    webpageObject.webpageUrl = @"https://www.baidu.com";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _clubDetailResponseModel.name;
    message.description = @"";
    UIImage *thumbImage = [self imageWithImage:_clubHeaderView.getClubTeamImageView scaledToSize:CGSizeMake(100, 100)];
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
    
    NSString *url = @"https://www.baidu.com";
    
    NSData *imageData = [self imageDataWithImage:_clubHeaderView.getClubTeamImageView scaledToSize:CGSizeMake(100, 100)];
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:_clubDetailResponseModel.name
                                                     description:@""
                                                previewImageData:imageData];
    
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
    
    NSString *url = @"https://www.baidu.com";
    
    NSData *imageData = [self imageDataWithImage:_clubHeaderView.getClubTeamImageView scaledToSize:CGSizeMake(100, 100)];
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:_clubDetailResponseModel.name
                                                     description:@""
                                                previewImageData:imageData];
    
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

- (NSData *)imageDataWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(newImage, 0.3);
    return data;
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

#pragma mark - SPSportsClubRelationSportsPageViewControllerProtocol
- (void)finishedBindReloadAction {
    [self networkRequest];
}

@end
