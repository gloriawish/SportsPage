//
//  SPSportsClubMembersListViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/30.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsClubMembersListViewController.h"

#import "SPContactTableViewCell.h"

#import "SPSportBusinessUnit.h"

#import "MBProgressHUD.h"

#import "SPSportsClubMembersListCheckMembersViewController.h"

@interface SPSportsClubMembersListViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_adminArray;
    NSMutableArray *_normalMembersArray;
    
    NSString *_clubId;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPSportsClubMembersListViewController

- (instancetype)initWithClubId:(NSString *)clubId {
    self = [super init];
    if (self) {
        _clubId = clubId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    [self setUpTableView];
}

- (void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
}

- (void)networkRequest {
    _tableView.hidden = true;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[SPSportBusinessUnit shareInstance] getClubAllMemebersWithClubId:_clubId successful:^(NSMutableArray *adminArray, NSMutableArray *normalMembersArray) {
        
        if (adminArray && normalMembersArray) {
            _adminArray = adminArray;
            _normalMembersArray = normalMembersArray;
            
            [_tableView reloadData];
            _tableView.hidden = false;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
    
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _normalMembersArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _adminArray.count;
    } else {
        return [[[_normalMembersArray[section-1] allValues] objectAtIndex:0] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 120)];
    if (section == 0) {
        label.text = [NSString stringWithFormat:@"      创建人, 管理员(%lu人)",(unsigned long)_adminArray.count];
    } else {
        NSString *titleStr = [_normalMembersArray[section-1] allKeys][0];
        label.text = [NSString stringWithFormat:@"      %@",[titleStr uppercaseString]];
    }
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [SPGlobalConfig anyColorWithRed:142 green:142 blue:146 alpha:1];
    label.backgroundColor = [SPGlobalConfig anyColorWithRed:240 green:240 blue:246 alpha:1];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPContactTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContactCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SPContactTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [cell setupWithModel:_adminArray[indexPath.row]];
    } else {
        [cell setupWithModel:[[[_normalMembersArray[indexPath.section-1] allValues] objectAtIndex:0] objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSString *targetId = [_adminArray[indexPath.row] userId];
        SPSportsClubMembersListCheckMembersViewController *checkembersViewController = [[SPSportsClubMembersListCheckMembersViewController alloc] initWithTargetId:targetId];
        [self.navigationController pushViewController:checkembersViewController animated:true];
    } else if (indexPath.section >= 1) {
        NSString *targetId = [[[[_normalMembersArray[indexPath.section-1] allValues] objectAtIndex:0] objectAtIndex:indexPath.row] userId];
        SPSportsClubMembersListCheckMembersViewController *checkembersViewController = [[SPSportsClubMembersListCheckMembersViewController alloc] initWithTargetId:targetId];
        [self.navigationController pushViewController:checkembersViewController animated:true];
    }
}

@end
