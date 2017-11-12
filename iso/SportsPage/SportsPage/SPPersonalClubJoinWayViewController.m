//
//  SPPersonalClubJoinWayViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalClubJoinWayViewController.h"

#import "SPSportBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPPersonalClubJoinWayViewController () {
    
    NSString *_clubId;
    
    SPPersonalClubJoinWayStyle _style;
}

@property (weak, nonatomic) IBOutlet UIView *selectedView1;
@property (weak, nonatomic) IBOutlet UIView *selectedView2;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView2;

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;

@end

@implementation SPPersonalClubJoinWayViewController

- (instancetype)initWithStyle:(SPPersonalClubJoinWayStyle)style clubId:(NSString *)clubId {
    self = [super init];
    if (self) {
        _style = style;
        _clubId = clubId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    _label1.textColor = [SPGlobalConfig anyColorWithRed:153 green:153 blue:153 alpha:1];
    _label2.textColor = [SPGlobalConfig anyColorWithRed:153 green:153 blue:153 alpha:1];
    
    _lineView1.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _lineView2.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    [self setUpGesture:_selectedView1];
    [self setUpGesture:_selectedView2];
    
    if (_style == SPPersonalClubJoinWayStyleHasConfirm) {
        _selectedImageView1.hidden = true;
        _selectedImageView2.hidden = false;
    } else if (_style == SPPersonalClubJoinWayStyleNoConfirm) {
        _selectedImageView1.hidden = false;
        _selectedImageView2.hidden = true;
    }
}

- (void)setUpGesture:(UIView *)sender {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    sender.userInteractionEnabled = true;
    [sender addGestureRecognizer:tap];
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    if (sender.view == _selectedView1) {
        if (_style == SPPersonalClubJoinWayStyleHasConfirm) {
            _style = SPPersonalClubJoinWayStyleNoConfirm;
            _selectedImageView1.hidden = false;
            _selectedImageView2.hidden = true;
        }
    } else if (sender.view == _selectedView2) {
        if (_style == SPPersonalClubJoinWayStyleNoConfirm) {
            _style = SPPersonalClubJoinWayStyleHasConfirm;
            _selectedImageView1.hidden = true;
            _selectedImageView2.hidden = false;
        }
    }
}

- (IBAction)submitJoinClubWayAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *joinType = nil;
    
    if (_style == SPPersonalClubJoinWayStyleHasConfirm) {
        joinType = @"2";
    } else if (_style == SPPersonalClubJoinWayStyleNoConfirm) {
        joinType = @"1";
    }
    
    [[SPSportBusinessUnit shareInstance] updateJoinTypeWithUserId:userId clubId:_clubId joinType:joinType successful:^(NSString *successsfulString) {
        sender.userInteractionEnabled = true;
        if ([successsfulString isEqualToString:@"successful"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"更改成功" ToView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_delegate respondsToSelector:@selector(updateJoinType:)]) {
                        [_delegate updateJoinType:_style];
                    }
                    [self.navigationController popViewControllerAnimated:true];
                });
            });
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        sender.userInteractionEnabled = true;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}



@end
