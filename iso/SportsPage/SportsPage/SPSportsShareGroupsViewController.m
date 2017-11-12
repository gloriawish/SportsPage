//
//  SPSportsShareGroupsViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsShareGroupsViewController.h"
#import "SPContactTableViewCell.h"

#import "SPIMBusinessUnit.h"
#import "SPMyGroupsModel.h"

#import "MBProgressHUD.h"

@interface SPSportsShareGroupsViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray <SPGroupModel *> *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPSportsShareGroupsViewController

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
    if ([_shareBaseViewController.type isEqualToString:@"clubShare"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLUB_SHARE
                                                            object:nil
                                                          userInfo:@{@"type":@"group",
                                                                     @"targetId":_dataArray[indexPath.row].groupId,
                                                                     @"title":_dataArray[indexPath.row].name}];
        [_shareBaseViewController.navigationController popViewControllerAnimated:true];
        [_shareBaseViewController.navigationController popViewControllerAnimated:true];
    } else if ([_shareBaseViewController.type isEqualToString:@"eventShare"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPORTS_SHARE
                                                            object:nil
                                                          userInfo:@{@"type":@"group",
                                                                     @"targetId":_dataArray[indexPath.row].groupId,
                                                                     @"title":_dataArray[indexPath.row].name}];
        [_shareBaseViewController.navigationController popViewControllerAnimated:true];
        [_shareBaseViewController.navigationController popViewControllerAnimated:true];
    }
    
}


@end
