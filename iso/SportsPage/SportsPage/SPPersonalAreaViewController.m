//
//  SPPersonalAreaViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAreaViewController.h"

#import "SPPersonalSettingTableViewCell.h"

#import "SPUserBusinessUnit.h"
#import "MBProgressHUD.h"

@interface SPPersonalAreaViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalAreaViewController

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
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = _tableView.backgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(23, 25, SCREEN_WIDTH-23, 20)];
    label.text = @"全部";
    label.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:label];
    
    _tableView.tableHeaderView = headerView;
}

#pragma mark - Action
- (IBAction)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_dataArray sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if ([obj1 compare:obj2] == NSOrderedDescending) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    [(SPPersonalSettingTableViewCell *)cell setUpWithContent:_dataArray[indexPath.row]];
    ((SPPersonalSettingTableViewCell *)cell).moreImageView.hidden = true;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSString *cityStr = [NSString stringWithFormat:@"%@ %@",_contentStr,_dataArray[indexPath.row]];
    _personalInfoCell.contentLabel.text = cityStr;

    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPUserBusinessUnit shareInstance] updateCityWithUserId:userId city:cityStr successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:true];
        } else {
            NSLog(@"%@",successsfulString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        NSLog(@"AFN ERROR:%@",errorString);
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
