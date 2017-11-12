//
//  SPClubMembersAddNorViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/9.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPClubMembersAddNorViewController.h"

#import "SPContactTableViewCell.h"

//#import "AppDelegate.h"

#import "SPSportBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPClubMembersAddNorViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_friendsDataArray;
    NSString *_clubId;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addMembersButton;

@end

@implementation SPClubMembersAddNorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareForFriendsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)prepareForFriendsData {
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    _friendsDataArray = delegate.friendsSortedListArray;
//    [_tableView reloadData];

    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] getNotJoinClubFriendsWithUserId:userId clubId:_clubId successful:^(NSMutableArray *friendsSortedList, NSMutableArray *friendsList) {
        if (friendsSortedList && friendsList) {
            _friendsDataArray = friendsSortedList;
            [_tableView reloadData];
        } else {
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        }
    } failure:^(NSString *errorString) {
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
    }];
}

- (void)setUp {
    _friendsDataArray = [[NSMutableArray alloc] init];
    [self setUpUI];
    [self setUpTableView];
}

- (void)setUpUI {
    [_addMembersButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_addMembersButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _addMembersButton.layer.cornerRadius = 5;
    _addMembersButton.layer.masksToBounds = true;
}

- (void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.allowsMultipleSelectionDuringEditing = true;
    _tableView.editing = true;
}

- (void)setUpClubId:(NSString *)clubId {
    _clubId = clubId;
}

#pragma mark - Action
- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)addMembersAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    NSArray <NSIndexPath *> *indexPathArray = [_tableView indexPathsForSelectedRows];
    if (!indexPathArray) {
        [SPGlobalConfig showTextOfHUD:@"请选择成员" ToView:self.view];
        sender.userInteractionEnabled = true;
        return;
    }
    
    NSMutableArray *strArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPathArray) {
        NSDictionary *dic = [_friendsDataArray objectAtIndex:indexPath.section];
        NSArray *array = [[dic allValues] objectAtIndex:0];
        SPUserInfoModel *model = [array objectAtIndex:indexPath.row];
        [strArray addObject:[model userId]];
    }
    NSString *targetIdStr = [strArray componentsJoinedByString:@","];
    NSLog(@"targetIdStr:%@",targetIdStr);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    [[SPSportBusinessUnit shareInstance] inviteJoinClubWithClubId:_clubId userId:userId targetIds:targetIdStr extend:@"请求添加进俱乐部" successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            sender.userInteractionEnabled = true;
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [SPGlobalConfig showTextOfHUD:@"添加请求已发送成功" ToView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:true completion:nil];
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                sender.userInteractionEnabled = true;
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            sender.userInteractionEnabled = true;
        });
    }];
    
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

@end
