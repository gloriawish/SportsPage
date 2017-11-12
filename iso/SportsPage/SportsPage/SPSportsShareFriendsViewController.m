//
//  SPSportsShareFriendsViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsShareFriendsViewController.h"

#import "AppDelegate.h"
#import "SPUserInfoModel.h"

#import "SPContactTableViewCell.h"

#import "SPIMBusinessUnit.h"
#import "MBProgressHUD.h"

@interface SPSportsShareFriendsViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_friendsDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPSportsShareFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareForFriendsData];
}

#pragma mark - SetUp
- (void)prepareForFriendsData {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _friendsDataArray = delegate.friendsSortedListArray;
    [_tableView reloadData];
}

- (void)setUp {
    _friendsDataArray = [[NSMutableArray alloc] init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _friendsDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_friendsDataArray[section] allValues] objectAtIndex:0] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:UITableViewIndexSearch];
    for (NSDictionary *dic in _friendsDataArray) {
        [array addObject:[(NSString *)[dic allKeys][0] uppercaseString]];
    }
    return array;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    NSString *titleStr = [_friendsDataArray[section] allKeys][0];
    label.text = [NSString stringWithFormat:@"      %@",[titleStr uppercaseString]];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [SPGlobalConfig anyColorWithRed:142 green:142 blue:146 alpha:1];
    label.backgroundColor = [SPGlobalConfig anyColorWithRed:240 green:240 blue:246 alpha:1];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell *friendsListCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!friendsListCell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPContactTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactCell"];
        friendsListCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    }
    return friendsListCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SPUserInfoModel *model = (SPUserInfoModel *)[[[_friendsDataArray[indexPath.section] allValues] objectAtIndex:0] objectAtIndex:indexPath.row];
    [(SPContactTableViewCell *)cell setupWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if ([_shareBaseViewController.type isEqualToString:@"clubShare"]) {
        SPUserInfoModel *model = (SPUserInfoModel *)[[[_friendsDataArray[indexPath.section] allValues] objectAtIndex:0] objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLUB_SHARE
                                                            object:nil
                                                          userInfo:@{@"type":@"person",
                                                                     @"targetId":model.userId,
                                                                     @"title":model.nick}];
        [_shareBaseViewController.navigationController popViewControllerAnimated:true];
    } else if ([_shareBaseViewController.type isEqualToString:@"eventShare"]) {
        SPUserInfoModel *model = (SPUserInfoModel *)[[[_friendsDataArray[indexPath.section] allValues] objectAtIndex:0] objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPORTS_SHARE
                                                            object:nil
                                                          userInfo:@{@"type":@"person",
                                                                     @"targetId":model.userId,
                                                                     @"title":model.nick}];
        [_shareBaseViewController.navigationController popViewControllerAnimated:true];
    }
}

@end
