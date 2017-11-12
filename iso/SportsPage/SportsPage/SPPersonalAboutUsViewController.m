//
//  SPPersonalAboutUsViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/13.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAboutUsViewController.h"

#import "SPPersonalSettingTableViewCell.h"

#import "SPBootViewController.h"

@interface SPPersonalAboutUsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*233/375)];
    headImageView.image = [UIImage imageNamed:@"Mine_sys_aboutus_logo"];
    _tableView.tableHeaderView = headImageView;
    
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    [(SPPersonalSettingTableViewCell *)cell setUpWithContent:@"查看引导页"];
    [(SPPersonalSettingTableViewCell *)cell lineView].hidden = true;
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( M_PI_4/2 , 0.0, 0.7, 0.4);
    rotation = CATransform3DScale(rotation, 0.8, 0.8, 1);
    rotation.m34 = 1.0/ 1000;
    cell.layer.shadowColor = [[UIColor whiteColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotation;
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.6];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    SPBootViewController *bootViewController = [[SPBootViewController alloc] init];
    bootViewController.isMine = true;
    [self.navigationController pushViewController:bootViewController animated:true];
}

@end
