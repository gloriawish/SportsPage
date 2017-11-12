//
//  SPPersonalInfoSettingViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalInfoSettingViewController.h"

#import "SPPersonalSettingTableViewCell.h"

#import "SPPersonalAreaViewController.h"

@interface SPPersonalInfoSettingViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSDictionary *_cityDic;
    NSArray *_sortCityArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillData];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - SetUp
- (void)fillData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    _cityDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
}

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
    return _cityDic.count;
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
    _sortCityArray = [_cityDic allKeys];
    _sortCityArray = [_sortCityArray sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    [(SPPersonalSettingTableViewCell *)cell setUpWithContent:_sortCityArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    SPPersonalAreaViewController *areaViewController = [[SPPersonalAreaViewController alloc] init];
    areaViewController.dataArray = _cityDic[_sortCityArray[indexPath.row]];
    areaViewController.personalInfoCell = _personalInfoCell;
    areaViewController.contentStr = _sortCityArray[indexPath.row];
    [self.navigationController pushViewController:areaViewController animated:true];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
