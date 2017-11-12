//
//  SPClubInviewListTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2017/4/6.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPClubInviewListTableViewCell.h"

#import "SPClubInviteListResponseModel.h"
#import "SPClubApplyListResponseModel.h"

#import "UIImageView+WebCache.h"

#import "SPSportBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPClubInviewListTableViewCell () {
    SPClubInviteListModel *_inviteModel;
    SPClubApplyListModel *_applyModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *clubImageView;
@property (weak, nonatomic) IBOutlet UILabel *clubNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clubContentLabel;

@property (weak, nonatomic) IBOutlet UIButton *clubActionButton;

@end

@implementation SPClubInviewListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - SetUp
- (void)setUp {
    _clubImageView.layer.cornerRadius = 3;
    _clubImageView.layer.masksToBounds = true;
    
    _clubActionButton.layer.cornerRadius = 2;
    _clubActionButton.layer.masksToBounds = true;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Action
- (IBAction)clubAction:(UIButton *)sender {
    
    if (_inviteModel) {
        [MBProgressHUD showHUDAddedTo:[_delegate view] animated:true];
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPSportBusinessUnit shareInstance] agreeJoinClubWithUserId:userId requestId:_inviteModel.requestId successful:^(NSString *successsfulString) {
            
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:[_delegate view] animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"已加入该俱乐部" ToView:[_delegate view]];
                    _clubActionButton.userInteractionEnabled = false;
                    [_clubActionButton setBackgroundColor:[UIColor whiteColor]];
                    [_clubActionButton setTitle:@"已接受" forState:UIControlStateNormal];
                    [_clubActionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                });
            } else {
                [MBProgressHUD hideHUDForView:[_delegate view] animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:[_delegate view]];
                });
            }
            
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:[_delegate view] animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"" ToView:[_delegate view]];
            });
        }];
    } else if (_applyModel) {
        [MBProgressHUD showHUDAddedTo:[_delegate view] animated:true];
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPSportBusinessUnit shareInstance] agreeJoinClubWithUserId:userId requestId:_applyModel.requestId successful:^(NSString *successsfulString) {
            
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:[_delegate view] animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"已接受该成员的申请" ToView:[_delegate view]];
                    _clubActionButton.userInteractionEnabled = false;
                    [_clubActionButton setBackgroundColor:[UIColor whiteColor]];
                    [_clubActionButton setTitle:@"已接受" forState:UIControlStateNormal];
                    [_clubActionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                });
            } else {
                [MBProgressHUD hideHUDForView:[_delegate view] animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:[_delegate view]];
                });
            }
            
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:[_delegate view] animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"" ToView:[_delegate view]];
            });
        }];
        
    }
}

- (void)setUpClubModel:(SPClubInviteListModel *)model {
    
    _inviteModel = model;
    
    _clubNameLabel.text = model.club_name;
    
    _clubContentLabel.text = @"邀请你加入俱乐部";
    
    [_clubImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] completed:nil];
    
    if ([model.status isEqualToString:@"0"]) {
        _clubActionButton.userInteractionEnabled = true;
        [_clubActionButton setBackgroundColor:[SPGlobalConfig themeColor]];
        [_clubActionButton setTitle:@"同意" forState:UIControlStateNormal];
        [_clubActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if ([model.status isEqualToString:@"1"]) {
        _clubActionButton.userInteractionEnabled = false;
        [_clubActionButton setBackgroundColor:[UIColor whiteColor]];
        [_clubActionButton setTitle:@"已接受" forState:UIControlStateNormal];
        [_clubActionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)setUpApplyModel:(SPClubApplyListModel *)model {
    _applyModel = model;
    
    _clubNameLabel.text = model.nick;
    _clubContentLabel.text = [NSString stringWithFormat:@"申请加入%@俱乐部",model.club_name];
    [_clubImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] completed:nil];
    
    if ([model.status isEqualToString:@"0"]) {
        _clubActionButton.userInteractionEnabled = true;
        [_clubActionButton setBackgroundColor:[SPGlobalConfig themeColor]];
        [_clubActionButton setTitle:@"同意" forState:UIControlStateNormal];
        [_clubActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if ([model.status isEqualToString:@"1"]) {
        _clubActionButton.userInteractionEnabled = false;
        [_clubActionButton setBackgroundColor:[UIColor whiteColor]];
        [_clubActionButton setTitle:@"已接受" forState:UIControlStateNormal];
        [_clubActionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

@end
