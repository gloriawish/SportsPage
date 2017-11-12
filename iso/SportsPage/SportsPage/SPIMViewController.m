//
//  SPIMViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPIMViewController.h"

//个人聊天界面ViewController
#import "SPChatViewController.h"
//群组聊天界面ViewController
#import "SPChatGroupViewController.h"

//系统会话Cell:添加好友
#import "SPAddFrendsCell.h"
//确认添加好友ViewController
#import "SPAddFriendViewController.h"

//添加好友ViewController
#import "SPIMAddFriendsViewController.h"
//创建群组ViewController
#import "SPIMCreateGroupViewController.h"

//添加好友,创建群组View
#import "FFDropDownMenuView.h"

#import "SPIMMessageContentInviteClub.h"
#import "SPIMMessageContentApplyClub.h"

#import "SPIMInviteRequestListViewController.h"
#import "SPIMApplyRequestListViewController.h"

@interface SPIMViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) FFDropDownMenuView *dropDownMenu;

@end

@implementation SPIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self notifyUpdateUnreadMessageCount];
    self.navigationController.navigationBarHidden = false;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RELOAD_CONVERSATION object:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        return false;
    }
    return true;
}

#pragma mark - SetUp
- (void)setUpNav {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar_black"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"聊天";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendsAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setUp {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    self.emptyConversationView = backView;
    self.showConnectingStatusOnNavigatorBar = true;
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_SYSTEM)]];
    
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    self.conversationListTableView.separatorColor = [SPGlobalConfig anyColorWithRed:223 green:223 blue:223 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadConversation:) name:NOTIFICATION_RELOAD_CONVERSATION object:nil];
}

#pragma mark - Action
- (void)reloadConversation:(NSNotification *)notification {
    NSString *targetId = [notification.userInfo objectForKey:@"targetId"];
    for (int i=0; i<self.conversationListDataSource.count; i++) {
        RCConversationModel *model = self.conversationListDataSource[i];
        if ([model.targetId isEqualToString:targetId]) {
            [[RCIMClient sharedRCIMClient] clearMessages:model.conversationType targetId:model.targetId];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:model.targetId];
            [self.conversationListDataSource removeObjectAtIndex:i];
            [self.conversationListTableView reloadData];
            break;
        }
    }
}

- (void)didTapCellPortrait:(RCConversationModel *)model {
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        if (model.conversationType == ConversationType_PRIVATE
            && [model.targetId isEqualToString:@"10000"]
            && [model.lastestMessage isMemberOfClass:[SPIMMessageContentInviteClub class]]) {
            SPIMInviteRequestListViewController *inviteRequestListViewController = [[SPIMInviteRequestListViewController alloc] init];
            inviteRequestListViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:inviteRequestListViewController animated:true];
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:model.conversationType
                                                            targetId:model.targetId];
        } else if (model.conversationType == ConversationType_PRIVATE
                   && [model.targetId isEqualToString:@"10001"]
                   && [model.lastestMessage isMemberOfClass:[SPIMMessageContentApplyClub class]]) {
            SPIMApplyRequestListViewController *applyRequestListViewController = [[SPIMApplyRequestListViewController alloc] init];
            applyRequestListViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:applyRequestListViewController animated:true];
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:model.conversationType
                                                            targetId:model.targetId];
        } else {
            SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
            chatViewController.model = model;
            chatViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:chatViewController animated:true];
        }
    }
}

- (void)didLongPressCellPortrait:(RCConversationModel *)model {
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        if (model.conversationType == ConversationType_PRIVATE
            && [model.targetId isEqualToString:@"10000"]
            && [model.lastestMessage isMemberOfClass:[SPIMMessageContentInviteClub class]]) {
            SPIMInviteRequestListViewController *inviteRequestListViewController = [[SPIMInviteRequestListViewController alloc] init];
            inviteRequestListViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:inviteRequestListViewController animated:true];
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:model.conversationType
                                                            targetId:model.targetId];
        } else if (model.conversationType == ConversationType_PRIVATE
                   && [model.targetId isEqualToString:@"10001"]
                   && [model.lastestMessage isMemberOfClass:[SPIMMessageContentApplyClub class]]) {
            SPIMApplyRequestListViewController *applyRequestListViewController = [[SPIMApplyRequestListViewController alloc] init];
            applyRequestListViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:applyRequestListViewController animated:true];
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:model.conversationType
                                                            targetId:model.targetId];
        } else {
            SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
            chatViewController.model = model;
            chatViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:chatViewController animated:true];
        }
    }
}


- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        if (model.conversationType == ConversationType_PRIVATE) {
            
            if ([model.lastestMessage isMemberOfClass:[SPIMMessageContentInviteClub class]]) {
                SPIMInviteRequestListViewController *inviteRequestListViewController = [[SPIMInviteRequestListViewController alloc] init];
                inviteRequestListViewController.hidesBottomBarWhenPushed = true;
                [self.navigationController pushViewController:inviteRequestListViewController animated:true];
                [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:model.conversationType
                                                                targetId:model.targetId];
            } else if ([model.lastestMessage isMemberOfClass:[SPIMMessageContentApplyClub class]]) {
                SPIMApplyRequestListViewController *applyRequestListViewController = [[SPIMApplyRequestListViewController alloc] init];
                applyRequestListViewController.hidesBottomBarWhenPushed = true;
                [self.navigationController pushViewController:applyRequestListViewController animated:true];
                [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:model.conversationType
                                                                targetId:model.targetId];
            } else {
                SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
                chatViewController.model = model;
                chatViewController.indexPath = indexPath;
                chatViewController.hidesBottomBarWhenPushed = true;
                [self.navigationController pushViewController:chatViewController animated:true];
            }
        } else if (model.conversationType == ConversationType_GROUP) {
            SPChatGroupViewController *groupChatViewController = [[SPChatGroupViewController alloc] initWithConversationType:ConversationType_GROUP targetId:model.targetId];
            groupChatViewController.model = model;
            groupChatViewController.indexPath = indexPath;
            groupChatViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:groupChatViewController animated:true];
        }
    } else if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        SPAddFriendViewController *addFVC = [[SPAddFriendViewController alloc] init];
        addFVC.targetId = [self.conversationListDataSource[indexPath.row] targetId];
        addFVC.indexPath = indexPath;
        addFVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:addFVC animated:true];
    }
}

#pragma mark - tabBarNotification
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        if (message.conversationType != ConversationType_SYSTEM) {
            NSLog(@"好友消息要发系统消息！！！");
#if DEBUG
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
#endif
        }
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId.length ==0) {
            return;
        }
        
        RCConversationModel *customModel = [RCConversationModel new];
        customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        customModel.extend = nil;
        customModel.senderUserId = message.senderUserId;
        customModel.lastestMessage = _contactNotificationMsg;
        //[_myDataSource insertObject:customModel atIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            [self notifyUpdateUnreadMessageCount];
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            NSNumber *left = [notification.userInfo objectForKey:@"left"];
            if (0 == left.integerValue) {
                [super refreshConversationTableViewIfNeeded];
            }
        });
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
        });
    }
    
}

- (void)notifyUpdateUnreadMessageCount {
    [self updateBadgeValueForTabBarItem];
}

- (void)updateBadgeValueForTabBarItem {
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                                    @(ConversationType_GROUP)]];
        if (count>0) {
            __weakSelf.tabBarController.viewControllers[1].tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        } else {
            __weakSelf.tabBarController.viewControllers[1].tabBarItem.badgeValue = nil;
        }
    });
}

#pragma mark - CustomCell
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if(model.conversationType == ConversationType_SYSTEM
        && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]) {
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
//        else if (model.conversationType == ConversationType_PRIVATE
//                   && [model.lastestMessage isMemberOfClass:[SPIMMessageContentInviteClub class]]) {
//            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//        } else if (model.conversationType == ConversationType_PRIVATE
//                   && [model.lastestMessage isMemberOfClass:[SPIMMessageContentApplyClub class]]) {
//            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//        }
    }
    return dataSource;
}

-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    NSString *extraString = @"";
    
    if (nil == model.extend) {
        if(model.conversationType == ConversationType_SYSTEM
           && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]) {
            extraString = [(RCContactNotificationMessage *)model.lastestMessage extra];
            
            SPAddFrendsCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SPAddFrendsCell" owner:nil options:nil] lastObject];
            [cell setUpCellWithContent:extraString time:model.receivedTime];
            return cell;
        }
//        else if (model.conversationType == ConversationType_PRIVATE
//                   && [model.lastestMessage isMemberOfClass:[SPIMMessageContentInviteClub class]]) {
//            return nil;
//        } else if (model.conversationType == ConversationType_PRIVATE
//                   && [model.lastestMessage isMemberOfClass:[SPIMMessageContentApplyClub class]]) {
//            return nil;
//        }
    }
    
    return nil;
    
}

- (void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] clearMessages:model.conversationType targetId:model.targetId];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

#pragma mark - DropMenuView
- (void)addFriendsAction:(UIBarButtonItem *)sender {
    NSArray *menuModelsArr = [self getDropDownMenuModelsArray];
    self.dropDownMenu = [FFDropDownMenuView new];
    /** 下拉菜单模型数组 */
    self.dropDownMenu.menuModelsArray = menuModelsArr;
    /** cell的类名 */
    self.dropDownMenu.cellClassName = FFDefaultCell;
    /** 菜单的宽度(若不设置，默认为 150) */
    self.dropDownMenu.menuWidth = 108;
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
    __weak SPIMViewController *weakSelf = self;
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"添加好友" menuItemIconName:@"IM_main_add_friends" menuBlock:^{
        SPIMAddFriendsViewController *addFriendsViewController = [[SPIMAddFriendsViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addFriendsViewController];
        [weakSelf presentViewController:nav animated:true completion:nil];
    }];
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"创建群组" menuItemIconName:@"IM_main_create_group" menuBlock:^{
        SPIMCreateGroupViewController *createGroupViewController = [[SPIMCreateGroupViewController alloc] init];
        [weakSelf presentViewController:createGroupViewController animated:true completion:nil];
    }];
    NSArray *menuModelArr = @[menuModel0, menuModel1];
    return menuModelArr;
}

@end
