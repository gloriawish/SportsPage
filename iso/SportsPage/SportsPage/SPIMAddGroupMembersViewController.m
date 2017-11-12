//
//  SPIMAddGroupMembersViewController.m
//  SportsPage
//
//  Created by Qin on 2017/1/10.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPIMAddGroupMembersViewController.h"

#import "AppDelegate.h"
#import "SPUserInfoModel.h"

#import "SPContactTableViewCell.h"

#import "SPIMBusinessUnit.h"
#import "MBProgressHUD.h"

@interface SPIMAddGroupMembersViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_friendsDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *addMembersButton;

@end

@implementation SPIMAddGroupMembersViewController

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
    
    [_dismissButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [_addMembersButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_addMembersButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _addMembersButton.layer.cornerRadius = 5;
    _addMembersButton.layer.masksToBounds = true;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.allowsMultipleSelectionDuringEditing = true;
    _tableView.editing = true;
    
}


#pragma mark - Action
- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)addMembersAction:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    sender.userInteractionEnabled = false;
    
    NSArray <NSIndexPath *> *indexPathArray = [_tableView indexPathsForSelectedRows];
    if (!indexPathArray) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"请选择好友" ToView:self.view];
            sender.userInteractionEnabled = true;
        });
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
    
    [[SPIMBusinessUnit shareInstance] joinGroupBatchWithGroupId:_targetId userIds:targetIdStr successful:^(NSString *retString) {
        if ([retString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"添加群成员成功" ToView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:true completion:nil];
                    sender.userInteractionEnabled = true;
                });
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:retString ToView:self.view];
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
