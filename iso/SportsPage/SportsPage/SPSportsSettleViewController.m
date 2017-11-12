//
//  SPSportsSettleViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/9.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsSettleViewController.h"

#import "SPSportsOrderTableViewCell.h"

#import "SPSportBusinessUnit.h"
#import "MBProgressHUD.h"

@interface SPSportsSettleViewController () <UITableViewDelegate,UITableViewDataSource> {
    SPEventModel *_eventModel;
    NSMutableArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation SPSportsSettleViewController

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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
    lineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    [headerView addSubview:lineView];
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 1)];
    sepView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    [headerView addSubview:sepView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, SCREEN_WIDTH, 45)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = _eventModel.title;
    [headerView addSubview:titleLabel];
    _tableView.tableHeaderView = headerView;
    
    _priceLabel.text = [_dataArray lastObject];
    
    _bottomLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    
    _finishedButton.layer.cornerRadius = 8;
    _finishedButton.layer.masksToBounds = true;
    [_finishedButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_finishedButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
}

- (void)setUpWithModel:(SPEventModel *)model {
    _eventModel = model;
    
    _dataArray = [[NSMutableArray alloc] init];
    
    NSString *startTime = [model.start_time substringWithRange:NSMakeRange(0, 10)];
    [_dataArray addObject:startTime];
    
    NSString *durTime = [NSString stringWithFormat:@"%@-%@",[model.start_time substringWithRange:NSMakeRange(11, 5)],[model.end_time substringWithRange:NSMakeRange(11, 5)]];
    [_dataArray addObject:durTime];
    
    [_dataArray addObject:model.location];
    
    if ([model.price isEqualToString:@"0.00"]) {
        [_dataArray addObject:@"免费"];
    } else {
        [_dataArray addObject:[NSString stringWithFormat:@"%@元/人",model.price]];
    }
    
    NSString *enrollUsers = [NSString stringWithFormat:@"%lu人",model.enrollUsers.count];
    [_dataArray addObject:enrollUsers];
    
    if ([model.charge_type isEqualToString:@"1"]) {
        [_dataArray addObject:@"线上"];
    } else if ([model.charge_type isEqualToString:@"2"]) {
        [_dataArray addObject:@"线下"];
    }
    
    [_dataArray addObject:[NSString stringWithFormat:@"￥%@",_priceStr]];
}


#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)finishedButton:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] settlementEventWithUserId:userId eventId:_eventId successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"结算成功" ToView:self.view];
                sender.userInteractionEnabled = true;
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 6;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportsOrderCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPSportsOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SportsOrderCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SportsOrderCell"];
    }
    cell.userInteractionEnabled = false;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_date"
                                                             title:@"开始日期"
                                                           content:_dataArray[0]
                                                    lineViewHidden:false];
        } else if (indexPath.row == 1) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_time"
                                                             title:@"开始时间"
                                                           content:_dataArray[1]
                                                    lineViewHidden:false];
        } else if (indexPath.row == 2) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_location"
                                                             title:@"地址"
                                                           content:_dataArray[2]
                                                    lineViewHidden:true];
        }
    } else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_price"
                                                             title:@"价格"
                                                           content:_dataArray[3]
                                                    lineViewHidden:false];
        } else if (indexPath.row == 1) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Mine_personal_username"
                                                             title:@"参与人数"
                                                           content:_dataArray[4]
                                                    lineViewHidden:false];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_chargeType"
                                                             title:@"收费方式"
                                                           content:_dataArray[5]
                                                    lineViewHidden:false];
        } else if (indexPath.row == 1) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_inall"
                                                             title:@"结算金额"
                                                           content:_dataArray[6]
                                                    lineViewHidden:false];
        }
    }
}

@end
