//
//  SPClubMembersListViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/6.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPClubMembersListViewController.h"

#import "SPSportBusinessUnit.h"

#import "SPContactTableViewCell.h"

#import "MBProgressHUD.h"

#import "SPClubMembersAddNorViewController.h"
#import "SPClubMembersDeleteNorViewController.h"
#import "SPClubMembersAddAdminViewController.h"
#import "SPClubMembersDeleteAdminViewController.h"

@interface SPClubMembersListViewController () <UITableViewDelegate,UITableViewDataSource,SPClubMembersDeleteNorViewControllerProtocol,SPClubMembersAddAdminViewControllerProtocol,SPClubMembersDeleteAdminViewControllerProtocol> {
    NSString *_clubId;
    SPClubMembersListViewControllerUserIdentity _identity;
    
    NSMutableArray *_adminArray;
    NSMutableArray *_normalMembersArray;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPClubMembersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 |--------------------------------------------
 |           成员设置
 |--------------------------------------------
 |游客
 |           不能操作
 |--------------------------------------------
 |普通成员
 |           不能操作
 |--------------------------------------------
 |管理员
 |           增加成员 --------> 用户好友列表
 |           删除成员 --------> 俱乐部普通成员列表
 |--------------------------------------------
 |创建人
 |           设置管理员 ------> 俱乐部普通成员列表
 |           删除管理员 ------> 俱乐部管理员列表
 |           增加成员  -------> 用户好友列表
 |           删除成员  -------> 俱乐部普通成员列表
 |--------------------------------------------
 */

#pragma mark - SetUp
- (void)setUp {
    [self setUpTableView];
}

- (void)setUpTableView {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
}

- (void)setUpClubId:(NSString *)clubId userIdentity:(SPClubMembersListViewControllerUserIdentity)identity {
    _clubId = clubId;
    _identity = identity;
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

- (IBAction)moreButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionAdd = [UIAlertAction actionWithTitle:@"添加成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SPClubMembersAddNorViewController *addNorViewController = [[SPClubMembersAddNorViewController alloc] init];
        [addNorViewController setUpClubId:_clubId];
        [self.navigationController presentViewController:addNorViewController animated:true completion:nil];
        sender.userInteractionEnabled = true;
        
    }];
    [alertController addAction:actionAdd];
    
    UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"删除成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SPClubMembersDeleteNorViewController *deleteNorViewController = [[SPClubMembersDeleteNorViewController alloc] init];
        [deleteNorViewController setUpNormalMembersArray:_normalMembersArray clubId:_clubId];
        deleteNorViewController.delegate = self;
        [self.navigationController presentViewController:deleteNorViewController animated:true completion:nil];
        sender.userInteractionEnabled = true;
        
    }];
    [alertController addAction:actionDelete];
    
    if (_identity == SPClubMembersListViewControllerUserIdentityCreator) {
        UIAlertAction *actionAddAdmin = [UIAlertAction actionWithTitle:@"设置管理员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            SPClubMembersAddAdminViewController *addAdminViewController = [[SPClubMembersAddAdminViewController alloc] init];
            [addAdminViewController setUpNormalMembersArray:_normalMembersArray clubId:_clubId];
            addAdminViewController.delegate = self;
            [self.navigationController presentViewController:addAdminViewController animated:true completion:nil];
            sender.userInteractionEnabled = true;
            
        }];
        [alertController addAction:actionAddAdmin];
        
        UIAlertAction *actionDeleteAdmin = [UIAlertAction actionWithTitle:@"移除管理员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            SPClubMembersDeleteAdminViewController *deleteAdminViewController = [[SPClubMembersDeleteAdminViewController alloc] init];
            [deleteAdminViewController setUpAdminArray:_adminArray clubId:_clubId];
            deleteAdminViewController.delegate = self;
            [self.navigationController presentViewController:deleteAdminViewController animated:true completion:nil];
            sender.userInteractionEnabled = true;
            
        }];
        [alertController addAction:actionDeleteAdmin];
    }
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        sender.userInteractionEnabled = true;
    }];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:true completion:nil];
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
#pragma mark - SPClubMembersDeleteNorViewControllerProtocol
- (void)finishedDeleteNorAction {
    [self networkRequest];
}

#pragma mark - SPClubMembersAddAdminViewControllerProtocol
- (void)finishedAddAdminAction {
    [self networkRequest];
}

#pragma mark - SPClubMembersDeleteAdminViewControllerProtocol
- (void)finishedDeleteAdminAction {
    [self networkRequest];
}

@end
