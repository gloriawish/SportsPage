//
//  SPPersonalMessageNotificationViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalMessageNotificationViewController.h"

#import "SPPersonalMessageNotificationTableViewCell.h"

@interface SPPersonalMessageNotificationViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalMessageNotificationViewController

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
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
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
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalMessageNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageNotificationCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalMessageNotificationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MessageNotificationCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MessageNotificationCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [(SPPersonalMessageNotificationTableViewCell *)cell setUpWithContent:@"接受消息通知" isOn:true];
        } else {
            [(SPPersonalMessageNotificationTableViewCell *)cell setUpWithContent:@"显示消息详情" isOn:true];
        }
    } else {
        if (indexPath.row == 0) {
            [(SPPersonalMessageNotificationTableViewCell *)cell setUpWithContent:@"声音" isOn:true];
        } else {
            [(SPPersonalMessageNotificationTableViewCell *)cell setUpWithContent:@"震动" isOn:true];
        }
    }
}

@end
