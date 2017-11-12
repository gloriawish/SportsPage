//
//  SPSPortsOrderViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/25.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSPortsOrderViewController.h"
#import "SPSportsOrderTableViewCell.h"
#import "SPSportsChargeTypeView.h"
#import "SPSportsOrderFinishedViewController.h"

#import "SPSportBusinessUnit.h"
#import "SPPINGBusinessUnit.h"

#import "MBProgressHUD.h"
#import "DCPaymentView.h"

@interface SPSPortsOrderViewController () <UITableViewDelegate,UITableViewDataSource> {
    SPEventModel *_eventModel;
    NSMutableArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation SPSPortsOrderViewController

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
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_eventModel.price];
    
    _finishedButton.layer.cornerRadius = 8;
    _finishedButton.layer.masksToBounds = true;
    [_finishedButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_finishedButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    _bottomLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NOTIFICATION_SPORTS_ORDER_PAYPASS object:nil];
}

- (void)setUpWithModel:(SPEventModel *)model {
    _eventModel = model;
    
    _dataArray = [[NSMutableArray alloc] init];

    NSString *startTime = [model.start_time substringWithRange:NSMakeRange(0, 10)];
    [_dataArray addObject:startTime];

    NSString *durTime = [NSString stringWithFormat:@"%@-%@",[model.start_time substringWithRange:NSMakeRange(11, 5)],[model.end_time substringWithRange:NSMakeRange(11, 5)]];
    [_dataArray addObject:durTime];
    
    [_dataArray addObject:model.location];
    
    if ([model.charge_type isEqualToString:@"1"]) {
        [_dataArray addObject:@"线上"];
    } else if ([model.charge_type isEqualToString:@"2"]) {
        [_dataArray addObject:@"线下"];
    }
    
    if ([model.price isEqualToString:@"0.00"]) {
        [_dataArray addObject:@"免费"];
    } else {
        [_dataArray addObject:[NSString stringWithFormat:@"%@元/人",model.price]];
    }
    
    if (model.user_id.nick.length == 0) {
        [_dataArray addObject:model.user_id.uname];
    } else {
        [_dataArray addObject:model.user_id.nick];
    }
    
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)finishedbuttonAction:(UIButton *)sender {
    [MBProgressHUD  showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] enrollEventWithUserId:userId eventId:_eventModel.event_id successful:^(NSString *code, NSDictionary *resultDic) {
        if ([code isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            if ([_dataArray[3] isEqualToString:@"线上"]) {
                if (!_windowImageView) {
                    _windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    _windowImageView.image = [UIImage imageNamed:@"Sports_create_windowBG"];
                    _windowImageView.alpha = 0;
                }
                [self.view addSubview:_windowImageView];
                
                SPSportsChargeTypeView *chargeTypeView = [[[NSBundle mainBundle] loadNibNamed:@"SPSportsChargeTypeView" owner:nil options:nil] lastObject];
                chargeTypeView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                chargeTypeView.sportsOrderViewController = self;
                chargeTypeView.orderNo = resultDic[@"orderNo"];
                chargeTypeView.needPaypass = resultDic[@"needPaypass"];
                [chargeTypeView setUpWithBalance:resultDic[@"balance"] price:_eventModel.price];
                [self.view addSubview:chargeTypeView];
                
                [UIView animateWithDuration:0.3 animations:^{
                    _windowImageView.alpha = 1;
                    self.navigationController.navigationBar.alpha = 0;
                    chargeTypeView.chargeTypeView.alpha = 1;
                    chargeTypeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }];
                
            } else if ([_dataArray[3] isEqualToString:@"线下"]) {
                SPSportsOrderFinishedViewController *finishedViewConrtoller = [[SPSportsOrderFinishedViewController alloc] init];
                __weak UINavigationController *nav = self.navigationController;
                [nav popToRootViewControllerAnimated:false];
                finishedViewConrtoller.hidesBottomBarWhenPushed = true;
                [nav pushViewController:finishedViewConrtoller animated:true];
            }
        } else {
            NSLog(@"%@",code);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:code ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        NSLog(@"enrollEvent AFN ERROR:%@",errorString);
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

#pragma mark - NotificationAction
- (void)notificationAction:(NSNotification *)notification {
    NSString *userId = notification.userInfo[@"userId"];
    NSString *orderNo = notification.userInfo[@"orderNo"];
    NSString *price = notification.userInfo[@"price"];
    
    DCPaymentView *payAlert = [[DCPaymentView alloc] init];
    payAlert.titleStr = @"请输入支付密码";
    payAlert.detail = @"金额";
    payAlert.amount = [price integerValue];
    [payAlert show];
    payAlert.completeHandle = ^(NSString *inputPwd) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [[SPPINGBusinessUnit shareInstance] orderPaymentWithUserId:userId orderNo:orderNo paypass:inputPwd successful:^(NSString *successfulString) {
            if ([successfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                SPSportsOrderFinishedViewController *finishedViewController = [[SPSportsOrderFinishedViewController alloc] init];
                [self.navigationController pushViewController:finishedViewController animated:true];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successfulString ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
    };
    
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
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
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_chargeType"
                                                             title:@"收费方式"
                                                           content:_dataArray[3]
                                                    lineViewHidden:false];
        } else if (indexPath.row == 1) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_price"
                                                             title:@"价格"
                                                           content:_dataArray[4]
                                                    lineViewHidden:false];
        } else if (indexPath.row == 2) {
            [(SPSportsOrderTableViewCell *)cell setUpWithImageName:@"Sports_order_initiate"
                                                             title:@"发起人"
                                                           content:_dataArray[5]
                                                    lineViewHidden:false];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPORTS_ORDER_PAYPASS object:nil];
    NSLog(@"%s",__func__);
}

@end
