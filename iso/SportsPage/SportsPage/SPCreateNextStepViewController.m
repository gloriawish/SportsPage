//
//  SPCreateNextStepViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/9.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateNextStepViewController.h"

#import "SPCreateEventTableViewCell.h"

#import "SPSelectDateView.h"
#import "SPCreateTimeView.h"
#import "SPMemberBorderView.h"
#import "SPCreateFinishView.h"

#import "SPSportsActiveRequestModel.h"

#import "SPSportBusinessUnit.h"
#import "SPLastEventModel.h"
#import "MBProgressHUD.h"

@interface SPCreateNextStepViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    UIView *_footView;
    UITextField *_textField;
    
    SPCreateEventTableViewCell *_lvCell;
    SPCreateEventTableViewCell *_priceCell;
    SPCreateEventTableViewCell *_chargeCell;
    SPCreateEventTableViewCell *_privacyCell;
    
    SPLastEventModel *_lastEventModel;
}

@property (weak, nonatomic) IBOutlet UIButton *jumpToActiveButton;

@end

@implementation SPCreateNextStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - SetUp
- (void)setUp {
    self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    [_jumpToActiveButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [self setUpTableViewHeader];
    [self setUpTableViewFooter];
    [self setUpTableView];
}

- (void)setUpTableViewHeader {
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 9*SCREEN_WIDTH/16)];
    headerImageView.image = _uploadImage;
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, headerImageView.frame.size.height, SCREEN_WIDTH, 45)];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 44.5, SCREEN_WIDTH-30, 0.5)];
    lineView1.backgroundColor = [SPGlobalConfig anyColorWithRed:220 green:220 blue:220 alpha:1];
    [nameView addSubview:lineView1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:nameView.bounds];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _sportsName;
    [nameView addSubview:titleLabel];
    
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(0, headerImageView.frame.size.height+45, SCREEN_WIDTH, 45)];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 44.5, SCREEN_WIDTH-30, 0.5)];
    lineView2.backgroundColor = [SPGlobalConfig anyColorWithRed:220 green:220 blue:220 alpha:1];
    [locationView addSubview:lineView2];
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:locationView.bounds];
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.text = _sportsLocation;
    [locationView addSubview:locationLabel];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerImageView.frame.size.height+90)];
    [headerView addSubview:headerImageView];
    [headerView addSubview:nameView];
    [headerView addSubview:locationView];
    
    UITapGestureRecognizer *cancelKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [headerView addGestureRecognizer:cancelKeyboardTap];
    
    _tableView.tableHeaderView = headerView;
}

- (void)setUpTableViewFooter {
    _finishedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishedButton.frame = CGRectMake(31, 30, SCREEN_WIDTH-62, 50);
    _finishedButton.layer.cornerRadius = 5;
    _finishedButton.layer.masksToBounds = true;
    [_finishedButton setTitle:@"完成" forState:UIControlStateNormal];
    [_finishedButton setBackgroundColor:[SPGlobalConfig anyColorWithRed:13 green:136 blue:235 alpha:1]];
    [_finishedButton addTarget:self action:@selector(finishedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *stepImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-55)/2, 100, 55, 22)];
    stepImageView.image = [UIImage imageNamed:@"Sports_create_step2"];
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 142)];
    [_footView addSubview:_finishedButton];
    [_footView addSubview:stepImageView];
    
    _tableView.tableFooterView = _footView;
}

- (void)setUpTableView {
    
    if (_isFirstActive) {
        _dataStringArray = [[NSMutableArray alloc] init];
        [_dataStringArray addObject:@""];
        [_dataStringArray addObject:@""];
        [_dataStringArray addObject:@""];
        
        _imageArray = [[NSMutableArray alloc] initWithArray:@[@"Sports_create_step2_lv",
                                                              @"Sports_create_step2_date",
                                                              @"Sports_create_step2_time",
                                                              @"Sports_create_step2_person",
                                                              @"Sports_create_step2_charge",
                                                              @"Sports_create_step2_charge",
                                                              @"Sports_create_step2_privacy_blue"]];
    } else {
        //获取最后一次激活数据
        _tableView.hidden = true;
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [[SPSportBusinessUnit shareInstance] getLastEventWithSportId:_sportId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            
            if ([successsfulString isEqualToString:@"successful"]) {
                
                _lastEventModel = (SPLastEventModel *)jsonModel;
                
                _imageArray = [[NSMutableArray alloc] initWithArray:@[@"Sports_create_step2_lv_blue",
                                                                      @"Sports_create_step2_date_blue",
                                                                      @"Sports_create_step2_time_blue",
                                                                      @"Sports_create_step2_person_blue",
                                                                      @"Sports_create_step2_charge_blue",
                                                                      @"Sports_create_step2_charge_blue",
                                                                      @"Sports_create_step2_privacy_blue"]];
                
                _dataStringArray = [[NSMutableArray alloc] init];
                
                if (_lastEventModel.start_time.length != 0) {
                    [_dataStringArray addObject:[_lastEventModel.start_time substringWithRange:NSMakeRange(0, 10)]];
                    
                    NSString *timeStr = [_lastEventModel.start_time substringWithRange:NSMakeRange(11, 5)];
                    NSString *durationStr = @"";
                    if ([_lastEventModel.duration containsString:@".00"]) {
                        durationStr = [_lastEventModel.duration stringByReplacingOccurrencesOfString:@".00" withString:@""];
                    } else {
                        durationStr = [_lastEventModel.duration substringWithRange:NSMakeRange(0, _lastEventModel.duration.length-1)];
                    }
                    timeStr = [NSString stringWithFormat:@"%@  时长%@小时",timeStr,durationStr];
                    [_dataStringArray addObject:timeStr];
                } else {
                    [_dataStringArray addObject:@""];
                    [_dataStringArray addObject:@""];
                    
                    [_imageArray replaceObjectAtIndex:1 withObject:@"Sports_create_step2_date"];
                    [_imageArray replaceObjectAtIndex:2 withObject:@"Sports_create_step2_time"];
                }
                
                if (_lastEventModel.min_number.length != 0 && _lastEventModel.max_number.length != 0) {
                    [_dataStringArray addObject:[NSString stringWithFormat:@"%@人 ~ %@人",_lastEventModel.min_number,_lastEventModel.max_number]];
                } else {
                    [_dataStringArray addObject:@""];
                    [_imageArray replaceObjectAtIndex:3 withObject:@"Sports_create_step2_person"];
                }
                
                _tableView.hidden = false;
                [_tableView reloadData];
                
            } else {
                NSLog(@"getLastEvent ERROR:%@",successsfulString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                _tableView.hidden = false;
                
                _dataStringArray = [[NSMutableArray alloc] init];
                [_dataStringArray addObject:@""];
                [_dataStringArray addObject:@""];
                [_dataStringArray addObject:@""];
                
                _imageArray = [[NSMutableArray alloc] initWithArray:@[@"Sports_create_step2_lv",
                                                                      @"Sports_create_step2_date",
                                                                      @"Sports_create_step2_time",
                                                                      @"Sports_create_step2_person",
                                                                      @"Sports_create_step2_charge",
                                                                      @"Sports_create_step2_charge",
                                                                      @"Sports_create_step2_privacy_blue"]];
            }
            
        } failure:^(NSString *errorString) {
            NSLog(@"getLastEvent AFN ERROR:%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            _tableView.hidden = false;
            
            _dataStringArray = [[NSMutableArray alloc] init];
            [_dataStringArray addObject:@""];
            [_dataStringArray addObject:@""];
            [_dataStringArray addObject:@""];

        }];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (SPSportsActiveRequestModel *)setUpActiveRequestModel {
    SPSportsActiveRequestModel *model = [[SPSportsActiveRequestModel alloc] init];
    if ([_dataStringArray[0] length] != 0) {
        model.date = _dataStringArray[0];
    } else {
        model.date = @"";
    }
    
    if ([_dataStringArray[1] length] != 0) {
        model.time = _dataStringArray[1];
    } else {
        model.time = @"";
    }
    
    if ([_dataStringArray[2] length] != 0) {
        model.memberBorder = _dataStringArray[2];
    } else {
        model.memberBorder = @"";
    }
    
    if (_textField.text.length != 0) {
        model.price = _textField.text;
    } else {
        model.price = @"";
    }
    
    if ([_lvCell.contentLabel.text isEqualToString:@"简单"]) {
        model.level = @"1";
    } else if ([_lvCell.contentLabel.text isEqualToString:@"一般"]) {
        model.level = @"2";
    } else if ([_lvCell.contentLabel.text isEqualToString:@"困难"]) {
        model.level = @"3";
    } else {
        model.level = @"";
    }
    
    if ([model.price isEqualToString:@"0"]) {
        model.chargeType = @"2";
    } else {
        if ([_chargeCell.contentLabel.text isEqualToString:@"线上"]) {
            model.chargeType = @"1";
        } else if ([_chargeCell.contentLabel.text isEqualToString:@"线下"]) {
            model.chargeType = @"2";
        } else {
            model.chargeType = @"";
        }
    }
    
    if ([_privacyCell.contentLabel.text isEqualToString:@"是"]) {
        model.privacy = @"1";
    } else if ([_privacyCell.contentLabel.text isEqualToString:@"否"]) {
        model.privacy = @"0";
    } else {
        model.privacy = @"";
    }
    return model;
}

#pragma mark - Action
- (void)cancelKeyboard:(UITapGestureRecognizer *)sender {
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
}

- (IBAction)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)turnToMainAction {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)finishedAction:(UIButton *)sender {
    
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    
    SPSportsActiveRequestModel *model = [self setUpActiveRequestModel];
    
    if (model.level.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"运动等级未填写" ToView:self.view];
        return;
    } else if (model.date.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"开始日期未填写" ToView:self.view];
        return;
    } else if (model.time.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"时间设置未填写" ToView:self.view];
        return;
    } else if (model.memberBorder.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"人数范围未填写" ToView:self.view];
        return;
    } else if (model.price.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"活动价格未填写" ToView:self.view];
        return;
    } else if (model.chargeType.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"收费方式未填写" ToView:self.view];
        return;
    }
    
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",model.date,[[model.time componentsSeparatedByString:@" "] firstObject]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval selectedTimeInterval = [[formatter dateFromString:timeString] timeIntervalSinceDate:[NSDate date]];
    if (selectedTimeInterval < 3600*3) {
        [SPGlobalConfig showTextOfHUD:@"报名时间不足三小时,请选择三小时后的时间" ToView:self.view];
        return;
    }
    
    
    if (!_isSubWindowDisplay) {
        _isSubWindowDisplay = true;
        
        if (!_windowImageView) {
            _windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _windowImageView.image = [UIImage imageNamed:@"Sports_create_windowBG"];
            _windowImageView.alpha = 0;
        }
        [self.view addSubview:_windowImageView];
        
        //SPSportsActiveRequestModel *model = [self setUpActiveRequestModel];
        
        SPCreateFinishView *finishView = [[[NSBundle mainBundle] loadNibNamed:@"SPCreateFinishView" owner:nil options:nil] lastObject];
        finishView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        finishView.createNextStepViewController = self;
        [finishView setUpDataWithModel:model];
        [self.view addSubview:finishView];
        
        [UIView animateWithDuration:0.3 animations:^{
            _windowImageView.alpha = 1;
            finishView.confirmView.alpha = 1;
            finishView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];

    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPCreateEventTableViewCell *cell = (SPCreateEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CreateEventCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPCreateEventTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CreateEventCell"];
        cell = (SPCreateEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CreateEventCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        if (!_lvCell) {
            _lvCell = cell;
        }
    } else if (indexPath.row == 4) {
        if (!_priceCell) {
            _priceCell = cell;
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-15, 45)];
            _textField.textAlignment = NSTextAlignmentRight;
            _textField.borderStyle = UITextBorderStyleNone;
            _textField.font = [UIFont systemFontOfSize:13];
            _textField.textColor = [SPGlobalConfig anyColorWithRed:135 green:135 blue:135 alpha:1];
            _textField.delegate = self;
            //_textField.keyboardType = UIKeyboardTypeNumberPad;
            _textField.keyboardType = UIKeyboardTypeDecimalPad;
            [cell addSubview:_textField];
        }
    } else if (indexPath.row == 5) {
        if (!_chargeCell) {
            _chargeCell = cell;
        }
    } else if (indexPath.row == 6) {
        if (!_privacyCell) {
            _privacyCell = cell;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SPCreateEventTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [cell setUpCellWithSelectedViewHidden1:false
                           selectedViewHidden2:false
                           selectedViewHidden3:false
                                  switchHidden:true
                            contentLabelHidden:true];
        [cell setUpCellWithContent1:@"困难" content2:@"一般" content3:@"简单"];
        [cell setUpCellImageView:_imageArray[0] title:@"运动等级"];
        if (!_isFirstActive) {
            [cell setUpWithFillUpData:@"运动等级" model:_lastEventModel];
        }
    } else if (indexPath.row == 1) {
        [cell setUpCellWithSelectedViewHidden1:true
                           selectedViewHidden2:true
                           selectedViewHidden3:true
                                  switchHidden:true
                            contentLabelHidden:false];
        [cell setUpCellImageView:_imageArray[1] title:@"开始日期"];
        [cell setUpCellContent:_dataStringArray[0]];
    } else if (indexPath.row == 2) {
        [cell setUpCellWithSelectedViewHidden1:true
                           selectedViewHidden2:true
                           selectedViewHidden3:true
                                  switchHidden:true
                            contentLabelHidden:false];
        [cell setUpCellImageView:_imageArray[2] title:@"时间设置"];
        [cell setUpCellContent:_dataStringArray[1]];
    } else if (indexPath.row == 3) {
        [cell setUpCellWithSelectedViewHidden1:true
                           selectedViewHidden2:true
                           selectedViewHidden3:true
                                  switchHidden:true
                            contentLabelHidden:false];
        [cell setUpCellImageView:_imageArray[3] title:@"人数范围"];
        [cell setUpCellContent:_dataStringArray[2]];
    } else if (indexPath.row == 4) {
        [cell setUpCellWithSelectedViewHidden1:true
                           selectedViewHidden2:true
                           selectedViewHidden3:true
                                  switchHidden:true
                            contentLabelHidden:true];
        [cell setUpCellImageView:_imageArray[4] title:@"活动价格"];
        if (!_isFirstActive) {
            _textField.text = [NSString stringWithFormat:@"%ld",(long)[_lastEventModel.price integerValue]];
        }
    } else if (indexPath.row == 5) {
        [cell setUpCellWithSelectedViewHidden1:false
                           selectedViewHidden2:false
                           selectedViewHidden3:true
                                  switchHidden:true
                            contentLabelHidden:true];
        [cell setUpCellWithContent1:@"线下" content2:@"线上" content3:@""];
        [cell setUpCellImageView:_imageArray[5] title:@"收费方式"];
        if (!_isFirstActive) {
            [cell setUpWithFillUpData:@"收费方式" model:_lastEventModel];
        }
    } else if (indexPath.row == 6) {
        [cell setUpCellWithSelectedViewHidden1:true
                           selectedViewHidden2:true
                           selectedViewHidden3:true
                                  switchHidden:false
                            contentLabelHidden:true];
        [cell setUpCellImageView:_imageArray[6] title:@"是否公开"];
        [cell setUpCellContent:@"否"];
        if (!_isFirstActive) {
            [cell setUpWithFillUpData:@"是否公开" model:_lastEventModel];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_textField isFirstResponder] && indexPath.row != 4) {
        [_textField resignFirstResponder];
        return;
    }
    
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        
        if (!_isSubWindowDisplay) {
            _isSubWindowDisplay = true;
            
            if (!_windowImageView) {
                _windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _windowImageView.image = [UIImage imageNamed:@"Sports_create_windowBG"];
                _windowImageView.alpha = 0;
            }
            [self.view addSubview:_windowImageView];
            
            if (indexPath.row == 1) {
                //开始日期
                SPSelectDateView *selectDateView = [[[NSBundle mainBundle] loadNibNamed:@"SPSelectDateView" owner:nil options:nil] lastObject];
                selectDateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                selectDateView.createNextStepViewController = self;
                selectDateView.indexPath = indexPath;
                [self.view addSubview:selectDateView];
                
                [UIView animateWithDuration:0.3 animations:^{
                    _windowImageView.alpha = 1;
                    selectDateView.dateSelectView.alpha = 1;
                    selectDateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }];
            } else if (indexPath.row == 2) {
                //时间设置
                SPCreateTimeView *timeView = [[[NSBundle mainBundle] loadNibNamed:@"SPCreateTimeView" owner:nil options:nil] lastObject];
                timeView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                timeView.createNextStepViewController = self;
                timeView.indexPath = indexPath;
                [self.view addSubview:timeView];
                
                [UIView animateWithDuration:0.3 animations:^{
                    _windowImageView.alpha = 1;
                    timeView.timePickerView.alpha = 1;
                    timeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }];
            } else if (indexPath.row == 3) {
                //人数范围
                SPMemberBorderView *memberView = [[[NSBundle mainBundle] loadNibNamed:@"SPMemberBorderView" owner:nil options:nil] lastObject];
                memberView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                memberView.createNextStepViewController = self;
                memberView.indexPath = indexPath;
                [self.view addSubview:memberView];
                
                [UIView animateWithDuration:0.3 animations:^{
                    _windowImageView.alpha = 1;
                    memberView.memberPickerView.alpha = 1;
                    memberView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }];
            }
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length != 0) {
        _priceCell.headerImageView.image = [UIImage imageNamed:@"Sports_create_step2_charge_blue"];
    } else {
        _priceCell.headerImageView.image = [UIImage imageNamed:@"Sports_create_step2_charge"];
    }
    return true;
}

#pragma mark - Keyboard
#warning 键盘监听 TODO

@end
