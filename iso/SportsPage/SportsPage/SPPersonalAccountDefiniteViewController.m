//
//  SPPersonalAccountDefiniteViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/1.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAccountDefiniteViewController.h"

#import "SPPersonalAccountDefiniteTableViewCell.h"

#import "SPPINGBusinessUnit.h"
#import "SPPersonalAccountDefiniteResponseModel.h"

@interface SPPersonalAccountDefiniteViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray <SPPersonalAccountDefiniteModel *>*_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalAccountDefiniteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self requsetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
    header.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
    _tableView.tableHeaderView = header;
    _tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)requsetData {
    _dataArray = [[NSMutableArray alloc] init];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPPINGBusinessUnit shareInstance] getDaybooksWithUserId:userId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            _dataArray = [(SPPersonalAccountDefiniteResponseModel *)jsonModel data];
            [_tableView reloadData];
        } else {
            NSLog(@"%@",successsfulString);
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getDaybooks AFN ERROR:%@",errorString);
    }];
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalAccountDefiniteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountDefiniteCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalAccountDefiniteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AccountDefiniteCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"AccountDefiniteCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalAccountDefiniteModel *model = _dataArray[indexPath.row];
    [(SPPersonalAccountDefiniteTableViewCell *)cell setUpWithType:model.type balance:model.balance time:model.time money:model.amount remark:model.remark];
}

@end
