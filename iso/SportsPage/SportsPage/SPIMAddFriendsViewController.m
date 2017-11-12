//
//  SPIMAddFriendsViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPIMAddFriendsViewController.h"
#import "SPContactTableViewCell.h"

#import "SPIMSearchCheckFriendViewController.h"

#import "SPUserInfoModel.h"
#import "SPIMBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPIMAddFriendsViewController () <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    NSMutableArray <SPUserInfoModel *>*_dataArray;
    UISearchBar *_searchBar;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPIMAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUp];
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
- (void)setUpNav {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.navigationController.navigationBar.translucent = false;
    
    self.title = @"添加好友";
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -20;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelButton.frame = CGRectMake(0, 0, 50, 25);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelButton titleLabel].font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, barButton];
}

- (void)setUp {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    
    _tableView.tableHeaderView = _searchBar;
}

#pragma mark - Action
- (IBAction)dismissAction:(id)sender {
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell *friendsListCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!friendsListCell) {
        friendsListCell = [[[NSBundle mainBundle] loadNibNamed:@"SPContactTableViewCell" owner:nil options:nil] lastObject];
    }
    return friendsListCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SPContactTableViewCell *)cell setupWithModel:_dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPIMSearchCheckFriendViewController *searchCheckFriendViewController = [[SPIMSearchCheckFriendViewController alloc] init];
    searchCheckFriendViewController.userInfoModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:searchCheckFriendViewController animated:true];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    if (searchText.length != 0) {
        [self searchKeyAction:searchText];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return true;
}

- (void)searchKeyAction:(NSString *)searchKey {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPIMBusinessUnit shareInstance] searchFriendWithUserId:userId searchKey:searchKey successful:^(NSString *successfulString, JSONModel *model) {
        if ([successfulString isEqualToString:@"successful"]) {
            _dataArray = [(SPFriendsModel *)model data];
            if (_dataArray.count != 0) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                [_tableView reloadData];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"未搜索到相应结果" ToView:self.view];
                });
            }
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

@end
