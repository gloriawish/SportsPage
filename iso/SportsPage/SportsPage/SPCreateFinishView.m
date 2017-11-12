//
//  SPCreateFinishView.m
//  SportsPage
//
//  Created by Qin on 2016/11/13.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateFinishView.h"

#import "SPSportBusinessUnit.h"
#import "MBProgressHUD.h"

#import "SPCreateFinishViewController.h"

@interface SPCreateFinishView ()

@property (nonatomic,strong) SPSportsActiveRequestModel *requestModel;

@property (weak, nonatomic) IBOutlet UILabel *sportsName;
@property (weak, nonatomic) IBOutlet UILabel *sportsLocation;
@property (weak, nonatomic) IBOutlet UILabel *sportsEvent;

@property (weak, nonatomic) IBOutlet UILabel *sportsDate;
@property (weak, nonatomic) IBOutlet UILabel *sportsTime;
@property (weak, nonatomic) IBOutlet UILabel *sportsLevel;
@property (weak, nonatomic) IBOutlet UILabel *sportsMemberBorder;

@property (weak, nonatomic) IBOutlet UILabel *sportsPrice;
@property (weak, nonatomic) IBOutlet UILabel *sportsChargeType;

@property (weak, nonatomic) IBOutlet UILabel *sportsPrivacy;
@property (weak, nonatomic) IBOutlet UILabel *sportsSummary;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation SPCreateFinishView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.masksToBounds = true;
    [_confirmButton setBackgroundColor:[SPGlobalConfig themeColor]];
}

- (void)setUpDataWithModel:(SPSportsActiveRequestModel *)requestModel {
    _requestModel = requestModel;
    
    _sportsName.text = _createNextStepViewController.sportsName;
    _sportsLocation.text = _createNextStepViewController.sportsLocation;
    _sportsEvent.text = _createNextStepViewController.sportsEvent;
    
    if (requestModel.date.length != 0) {
        _sportsDate.text = requestModel.date;
    } else {
        _sportsDate.text = @"未填写";
    }
    
    if (requestModel.time.length != 0) {
        _sportsTime.text = requestModel.time;
    } else {
        _sportsTime.text = @"未填写";
    }
    
    if (requestModel.memberBorder.length != 0) {
        _sportsMemberBorder.text = requestModel.memberBorder;
    } else {
        _sportsMemberBorder.text = @"未填写";
    }
    
    if (requestModel.price.length != 0) {
        if ([requestModel.price isEqualToString:@"0"]) {
            _sportsPrice.text = @"免费";
        } else {
            _sportsPrice.text = [NSString stringWithFormat:@"%@元/人",requestModel.price];
        }
    } else {
        _sportsPrice.text = @"未填写";
    }
    
    if (_createNextStepViewController.sportsSummary.length != 0) {
        _sportsSummary.text = _createNextStepViewController.sportsSummary;
    } else {
        _sportsSummary.text = @"未填写";
    }
    
    if ([requestModel.level isEqualToString:@"1"]) {
        _sportsLevel.text = @"简单";
    } else if ([requestModel.level isEqualToString:@"2"]) {
        _sportsLevel.text = @"一般";
    } else if ([requestModel.level isEqualToString:@"3"]) {
        _sportsLevel.text = @"困难";
    } else {
        _sportsLevel.text = @"未填写";
    }
    
    if ([requestModel.chargeType isEqualToString:@"1"]) {
        _sportsChargeType.text = @"线上";
    } else if ([requestModel.chargeType isEqualToString:@"2"]) {
        _sportsChargeType.text = @"线下";
    } else {
        _sportsChargeType.text = @"未填写";
    }
    
    if ([requestModel.privacy isEqualToString:@"0"]) {
        _sportsPrivacy.text = @"否";
    } else if ([requestModel.privacy isEqualToString:@"1"]) {
        _sportsPrivacy.text = @"是";
    } else {
        _sportsPrivacy.text = @"未填写";
    }
    
}

 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_confirmView];
    if (!CGRectContainsPoint(_confirmView.bounds, clickPoint)) {
        [UIView animateWithDuration:0.5 animations:^{
            _confirmView.alpha = 0;
            _createNextStepViewController.windowImageView.alpha = 0;
            self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [_createNextStepViewController.windowImageView removeFromSuperview];
            _createNextStepViewController.isSubWindowDisplay = false;
            [self removeFromSuperview];
        }];
    }
}

- (IBAction)confirmButtonAction:(id)sender {

    if (_requestModel.date.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"数据不完整,请认真填写" ToView:self];
        return;
    }
    
    if (_requestModel.time.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"数据不完整,请认真填写" ToView:self];
        return;
    }
    
    if (_requestModel.memberBorder.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"数据不完整,请认真填写" ToView:self];
        return;
    }
    
    if (_requestModel.price.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"数据不完整,请认真填写" ToView:self];
        return;
    }
    
    if ([_sportsLevel.text isEqualToString:@"未填写"]) {
        [SPGlobalConfig showTextOfHUD:@"数据不完整,请认真填写" ToView:self];
        return;
    }
    
    if ([_sportsChargeType.text isEqualToString:@"未填写"]) {
        [SPGlobalConfig showTextOfHUD:@"数据不完整,请认真填写" ToView:self];
        return;
    }
    
    if ([_sportsPrivacy.text isEqualToString:@"未填写"]) {
        [SPGlobalConfig showTextOfHUD:@"数据不完整,请认真填写" ToView:self];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self animated:true];
    
    NSString *jsonString = _requestModel.toJSONString;
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] activateSportWithUserId:userId sportId:_createNextStepViewController.sportId json:jsonString successful:^(NSString *successsfulString, NSString *retString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self animated:true];
            
            SPCreateFinishViewController *createFinishViewController = [[SPCreateFinishViewController alloc] init];
            createFinishViewController.eventId = retString;
            [_createNextStepViewController.navigationController pushViewController:createFinishViewController animated:true];
            
            _createNextStepViewController.tableView.userInteractionEnabled = false;
            _createNextStepViewController.isSubWindowDisplay = false;
            [_createNextStepViewController.windowImageView removeFromSuperview];
            [self removeFromSuperview];
            
        } else {
            NSLog(@"%@",successsfulString);
            [MBProgressHUD hideHUDForView:self animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self];
            });
        }
        
    } failure:^(NSString *errorString) {
        NSLog(@"AFN ERROR :%@",errorString);
        [MBProgressHUD hideHUDForView:self animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self];
        });
    }];
}

- (IBAction)exitButtonAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _confirmView.alpha = 0;
        _createNextStepViewController.windowImageView.alpha = 0;
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_createNextStepViewController.windowImageView removeFromSuperview];
        _createNextStepViewController.isSubWindowDisplay = false;
        [self removeFromSuperview];
    }];
}

@end
