//
//  SPSearchResultTableViewController.m
//  SportsPage
//
//  Created by Qin on 2016/10/26.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSearchResultTableViewController.h"
#import "SPContactTableViewCell.h"
#import "SPContactViewController.h"
#import "SPChatViewController.h"

#import <RongIMKit/RongIMKit.h>

@interface SPSearchResultTableViewController () 

@end

@implementation SPSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell *friendsListCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!friendsListCell) {
        friendsListCell = [[[NSBundle mainBundle] loadNibNamed:@"SPContactTableViewCell" owner:nil options:nil] lastObject];
    }
    return friendsListCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SPContactTableViewCell *)cell setupWithModel:_searchResultsArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    SPUserInfoModel *userModel = _searchResultsArray[indexPath.row];
    
    SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:1 targetId:userModel.userId];
    RCConversationModel *conversationModel = [[RCConversationModel alloc] init];
    if (userModel.remark.length != 0) {
        conversationModel.conversationTitle = userModel.remark;
    } else {
        conversationModel.conversationTitle = userModel.nick;
    }
    chatViewController.model = conversationModel;
    
    [((SPContactViewController *)self.presentingViewController).navigationController pushViewController:chatViewController animated:true];
}

- (void)dealloc {
    NSLog(@"searchViewController dealloc");
}

@end
