//
//  SPChatGroupViewController.m
//  SportsPage
//
//  Created by Qin on 2017/1/3.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPChatGroupViewController.h"

//自定义Cell:分享
#import "SPIMMessageCustomCell.h"
#import "SPIMMessageContent.h"
#import "SPIMMessageCustomShareClubCell.h"
#import "SPIMMessageContentShareClub.h"

//运动详情ViewController
#import "SPSportsEventViewController.h"

//俱乐部详情ViewController
#import "SPSportsClubViewController.h"

//群组查看用户ViewController
#import "SPCheckGroupUsersViewController.h"

//聊天设置ViewController
#import "SPChatSettingViewController.h"

@interface SPChatGroupViewController ()

@end

@implementation SPChatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - SetUp
- (void)setUpNav {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = _model.conversationTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *negativeSpacerL = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    negativeSpacerL.width = -20;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacerL, backBarButtonItem];
    
    UIBarButtonItem *negativeSpacerR = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    negativeSpacerR.width = -20;
    UIButton *chatSettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatSettingButton.frame = CGRectMake(0, 0, 55, 30);
    [chatSettingButton setBackgroundImage:[UIImage imageNamed:@"IM_chatSetting"] forState:UIControlStateNormal];
    [chatSettingButton addTarget:self action:@selector(turnToInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *chatSettingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chatSettingButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacerR, chatSettingBarButtonItem];
}

- (void)setUp {
    self.enableUnreadMessageIcon = true;
    self.enableNewComingMessageIcon = true;
    self.displayUserNameInCell = true;
    
    [self registerClass:[SPIMMessageCustomCell class] forMessageClass:[SPIMMessageContent class]];
    [self registerClass:[SPIMMessageCustomShareClubCell class] forMessageClass:[SPIMMessageContentShareClub class]];
    [self scrollToBottomAnimated:true];
}

#pragma mark - Action
- (void)didTapCellPortrait:(NSString *)userId {
    SPCheckGroupUsersViewController *checkGroupUsersViewController = [[SPCheckGroupUsersViewController alloc] init];
    checkGroupUsersViewController.targetId = userId;
    [self.navigationController pushViewController:checkGroupUsersViewController animated:true];
}

- (void)didLongPressCellPortrait:(NSString *)userId {
    SPCheckGroupUsersViewController *checkGroupUsersViewController = [[SPCheckGroupUsersViewController alloc] init];
    checkGroupUsersViewController.targetId = userId;
    [self.navigationController pushViewController:checkGroupUsersViewController animated:true];
}

- (void)turnToInfoAction:(id)sender {
    SPChatSettingViewController *chatSettingViewController = [[SPChatSettingViewController alloc] init];
    chatSettingViewController.conversationType = _model.conversationType;
    chatSettingViewController.targetId = _model.targetId;
    if (_indexPath) {
        chatSettingViewController.indexPath = _indexPath;
    }
    [self.navigationController pushViewController:chatSettingViewController animated:true];
}

- (void)navBackAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model
                         inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
}

- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isMemberOfClass:[SPIMMessageContent class]]) {
        SPIMMessageContent *contentModel = (SPIMMessageContent *)model.content;
        SPSportsEventViewController *sportsEventViewController = [[SPSportsEventViewController alloc] init];
        sportsEventViewController.eventId = contentModel.eventId;
        self.navigationController.navigationBarHidden = true;
        [self.navigationController pushViewController:sportsEventViewController animated:true];
    } else if ([model.content isMemberOfClass:[SPIMMessageContentShareClub class]]) {
        SPIMMessageContentShareClub *contentModel = (SPIMMessageContentShareClub *)model.content;
        SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
        clubViewController.clubId = contentModel.clubId;
        self.navigationController.navigationBarHidden = true;
        [self.navigationController pushViewController:clubViewController animated:true];
    }
}

@end
