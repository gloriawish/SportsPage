//
//  SPIMSearchCheckFriendViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPIMSearchCheckFriendViewController.h"

#import "SPUserInfoTableViewCell.h"
#import "SPOtherInfoTableViewCell.h"

#import "SPIMBusinessUnit.h"

#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface SPIMSearchCheckFriendViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPIMSearchCheckFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUpNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = _userInfoModel.nick;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -20;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backBarButtonItem];
}

- (void)setUp {
    _titleLabel.text = _userInfoModel.nick;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if (![userId isEqualToString:_userInfoModel.userId]) {
        UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendMessageButton.frame = CGRectMake(25, 0, SCREEN_WIDTH-50, 50);
        sendMessageButton.backgroundColor = [SPGlobalConfig themeColor];
        [sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendMessageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [sendMessageButton setTitle:@"添加好友" forState:UIControlStateNormal];
        [sendMessageButton addTarget:self action:@selector(footerViewClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        sendMessageButton.layer.cornerRadius = 8;
        sendMessageButton.layer.masksToBounds = true;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [footerView addSubview:sendMessageButton];
        
        _tableView.tableFooterView = footerView;
    }
}

#pragma mark - Action
- (void)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)footerViewClickedAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPIMBusinessUnit shareInstance] addFriendWithUserId:userId friendId:_userInfoModel.userId message:@"" extra:@"" successful:^(NSString *retString) {
        if ([retString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"添加请求发送成功" ToView:self.view];
                sender.userInteractionEnabled = true;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController dismissViewControllerAnimated:true completion:nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
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
        [(SPUserInfoTableViewCell *)cell setupWithUserInfoModel:_userInfoModel];
        cell.userInteractionEnabled = false;
    } else {
            [(SPOtherInfoTableViewCell *)cell titleLabel].text = @"地区";
            if (_userInfoModel.city.length == 0 && _userInfoModel.area.length == 0) {
                [(SPOtherInfoTableViewCell *)cell contentLabel].text = @"保密";
            } else if (_userInfoModel.city.length == 0 && _userInfoModel.area.length != 0) {
                [(SPOtherInfoTableViewCell *)cell contentLabel].text = _userInfoModel.area;
            } else if (_userInfoModel.city.length != 0 && _userInfoModel.area.length == 0) {
                [(SPOtherInfoTableViewCell *)cell contentLabel].text = _userInfoModel.city;
            } else if (_userInfoModel.city.length != 0 && _userInfoModel.area.length != 0) {
                NSString *areaStr = [NSString stringWithFormat:@"%@ %@",_userInfoModel.city,_userInfoModel.area];
                [(SPOtherInfoTableViewCell *)cell contentLabel].text = areaStr;
            }
            [(SPOtherInfoTableViewCell *)cell moreImage].hidden = true;
            cell.userInteractionEnabled = false;
    }
}

@end
