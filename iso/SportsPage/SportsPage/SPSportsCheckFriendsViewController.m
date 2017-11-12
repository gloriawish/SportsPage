//
//  SPSportsCheckFriendsViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsCheckFriendsViewController.h"

#import "SPIMBusinessUnit.h"

#import "SPUserInfoTableViewCell.h"
#import "SPOtherInfoTableViewCell.h"

@interface SPSportsCheckFriendsViewController () <UITableViewDelegate,UITableViewDataSource> {
    SPUserInfoModel *_userModel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPSportsCheckFriendsViewController

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
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - NetworkRequest
- (void)networkRequest {
    [[SPIMBusinessUnit shareInstance] getUserInfoWithUserId:_targetId success:^(JSONModel *model) {
        if (model) {
            NSLog(@"获取用户信息成功");
            _userModel = (SPUserInfoModel *)model;
            [_tableView reloadData];
        } else {
            NSLog(@"获取用户信息失败");
        }
    } failure:^(NSString *errorString) {
        NSLog(@"获取用户信息失败:%@",errorString);
    }];
}


#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    } else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SPUserInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserInfoCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"OtherInfoCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SPOtherInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherInfoCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"OtherInfoCell"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [(SPUserInfoTableViewCell *)cell setupWithUserInfoModel:_userModel];
        cell.userInteractionEnabled = false;
    } else if (indexPath.section == 1) {
        [(SPOtherInfoTableViewCell *)cell titleLabel].text = @"地区";
        if (_userModel.city.length == 0 && _userModel.area.length == 0) {
            [(SPOtherInfoTableViewCell *)cell contentLabel].text = @"保密";
        } else if (_userModel.city.length == 0 && _userModel.area.length != 0) {
            [(SPOtherInfoTableViewCell *)cell contentLabel].text = _userModel.area;
        } else if (_userModel.city.length != 0 && _userModel.area.length == 0) {
            [(SPOtherInfoTableViewCell *)cell contentLabel].text = _userModel.city;
        } else if (_userModel.city.length != 0 && _userModel.area.length != 0) {
            NSString *areaStr = [NSString stringWithFormat:@"%@ %@",_userModel.city,_userModel.area];
            [(SPOtherInfoTableViewCell *)cell contentLabel].text = areaStr;
        }
        [(SPOtherInfoTableViewCell *)cell moreImage].hidden = true;
        cell.userInteractionEnabled = false;
    }
}

@end
