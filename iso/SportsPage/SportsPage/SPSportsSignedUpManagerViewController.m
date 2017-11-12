//
//  SPSportsSignedUpManagerViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsSignedUpManagerViewController.h"

#import "SPSportsSignedUpTableViewCell.h"

#import "SPIMBusinessUnit.h"

#import "MBProgressHUD.h"


@interface SPSportsSignedUpManagerViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendsButton;

@end

@implementation SPSportsSignedUpManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    [_allButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [_addFriendsButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_addFriendsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _addFriendsButton.layer.cornerRadius = 5;
    _addFriendsButton.layer.masksToBounds = true;
    
    [self dataHandle];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.allowsMultipleSelectionDuringEditing = true;
    _tableView.editing = true;
}

- (void)dataHandle {
    if (![_initiateInfoModel.relation isEqualToString:@"0"]) {
        _initiateInfoModel = nil;
    }
    for (int i=0; i<_dataArray.count; i++) {
        SPUserInfoModel *model = _dataArray[i];
        if (![model.relation isEqualToString:@"0"]) {
            [_dataArray removeObjectAtIndex:i];
            i--;
        }
    }
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)selectAllAction:(id)sender {
    if (_initiateInfoModel) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionBottom];
    }
    for (int i=0; i<_dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        [_tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionBottom];
    }
}

- (IBAction)addFriendsAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSMutableArray *strArray = [[NSMutableArray alloc] init];
    NSArray <NSIndexPath *> *indexPathArray = [_tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in indexPathArray) {
        SPSportsSignedUpTableViewCell *cell = (SPSportsSignedUpTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [strArray addObject:[cell getTargetId]];
    }
    if (strArray.count == 0) {
        sender.userInteractionEnabled = true;
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [SPGlobalConfig showTextOfHUD:@"请选择内容" ToView:self.view];
        return;
    }
    NSString *retStr = [strArray componentsJoinedByString:@","];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPIMBusinessUnit shareInstance] addFriendBatchWithUserId:userId friendIds:retStr message:@"" extra:@"" successful:^(NSString *retString) {
        if ([retString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"添加好友成功" ToView:self.view];
                _addFriendsButton.userInteractionEnabled = true;
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:retString ToView:self.view];
                _addFriendsButton.userInteractionEnabled = true;
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            _addFriendsButton.userInteractionEnabled = true;
        });
    }];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, 20)];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    if (section == 0) {
        label.text = @"发起人";
    } else {
        label.text = @"参与人";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_initiateInfoModel) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsSignedUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportsSignedUpCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPSportsSignedUpTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SportsSignedUpCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SportsSignedUpCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SPUserInfoModel *model = _initiateInfoModel;
        NSString *initiateStr = nil;
        if (model.nick.length != 0) {
            initiateStr = model.nick;
        } else {
            initiateStr = model.uname;
        }
        [(SPSportsSignedUpTableViewCell *)cell setUpWithImageName:model.portrait initiate:initiateStr type:@"-1" targetId:model.userId];
    } else {
        SPUserInfoModel *model = _dataArray[indexPath.row];
        NSString *initiateStr = nil;
        if (model.nick.length != 0) {
            initiateStr = model.nick;
        } else {
            initiateStr = model.uname;
        }
        [(SPSportsSignedUpTableViewCell *)cell setUpWithImageName:model.portrait initiate:initiateStr type:@"-1" targetId:model.userId];
    }
}

@end
