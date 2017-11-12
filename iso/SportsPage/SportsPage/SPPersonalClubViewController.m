//
//  SPPersonalClubViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/10.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalClubViewController.h"

#import "SPPersonalClubTableViewCell.h"

#import "SPClubListResponseModel.h"

#import "SPSportBusinessUnit.h"

#import "MJRefresh.h"

#import "SPSportsClubViewController.h"

#import "SPCreateClubBaseViewController.h"

@interface SPPersonalClubViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray <SPClubListModel *> *_clubCreateDataArray;
    NSMutableArray <SPClubListModel *> *_clubJoinDataArray;
    NSMutableArray <SPClubListModel *> *_clubAdminDataArray;
    
}


@property (weak, nonatomic) IBOutlet UIButton *createClubButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - SetUp
- (void)setUp {
    
    [_createClubButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [self setUpTableView];
    [self setUpRefreshControl];
}

- (void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
}

- (void)setUpRefreshControl {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self networkRequest];
    }];
    _tableView.mj_header = header;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                [_tableView setContentOffset:CGPointMake(0, -60)];
            } completion:^(BOOL finished) {
                [_tableView.mj_header beginRefreshing];
            }];
        });
    });
    
}

- (void)networkRequest {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] getUserClubsWithUserId:userId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        
        if ([successsfulString isEqualToString:@"successful"]) {
            
            SPClubListResponseModel *listResponseModel = (SPClubListResponseModel *)jsonModel;
            
            _clubCreateDataArray = listResponseModel.create;
            _clubAdminDataArray = listResponseModel.admin;
            _clubJoinDataArray = listResponseModel.join;

            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
            
        } else {
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
        }
        
    } failure:^(NSString *errorString) {
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
    }];
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)createClubAction:(UIButton *)sender {
    SPCreateClubBaseViewController *createClubBaseViewController = [[SPCreateClubBaseViewController alloc] init];
    [self.navigationController pushViewController:createClubBaseViewController animated:true];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionNum = 0;
    if (_clubCreateDataArray.count != 0) {
        sectionNum++;
    }
    
    if (_clubAdminDataArray.count != 0) {
        sectionNum++;
    }
    
    if (_clubJoinDataArray.count != 0) {
        sectionNum++;
    }
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count != 0) {
        if (section == 0) {
            return _clubCreateDataArray.count;
        } else if (section == 1) {
            return _clubAdminDataArray.count;
        } else if (section == 2) {
            return _clubJoinDataArray.count;
        }
    }
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count == 0) {
        if (section == 0) {
            return _clubCreateDataArray.count;
        } else if (section == 1) {
            return _clubAdminDataArray.count;
        }
    }
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count != 0) {
        if (section == 0) {
            return _clubCreateDataArray.count;
        } else if (section == 1) {
            return _clubJoinDataArray.count;
        }
    }
    
    if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count != 0) {
        if (section == 0) {
            return _clubAdminDataArray.count;
        } else if (section == 1) {
            return _clubJoinDataArray.count;
        }
    }
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count == 0) {
        if (section == 0) {
            return _clubCreateDataArray.count;
        }
    }
    
    if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count == 0) {
        if (section == 0) {
            return _clubAdminDataArray.count;
        }
    }
    
    if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count != 0) {
        if (section == 0) {
            return _clubJoinDataArray.count;
        }
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_clubCreateDataArray.count != 0 || _clubAdminDataArray.count != 0 || _clubJoinDataArray.count != 0) {
        return 20;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count == 0) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [SPGlobalConfig anyColorWithRed:142 green:142 blue:146 alpha:1];
    label.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count != 0) {
        if (section == 0) {
            label.text = @"      我创建的";
        } else if (section == 1) {
            label.text = @"      我管理的";
        } else if (section == 2) {
            label.text = @"      我加入的";
        }
    }
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count == 0) {
        if (section == 0) {
            label.text = @"      我创建的";
        } else if (section == 1) {
            label.text = @"      我管理的";
        }
    }
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count != 0) {
        if (section == 0) {
            label.text = @"      我创建的";
        } else if (section == 1) {
            label.text = @"      我加入的";
        }
    }
    
    if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count != 0) {
        if (section == 0) {
            label.text = @"      我管理的";
        } else if (section == 1) {
            label.text = @"      我加入的";
        }
    }
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count == 0) {
        label.text = @"      我创建的";
    }
    
    if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count == 0) {
        label.text = @"      我管理的";
    }
    
    if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count != 0) {
        label.text = @"      我加入的";
    }
    
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPPersonalClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalClubTableViewCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalClubTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalClubTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalClubTableViewCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SPPersonalClubTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count == 0) {
        //创建
        [cell setUpClubListModel:_clubCreateDataArray[indexPath.row]];
        
    } else if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count == 0) {
        //管理
        [cell setUpClubListModel:_clubAdminDataArray[indexPath.row]];
        
    } else if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count != 0) {
        //加入
        [cell setUpClubListModel:_clubJoinDataArray[indexPath.row]];
        
    } else if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count == 0) {
        //创建 管理
        if (indexPath.section == 0) {
            [cell setUpClubListModel:_clubCreateDataArray[indexPath.row]];
        } else if (indexPath.section == 1) {
            [cell setUpClubListModel:_clubAdminDataArray[indexPath.row]];
        }
        
    } else if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count != 0) {
        //创建 加入
        if (indexPath.section == 0) {
            [cell setUpClubListModel:_clubCreateDataArray[indexPath.row]];
        } else if (indexPath.section == 1) {
            [cell setUpClubListModel:_clubJoinDataArray[indexPath.row]];
        }
        
    } else if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count != 0) {
        //管理 加入
        if (indexPath.section == 0) {
            [cell setUpClubListModel:_clubAdminDataArray[indexPath.row]];
        } else if (indexPath.section == 1) {
            [cell setUpClubListModel:_clubJoinDataArray[indexPath.row]];
        }
        
    } else if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count != 0) {
        //创建 管理 加入
        if (indexPath.section == 0) {
            [cell setUpClubListModel:_clubCreateDataArray[indexPath.row]];
        } else if (indexPath.section == 1) {
            [cell setUpClubListModel:_clubAdminDataArray[indexPath.row]];
        } else if (indexPath.section == 2) {
            [cell setUpClubListModel:_clubJoinDataArray[indexPath.row]];
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count == 0) {
        //创建
        SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
        clubViewController.clubId = [_clubCreateDataArray[indexPath.row] clubId];
        [self.navigationController pushViewController:clubViewController animated:true];
        
    } else if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count == 0) {
        //管理
        SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
        clubViewController.clubId = [_clubAdminDataArray[indexPath.row] clubId];
        [self.navigationController pushViewController:clubViewController animated:true];
        
    } else if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count != 0) {
        //加入
        SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
        clubViewController.clubId = [_clubJoinDataArray[indexPath.row] clubId];
        [self.navigationController pushViewController:clubViewController animated:true];
        
    } else if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count == 0) {
        //创建 管理
        SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
        if (indexPath.section == 0) {
            clubViewController.clubId = [_clubCreateDataArray[indexPath.row] clubId];
        } else if (indexPath.section == 1) {
            clubViewController.clubId = [_clubAdminDataArray[indexPath.row] clubId];
        }
        [self.navigationController pushViewController:clubViewController animated:true];
        
    } else if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count == 0 && _clubJoinDataArray.count != 0) {
        //创建 加入
        SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
        if (indexPath.section == 0) {
            clubViewController.clubId = [_clubCreateDataArray[indexPath.row] clubId];
        } else if (indexPath.section == 1) {
            clubViewController.clubId = [_clubJoinDataArray[indexPath.row] clubId];
        }
        [self.navigationController pushViewController:clubViewController animated:true];
        
    } else if (_clubCreateDataArray.count == 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count != 0) {
        //管理 加入
        SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
        if (indexPath.section == 0) {
            clubViewController.clubId = [_clubAdminDataArray[indexPath.row] clubId];
        } else if (indexPath.section == 1) {
            clubViewController.clubId = [_clubJoinDataArray[indexPath.row] clubId];
        }
        [self.navigationController pushViewController:clubViewController animated:true];
        
    } else if (_clubCreateDataArray.count != 0 && _clubAdminDataArray.count != 0 && _clubJoinDataArray.count != 0) {
        //创建 管理 加入
        SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
        if (indexPath.section == 0) {
            clubViewController.clubId = [_clubCreateDataArray[indexPath.row] clubId];
        } else if (indexPath.section == 1) {
            clubViewController.clubId = [_clubAdminDataArray[indexPath.row] clubId];
        } else if (indexPath.section == 2) {
            clubViewController.clubId = [_clubJoinDataArray[indexPath.row] clubId];
        }
        [self.navigationController pushViewController:clubViewController animated:true];
        
    }
    
}

@end
