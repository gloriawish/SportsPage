//
//  SPCreateSportsPageEventView.m
//  SportsPage
//
//  Created by Qin on 2017/2/6.
//  Copyright © 2017年 运动页. All rights reserved.
//

#import "SPCreateSportsPageEventView.h"

@interface SPCreateSportsPageEventView ()

@property (weak, nonatomic) IBOutlet UIButton *badmintonButton;
@property (weak, nonatomic) IBOutlet UIButton *footballButton;
@property (weak, nonatomic) IBOutlet UIButton *basketballButton;
@property (weak, nonatomic) IBOutlet UIButton *tennisButton;
@property (weak, nonatomic) IBOutlet UIButton *joggingButton;
@property (weak, nonatomic) IBOutlet UIButton *swimmingButton;
@property (weak, nonatomic) IBOutlet UIButton *squashButton;
@property (weak, nonatomic) IBOutlet UIButton *kayakButton;
@property (weak, nonatomic) IBOutlet UIButton *baseballButton;
@property (weak, nonatomic) IBOutlet UIButton *pingpangButton;

@property (weak, nonatomic) IBOutlet UIButton *customButton;

@end

@implementation SPCreateSportsPageEventView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    _eventView.alpha = 0;
    _customButton.layer.cornerRadius = 5;
    _customButton.layer.masksToBounds = true;
    [_customButton setBackgroundColor:[SPGlobalConfig themeColor]];
}

- (IBAction)selectedButtonAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(receivedContentString:)]) {
        if (sender.tag == 1001) {
            [_delegate receivedContentString:@"羽毛球"];
        } else if (sender.tag == 1002) {
            [_delegate receivedContentString:@"足球"];
        } else if (sender.tag == 1003) {
            [_delegate receivedContentString:@"篮球"];
        } else if (sender.tag == 1004) {
            [_delegate receivedContentString:@"网球"];
        } else if (sender.tag == 1005) {
            [_delegate receivedContentString:@"跑步"];
        } else if (sender.tag == 1006) {
            [_delegate receivedContentString:@"游泳"];
        } else if (sender.tag == 1007) {
            [_delegate receivedContentString:@"壁球"];
        } else if (sender.tag == 1008) {
            [_delegate receivedContentString:@"皮划艇"];
        } else if (sender.tag == 1009) {
            [_delegate receivedContentString:@"棒球"];
        } else if (sender.tag == 1010) {
            [_delegate receivedContentString:@"乒乓"];
        } else if (sender.tag == 1011) {
            [_delegate receivedContentString:@"自定义"];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_eventView];
    if (!CGRectContainsPoint(_eventView.bounds, clickPoint)) {
        if ([_delegate respondsToSelector:@selector(receivedContentString:)]) {
            [_delegate receivedContentString:@"取消"];
        }
    }
    
}

@end
