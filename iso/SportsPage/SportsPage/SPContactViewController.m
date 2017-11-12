//
//  SPContactViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPContactViewController.h"
#import "SPSearchResultTableViewController.h"
#import "SPContactTableViewCell.h"
#import "SPCheckFriendViewController.h"

#import "SPContactMyGroupViewController.h"

#import "AppDelegate.h"
#import "SPUserInfoModel.h"

@interface SPContactViewController () <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating> {
    
    NSMutableArray *_searchResultsArray;
    NSMutableArray *_friendsDataArray;
    NSMutableArray <SPUserInfoModel *>*_friendsPinYinDataArray;
    
    UIView *_statusBarView;
    dispatch_once_t _onceToken;
}

@property (strong,nonatomic,readwrite) UISearchController * searchController;

@end

@implementation SPContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareForFriendsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        return false;
    }
    return true;
}

#pragma mark - SetUp
- (void)prepareForFriendsData {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _friendsDataArray = delegate.friendsSortedListArray;
    [_tableView reloadData];
}

- (void)setUpNav {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar_black"] forBarMetrics:UIBarMetricsDefault];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"通讯录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;

}

- (void)setUp {
    self.definesPresentationContext = true;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _searchController.searchBar;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:240 green:240 blue:246 alpha:1];

    SPSearchResultTableViewController *searchResult = [[SPSearchResultTableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:searchResult];
    _searchController.delegate = self;
    _searchController.dimsBackgroundDuringPresentation = false;
    _searchController.obscuresBackgroundDuringPresentation = false;
    _searchController.hidesNavigationBarDuringPresentation = true;
    
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchController.searchBar.backgroundColor = [SPGlobalConfig anyColorWithRed:240 green:240 blue:246 alpha:1];
    _searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    [_searchController.searchBar sizeToFit];
    _tableView.tableHeaderView = _searchController.searchBar;
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _friendsDataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //return 2;
        return 1;
    } else {
        return [[[_friendsDataArray[section-1] allValues] objectAtIndex:0] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 20;
    }
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
    if (section != 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        NSString *titleStr = [_friendsDataArray[section-1] allKeys][0];
        label.text = [NSString stringWithFormat:@"      %@",[titleStr uppercaseString]];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textColor = [SPGlobalConfig anyColorWithRed:142 green:142 blue:146 alpha:1];
        label.backgroundColor = [SPGlobalConfig anyColorWithRed:240 green:240 blue:246 alpha:1];
        return label;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell *friendsListCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!friendsListCell) {
        friendsListCell = [[[NSBundle mainBundle] loadNibNamed:@"SPContactTableViewCell" owner:nil options:nil] lastObject];
    }
    return friendsListCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            [(SPContactTableViewCell *)cell setUpWithImageName:@"IM_newFriends" content:@"新的好友"];
//        } else if (indexPath.row == 1) {
//            [(SPContactTableViewCell *)cell setUpWithImageName:@"IM_myGroups" content:@"我的群组"];
//        }
        [(SPContactTableViewCell *)cell setUpWithImageName:@"IM_myGroups" content:@"我的群组"];
    } else {
        SPUserInfoModel *model = (SPUserInfoModel *)[[[_friendsDataArray[indexPath.section-1] allValues] objectAtIndex:0] objectAtIndex:indexPath.row];
        [(SPContactTableViewCell *)cell setupWithModel:model];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            
//        } else if (indexPath.row == 1) {
//            SPContactMyGroupViewController *myGroupsViewController = [[SPContactMyGroupViewController alloc] init];
//            myGroupsViewController.hidesBottomBarWhenPushed = true;
//            [self.navigationController pushViewController:myGroupsViewController animated:true];
//        }
        SPContactMyGroupViewController *myGroupsViewController = [[SPContactMyGroupViewController alloc] init];
        myGroupsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:myGroupsViewController animated:true];
    } else {
        SPUserInfoModel *model = (SPUserInfoModel *)[[[_friendsDataArray[indexPath.section-1] allValues] objectAtIndex:0] objectAtIndex:indexPath.row];
        SPCheckFriendViewController *checkVC = [[SPCheckFriendViewController alloc] init];
        checkVC.selfUserId = false;
        checkVC.turnFromContacts = true;
        checkVC.turnFromChat = false;
        checkVC.userId = model.userId;
        checkVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:checkVC animated:true];
    }
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    SPSearchResultTableViewController *searchResultController = (SPSearchResultTableViewController *)searchController.searchResultsController;
    dispatch_once(&_onceToken, ^{
        if (!_statusBarView) {
            _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
            _statusBarView.backgroundColor = [SPGlobalConfig anyColorWithRed:240 green:240 blue:246 alpha:1];
            [searchResultController.tableView.superview addSubview:_statusBarView];
        } else {
            [searchResultController.tableView.superview addSubview:_statusBarView];
        }
    });
    
    NSString *searchText = [SPGlobalConfig convertToPinYin:searchController.searchBar.text];
    if (searchText.length == 0) {
        NSLog(@"[_searchResultsArray removeAllObjects]");
        [_searchResultsArray removeAllObjects];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pinyinNick contains [c]%@",searchText];
        _searchResultsArray = [[_friendsPinYinDataArray filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    
    searchResultController.searchResultsArray = _searchResultsArray;
    [searchResultController.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate
- (void)presentSearchController:(UISearchController *)searchController {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *tempArray = delegate.friendsListArray;
    _friendsPinYinDataArray = [[NSMutableArray alloc] init];
    for (int i=0; i<tempArray.count; i++) {
        SPUserInfoModel *model = tempArray[i];
        model.pinyinNick = [SPGlobalConfig convertToPinYin:model.nick];
        [_friendsPinYinDataArray addObject:model];
    }
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    CGRect frame = self.tabBarController.tabBar.frame;
    if (frame.origin.y == SCREEN_HEIGHT - frame.size.height) {
        frame.origin.y += 49;
        self.tabBarController.tabBar.frame = frame;
    }
    _tableView.hidden = true;
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    CGRect frame = self.tabBarController.tabBar.frame;
    if (frame.origin.y == SCREEN_HEIGHT) {
        frame.origin.y -= 49;
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.frame = frame;
        }];
    }
    _tableView.hidden = false;
}

- (void)didDismissSearchController:(UISearchController *)searchController {
//    _searchController = nil;
//    _friendsPinYinDataArray = nil;
    _onceToken = 0;
    [_statusBarView removeFromSuperview];
}

@end
