//
//  SPContactMyGroupViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPContactMyGroupViewController.h"
#import "SPContactTableViewCell.h"

#import "SPIMBusinessUnit.h"
#import "SPMyGroupsModel.h"

#import "MBProgressHUD.h"

//#import "SPChatViewController.h"
#import "SPChatGroupViewController.h"
#import "AppDelegate.h"

@interface SPContactMyGroupViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray <SPGroupModel *> *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPContactMyGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUp];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUpNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"我的群组";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -20;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backBarButtonItem];
}

- (void)setUp {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
}

- (void)networkRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPIMBusinessUnit shareInstance] getMyGroupsWithUserId:userId successful:^(JSONModel *model) {
        if (model) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            _dataArray = ((SPMyGroupsModel *)model).data;
            [_tableView reloadData];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

#pragma mark - Action
- (void)navBackAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPContactTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SPContactTableViewCell *)cell setUpWithGroupImageName:_dataArray[indexPath.row].portrait title:_dataArray[indexPath.row].name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
//    SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:[_dataArray[indexPath.row] groupId]];
//    chatViewController.hidesBottomBarWhenPushed = true;
//    RCConversationModel *model = [[RCConversationModel alloc] init];
//    model.conversationTitle = [_dataArray[indexPath.row] name];
//    chatViewController.model = model;
 
    SPChatGroupViewController *groupChatViewController = [[SPChatGroupViewController alloc] initWithConversationType:ConversationType_GROUP targetId:[_dataArray[indexPath.row] groupId]];
    groupChatViewController.hidesBottomBarWhenPushed = true;
    RCConversationModel *model = [[RCConversationModel alloc] init];
    model.conversationTitle = [_dataArray[indexPath.row] name];
    model.targetId = [_dataArray[indexPath.row] groupId];
    model.conversationType = ConversationType_GROUP;
    groupChatViewController.model = model;
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    groupChatViewController.indexPath = indexPath;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ((UITabBarController *)delegate.window.rootViewController).selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:false];
    //[((UITabBarController *)delegate.window.rootViewController).selectedViewController pushViewController:chatViewController animated:true];
    [((UITabBarController *)delegate.window.rootViewController).selectedViewController pushViewController:groupChatViewController animated:true];
}

@end
