//
//  SPSportsEventViewController.m
//  SportsPage
//
//  Created by Qin on 2016/10/31.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsEventViewController.h"
#import "SPSportBusinessUnit.h"
#import "SPIMBusinessUnit.h"

#import "AutoSlideScrollView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

#import "SPEventModel.h"
#import "SPIMSendMessageModel.h"
#import "SPChatViewController.h"
#import "SPChatGroupViewController.h"

#import "SPSPortsOrderViewController.h"
#import "SPSportsSignedUpViewController.h"
#import "SPSportsAppraiseViewController.h"
#import "SPSportsSettleViewController.h"

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

#import "JZLocationConverter.h"
#import "CMInputView.h"

#import "SPIMMessageContent.h"

#import "SPCreateCompleteViewController.h"

//分享
//#import "SPSportsEventShareView.h"
#import "SPSportsPageShareView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "SPSportsShareViewController.h"

@interface SPSportsEventViewController () <SPSportsPageShareViewProtocol,TencentSessionDelegate> {
    SPEventModel *_eventModel;
    
    UIButton *_shareButton;
    UIButton *_messageButton;
    UIView *_grayLineView;
    
    UIImageView *_headImageView;
    
    CGFloat _keyboardHeight;
    NSTimeInterval _animationDuration;
    
    //UIImageView *_imageViewBG;
    //SPSportsEventShareView *_shareView;
    
    UIImageView *_windowImageViewBG;
    SPSportsPageShareView *_shareView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet AutoSlideScrollView *autoSlideScrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *placeView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;

@property (weak, nonatomic) IBOutlet UILabel *initiatePersonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *telephoneImageView;

@property (weak, nonatomic) IBOutlet UIView *signUpView;
@property (weak, nonatomic) IBOutlet UILabel *signUpMemberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signUpImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *signUpImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *signUpImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *signUpImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

@property (weak, nonatomic) IBOutlet UILabel *activityDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *activityDetailBlueLabel;
@property (weak, nonatomic) IBOutlet UIView *messageBlueLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@property (weak, nonatomic) IBOutlet UIView *subMessageView1;
@property (weak, nonatomic) IBOutlet UIView *subMessageView2;
@property (weak, nonatomic) IBOutlet UIView *subMessageView3;
@property (weak, nonatomic) IBOutlet UIView *subMessageView4;

@property (weak, nonatomic) IBOutlet UIImageView *subMessageHeaderImageView1;
@property (weak, nonatomic) IBOutlet UILabel *subMessageUserLabel1;
@property (weak, nonatomic) IBOutlet UILabel *subMessageContentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *subMessageMoreLabel1;

@property (weak, nonatomic) IBOutlet UIImageView *subMessageHeaderImageView2;
@property (weak, nonatomic) IBOutlet UILabel *subMessageUserLabel2;
@property (weak, nonatomic) IBOutlet UILabel *subMessageContentLabel2;

@property (weak, nonatomic) IBOutlet UIImageView *subMessageHeaderImageView3;
@property (weak, nonatomic) IBOutlet UILabel *subMessageUserLabel3;
@property (weak, nonatomic) IBOutlet UILabel *subMessageContentLabel3;

@property (weak, nonatomic) IBOutlet UIImageView *navBarImageView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *messageInputView;

@property (nonatomic,strong) CMInputView *messageTextView;

@end

@implementation SPSportsEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkRequest];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappearAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPORTS_SHARE object:nil];
    NSLog(@"%s",__func__);
}

- (void)networkRequest {
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.hidden = true;
    
    _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageButton.hidden = true;
    
    _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _signUpButton.hidden = true;
    
    _grayLineView = [[UIView alloc] init];
    _grayLineView.hidden = true;
    
    _scrollView.hidden = true;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] getEventWithEventId:_eventId userId:userId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            _eventModel = (SPEventModel *)jsonModel;
            [self scrollViewReload];
        } else {
            NSLog(@"%@",successsfulString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        NSLog(@"%@",errorString);
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

-(void)updateViewConstraints {
    
    //CGFloat fixedHeight = SCREEN_WIDTH*9/16 + 5 + 150 + 5 + 60 + 60 + 85 + 40 + 5 + 49;
    CGFloat fixedHeight = SCREEN_WIDTH*9/16 + 459;
    if (_eventModel) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        CGSize size = [_eventModel.summary boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                  NSParagraphStyleAttributeName:paragraphStyle}
                                                        context:nil].size;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_eventModel.summary];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_eventModel.summary length])];
        _descriptionLabel.attributedText = attributedString;
        _descriptionLabel.text = _eventModel.summary;
        CGFloat changeHeight = size.height + 5;
        _descriptionViewHeightConstraint.constant = changeHeight;
        if (changeHeight > 240) {
            _contentSizeHeightConstraint.constant = fixedHeight + changeHeight;
        } else {
            _contentSizeHeightConstraint.constant = fixedHeight + 240;
        }
    } else {
         _contentSizeHeightConstraint.constant = fixedHeight + 240;
    }
    [super updateViewConstraints];
}

#pragma mark - SetUp
- (void)setUp {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationShareAction:) name:NOTIFICATION_SPORTS_SHARE object:nil];
    
    [self setUpNav];
    [self setUpScrollView];
    [self setUpUI];
}

- (void)setUpNav {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    _navBarView.backgroundColor = [SPGlobalConfig anyColorWithRed:88 green:87 blue:86 alpha:0.9];
    _navBarView.alpha = 0;
}

- (void)setUpScrollView {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollViewAction:)];
    [_scrollView addGestureRecognizer:tapGesture];
    
    _focusButton.layer.cornerRadius = 6;
    _focusButton.layer.masksToBounds = true;
    
    [self addGestureWithImageView:_placeView SEL:@selector(tapLocationAction:)];
    [self addGestureWithImageView:_telephoneImageView SEL:@selector(tapTelophoneAction:)];
    [self addGestureWithImageView:_signUpView SEL:@selector(tapMoreAction:)];
    
    
    [self addGestureWithImageView:_activityDetailLabel SEL:@selector(detailActivityTapAction:)];
    [self addGestureWithImageView:_messageLabel SEL:@selector(detailMessageTapAction:)];
}

- (void)addGestureWithImageView:(UIView *)sender SEL:(SEL)sel {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    sender.userInteractionEnabled = true;
    [sender addGestureRecognizer:tapGesture];
}

- (void)setUpUI {
    
    [self setUpButtonWithButton:_shareButton
                          frame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH/4, 49)
                backgroundColor:[UIColor whiteColor]
                       fontSize:16
                       norTitle:@"分享"
                  norTitleColor:[SPGlobalConfig anyColorWithRed:24 green:155 blue:250 alpha:1]
            highlightTitleColor:[UIColor lightGrayColor]
                      imageName:@"Sports_share_nor"
                     edgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)
                       selector:@selector(shareButtonAction:)];
    
    [self setUpButtonWithButton:_messageButton
                          frame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT-49, SCREEN_WIDTH/4, 49)
                backgroundColor:[UIColor whiteColor]
                       fontSize:16
                       norTitle:@"留言"
                  norTitleColor:[SPGlobalConfig anyColorWithRed:24 green:155 blue:250 alpha:1]
            highlightTitleColor:[UIColor lightGrayColor]
                      imageName:@"Sports_message_nor"
                     edgeInsets:UIEdgeInsetsMake(0, 0, 2, 8)
                       selector:@selector(messageButtonAction:)];
    
    [self setUpButtonWithButton:_signUpButton
                          frame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-49, SCREEN_WIDTH/2, 49)
                backgroundColor:[SPGlobalConfig anyColorWithRed:24 green:155 blue:250 alpha:1]
                       fontSize:16
                       norTitle:@"报名"
                  norTitleColor:[UIColor whiteColor]
            highlightTitleColor:[UIColor lightGrayColor]
                      imageName:@"Sports_signup_nor"
                     edgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)
                       selector:@selector(signUpButtonAction:)];
    
    _grayLineView.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 5);
    _grayLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:238 green:238 blue:238 alpha:1];
    [self.view addSubview:_grayLineView];
    
    _messageInputView.backgroundColor = [SPGlobalConfig themeColor];
    [self.view addSubview:_messageInputView];
    
    _messageTextView = [[CMInputView alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-70, 30)];
    _messageTextView.font = [UIFont systemFontOfSize:16];
    _messageTextView.cornerRadius = 5;
    _messageTextView.maxNumberOfLines = 5;
    
    __weak CMInputView *weakMessageTextView = _messageTextView;
    __weak UIView *weakMessageInputView = _messageInputView;
    [_messageTextView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect textViewFrame = weakMessageTextView.frame;
        textViewFrame.size.height = textHeight;
        weakMessageTextView.frame = textViewFrame;
        
        CGRect viewFrame = weakMessageInputView.frame;
        viewFrame.origin.y = viewFrame.origin.y - (textHeight+10 - viewFrame.size.height);
        viewFrame.size.height = textHeight + 10;
        weakMessageInputView.frame = viewFrame;
    }];
    [_messageInputView addSubview:_messageTextView];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(SCREEN_WIDTH-50, 5, 40, 30);
    [messageButton setTitle:@"留言" forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [messageButton addTarget:self action:@selector(sendMessageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_messageInputView addSubview:messageButton];
    
}

- (void)setUpButtonWithButton:(UIButton *)sender
                        frame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor
                     fontSize:(NSInteger)fontSize
                     norTitle:(NSString *)title
                norTitleColor:(UIColor *)norTitleColor
          highlightTitleColor:(UIColor *)highlightTitleColor
                    imageName:(NSString *)imageName
                   edgeInsets:(UIEdgeInsets)edgeInsets
                     selector:(SEL)selector {
    
    //sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.frame = frame;
    sender.backgroundColor = backgroundColor;
    sender.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:norTitleColor forState:UIControlStateNormal];
    [sender setTitleColor:highlightTitleColor forState:UIControlStateHighlighted];
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [sender setImageEdgeInsets:edgeInsets];
    [sender addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender];
    
    if (sender == _shareButton) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-1, 10, 1, 36)];
        lineView.backgroundColor = [SPGlobalConfig anyColorWithRed:238 green:238 blue:238 alpha:1];
        [sender addSubview:lineView];
    }
}

- (void)scrollViewReload {
    //AutoScrollView
    __weak NSMutableArray <NSString *>* portaitArray = _eventModel._portrait;
    _autoSlideScrollView.totalPagesCount = ^NSInteger() {
        return portaitArray.count;
    };
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16)];
    __weak UIImageView *weakImageView = _headImageView;
    _autoSlideScrollView.fetchContentViewAtIndex = ^UIView*(NSInteger pageIndex) {
        if (pageIndex == 0) {
            [weakImageView sd_setImageWithURL:[NSURL URLWithString:[portaitArray objectAtIndex:pageIndex]]
                              placeholderImage:[UIImage imageNamed:@"Sports_mask"]];
            return weakImageView;
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[portaitArray objectAtIndex:pageIndex]]
                         placeholderImage:[UIImage imageNamed:@"Sports_mask"]];
            return imageView;
        }
    };
    
    //运动名称
    if (_eventModel.title.length != 0) {
        _titleLabel.text = _eventModel.title;
    } else {
        _titleLabel.text = @"发起人还没有起名字";
    }
    
    //运动评星
    if (_eventModel.grade.length != 0) {
        NSString *imageName = [NSString stringWithFormat:@"Sports_star_%@",_eventModel.grade];
        _starImageView.image = [UIImage imageNamed:imageName];
    } else {
        _starImageView.image = [UIImage imageNamed:@"Sports_star_3"];
        //_starImageView.hidden = true;
    }
    
    //运动关注按钮
    if ([_eventModel.attetion isEqualToString:@"0"]) {
        [_focusButton setBackgroundColor:[SPGlobalConfig anyColorWithRed:24 green:155 blue:250 alpha:1]];
        [_focusButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    } else {
        [_focusButton setBackgroundColor:[UIColor grayColor]];
        [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        _focusButton.userInteractionEnabled = false;
    }
    
    //运动时间处理
    NSMutableString *beginDate = nil;
    if (_eventModel.start_time.length != 0) {
        beginDate = [[_eventModel.start_time substringToIndex:10] mutableCopy];
    }
    NSMutableString *endDate = nil;
    if (_eventModel.end_time.length != 0) {
        endDate = [[_eventModel.end_time substringToIndex:10] mutableCopy];
    }
    if (beginDate && endDate) {
        if ([beginDate isEqualToString:endDate]) {
            NSMutableString *beginTime = [[_eventModel.start_time substringWithRange:NSMakeRange(11, 5)] mutableCopy];
            NSMutableString *endTime = [[_eventModel.end_time substringWithRange:NSMakeRange(11, 5)] mutableCopy];
            _timeLabel.text = [NSString stringWithFormat:@"%@\n至%@",beginTime,endTime];
        } else {
            NSMutableString *beginTime = [[_eventModel.start_time substringWithRange:NSMakeRange(5, 5)] mutableCopy];
            [beginTime replaceOccurrencesOfString:@"-" withString:@"月" options:NSCaseInsensitiveSearch range:NSMakeRange(2, 1)];
            [beginTime appendString:@"日"];
            NSMutableString *endTime = [[_eventModel.end_time substringWithRange:NSMakeRange(5, 5)] mutableCopy];
            [endTime replaceOccurrencesOfString:@"-" withString:@"月" options:NSCaseInsensitiveSearch range:NSMakeRange(2, 1)];
            [endTime appendString:@"日"];
            _timeLabel.text = [NSString stringWithFormat:@"%@\n至%@",beginTime,endTime];
        }
        
        NSString *tempString = [_eventModel.start_time substringToIndex:10];
        int year = [[tempString substringWithRange:NSMakeRange(0, 4)] intValue];
        int month = [[tempString substringWithRange:NSMakeRange(5, 2)] intValue];
        int day = [[tempString substringWithRange:NSMakeRange(8, 2)] intValue];
        if (month == 1 || month == 2) {
            month += 12;
            year--;
        }
        int iWeek = (day+2*month+3*(month+1)/5+year+year/4-year/100+year/400)%7;
        NSString *weekString = nil;
        switch (iWeek) {
            case 0:
                weekString = @"星期一";
                break;
            case 1:
                weekString = @"星期二";
                break;
            case 2:
                weekString = @"星期三";
                break;
            case 3:
                weekString = @"星期四";
                break;
            case 4:
                weekString = @"星期五";
                break;
            case 5:
                weekString = @"星期六";
                break;
            case 6:
                weekString = @"星期日";
                break;
            default:
                break;
        }
        
        [beginDate replaceCharactersInRange:NSMakeRange(0, 5) withString:@""];
        [beginDate replaceCharactersInRange:NSMakeRange(2, 1) withString:@"月"];
        [beginDate appendString:@"日"];
        
        _dateLabel.text = [NSString stringWithFormat:@"%@\n%@",weekString,beginDate];
    }
    
    //支付方式
    NSString *chargeStr = nil;
    if ([_eventModel.charge_type isEqualToString:@"1"]) {
        chargeStr = @"线上支付";
    } else if ([_eventModel.charge_type isEqualToString:@"2"]) {
        chargeStr = @"线下支付";
    } else {
        chargeStr = @"支付方式待定";
    }
    
    //运动价格
    if (_eventModel.price.length != 0) {
        if ([_eventModel.price isEqualToString:@"0.00"]) {
            _costLabel.text = [NSString stringWithFormat:@"免费\n%@",chargeStr];
        } else {
            _costLabel.text = [NSString stringWithFormat:@"%@元/人\n%@",_eventModel.price,chargeStr];
        }
    } else {
        _costLabel.text = [NSString stringWithFormat:@"金额待定\n%@",chargeStr];
    }
    
    //运动项目
    NSString *contentStr = nil;
    if ([_eventModel.sport_item isEqualToString:@"1"]) {
        contentStr = @"羽毛球";
    } else if ([_eventModel.sport_item isEqualToString:@"2"]) {
        contentStr = @"足球";
    } else if ([_eventModel.sport_item isEqualToString:@"3"]) {
        contentStr = @"篮球";
    } else if ([_eventModel.sport_item isEqualToString:@"4"]) {
        contentStr = @"网球";
    } else if ([_eventModel.sport_item isEqualToString:@"5"]) {
        contentStr = @"跑步";
    } else if ([_eventModel.sport_item isEqualToString:@"6"]) {
        contentStr = @"游泳";
    } else if ([_eventModel.sport_item isEqualToString:@"7"]) {
        contentStr = @"壁球";
    } else if ([_eventModel.sport_item isEqualToString:@"8"]) {
        contentStr = @"皮划艇";
    } else if ([_eventModel.sport_item isEqualToString:@"9"]) {
        contentStr = @"棒球";
    } else if ([_eventModel.sport_item isEqualToString:@"10"]) {
        contentStr = @"乒乓";
    } else if ([_eventModel.sport_item isEqualToString:@"20"]) {
        contentStr = _eventModel.extend;
    }

    //运动状态
    if ([_eventModel.status isEqualToString:@"1"]) {
        _statusLabel.text = [NSString stringWithFormat:@"%@\n报名中",contentStr];
    } else if ([_eventModel.status isEqualToString:@"2"]) {
        _statusLabel.text = [NSString stringWithFormat:@"%@\n已锁定",contentStr];
    } else if ([_eventModel.status isEqualToString:@"3"]) {
        _statusLabel.text = [NSString stringWithFormat:@"%@\n进行中",contentStr];
    } else if ([_eventModel.status isEqualToString:@"4"]) {
        _statusLabel.text = [NSString stringWithFormat:@"%@\n已取消",contentStr];
    } else if ([_eventModel.status isEqualToString:@"5"]) {
        _statusLabel.text = [NSString stringWithFormat:@"%@\n已结束",contentStr];
    }
    
    //运动场地描述
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *latitude = _eventModel.latitude;
    NSString *longitude = _eventModel.longitude;
    NSString *distanceStr = nil;
    if ([latitude isEqualToString:@"999"] && [longitude isEqualToString:@"999"]) {
        distanceStr = @"";
    } else {
        CLLocation *locationNow = [[CLLocation alloc] initWithLatitude:delegate.latitude longitude:delegate.longitude];
        double distance = [locationNow distanceFromLocation:[[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]]]/1000.0;
        distanceStr = [NSString stringWithFormat:@"(%.1fkm)",distance];
    }
    
    if (_eventModel.place.length == 0) {
        _placeLabel.text = @"场地描述: 发起人还没有填写场地描述";
    } else {
        _placeLabel.text = [NSString stringWithFormat:@"场地描述: %@%@",_eventModel.place,distanceStr];
    }
    
    //运动地址
    if (_eventModel.location.length != 0) {
        _locationDetailLabel.text = _eventModel.location;
    } else {
        _locationDetailLabel.text = @"发起人还没有填写地址";
    }
    
    //运动发起人
    if (_eventModel.user_id.nick.length != 0) {
        _initiatePersonLabel.text = _eventModel.user_id.nick;
    } else {
        //_initiatePersonLabel.text = @"发起人还没有填写昵称";
        _initiatePersonLabel.text = _eventModel.user_id.uname;
    }
    
    //报名人数
    if (_eventModel.max_number.length != 0) {
        _signUpMemberLabel.text = [NSString stringWithFormat:@"( %lu/%@ )",(unsigned long)_eventModel.enrollUsers.count,_eventModel.max_number];
    } else {
        _signUpMemberLabel.text = @"发起人还未填写人数范围";
    }
    
    //参与人头像
    if (_eventModel.enrollUsers.count == 0) {
        _signUpImageView1.hidden = true;
        _signUpImageView2.hidden = true;
        _signUpImageView3.hidden = true;
        _signUpImageView4.hidden = true;
        
        CGRect frame = _signUpImageView1.frame;
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 250, frame.size.height)];
        tempLabel.font = [UIFont systemFontOfSize:15];
        tempLabel.text = @"还没有人参与其中,赶快来报名吧";
        [_signUpView addSubview:tempLabel];
        
    } else {
        NSInteger enrollCount = _eventModel.enrollUsers.count >= 4 ? 4 : _eventModel.enrollUsers.count;
        CGFloat cornerRadius = _signUpImageView1.frame.size.width/2;
        switch (enrollCount) {
            case 1:
                [self setUpEnrollUsersWithHidden1:false hidden2:true hidden3:true hidden4:true];
                [self setUpEnrollUsersImageWithNum:1 cornerRadius:cornerRadius];
                break;
            case 2:
                [self setUpEnrollUsersWithHidden1:false hidden2:false hidden3:true hidden4:true];
                [self setUpEnrollUsersImageWithNum:2 cornerRadius:cornerRadius];
                break;
            case 3:
                [self setUpEnrollUsersWithHidden1:false hidden2:false hidden3:false hidden4:true];
                [self setUpEnrollUsersImageWithNum:3 cornerRadius:cornerRadius];
                break;
            case 4:
                [self setUpEnrollUsersWithHidden1:false hidden2:false hidden3:false hidden4:false];
                [self setUpEnrollUsersImageWithNum:4 cornerRadius:cornerRadius];
                break;
            default:
                break;
        }
    }
    
    //报名按钮状态
    if ([_eventModel.user_status isEqualToString:@"报名"]) {
        [_signUpButton setTitle:@"报名" forState:UIControlStateNormal];
    } else if ([_eventModel.user_status isEqualToString:@"已报名"]) {
        [_signUpButton setTitle:@"已报名" forState:UIControlStateNormal];
        _signUpButton.backgroundColor = [UIColor grayColor];
        _signUpButton.userInteractionEnabled = false;
    } else if ([_eventModel.user_status isEqualToString:@"去评价"]) {
        [_signUpButton setTitle:@"去评价" forState:UIControlStateNormal];
    } else if ([_eventModel.user_status isEqualToString:@"已评价"]) {
        [_signUpButton setTitle:@"已评价" forState:UIControlStateNormal];
        _signUpButton.backgroundColor = [UIColor grayColor];
        _signUpButton.userInteractionEnabled = false;
    } else if ([_eventModel.user_status isEqualToString:@"锁定"]) {
        [_signUpButton setTitle:@"锁定" forState:UIControlStateNormal];
    } else if ([_eventModel.user_status isEqualToString:@"解锁"]) {
        [_signUpButton setTitle:@"解锁" forState:UIControlStateNormal];
    } else if ([_eventModel.user_status isEqualToString:@"结算"]) {
        [_signUpButton setTitle:@"结算" forState:UIControlStateNormal];
    } else if ([_eventModel.user_status isEqualToString:@"已结束"]) {
        [_signUpButton setTitle:@"已结束" forState:UIControlStateNormal];
        _signUpButton.backgroundColor = [UIColor grayColor];
        _signUpButton.userInteractionEnabled = false;
    } else if ([_eventModel.user_status isEqualToString:@"已取消"]) {
        [_signUpButton setTitle:@"已取消" forState:UIControlStateNormal];
        _signUpButton.backgroundColor = [UIColor grayColor];
        _signUpButton.userInteractionEnabled = false;
    } else if ([_eventModel.user_status isEqualToString:@"进行中"]) {
        [_signUpButton setTitle:@"待发起人结算" forState:UIControlStateNormal];
        _signUpButton.backgroundColor = [UIColor grayColor];
        _signUpButton.userInteractionEnabled = false;
    } else {
        [_signUpButton setTitle:_eventModel.user_status forState:UIControlStateNormal];
        _signUpButton.backgroundColor = [UIColor grayColor];
        _signUpButton.userInteractionEnabled = false;
    }
    
    //运动详情
    if (_descriptionLabel.text.length == 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        CGSize size = [_eventModel.summary boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                  NSParagraphStyleAttributeName:paragraphStyle}
                                                        context:nil].size;
        NSMutableAttributedString *attributedString = nil;
        if (!_eventModel.summary) {
            attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
        } else {
            attributedString = [[NSMutableAttributedString alloc] initWithString:_eventModel.summary];
        }
        
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_eventModel.summary length])];
        _descriptionLabel.attributedText = attributedString;
        _descriptionLabel.text = _eventModel.summary;
        CGFloat changeHeight = size.height + 5;
        _descriptionViewHeightConstraint.constant = changeHeight;
        //CGFloat fixedHeight = SCREEN_WIDTH*9/16 + 5 + 150 + 5 + 60 + 60 + 85 + 40 + 5 + 49;
        CGFloat fixedHeight = SCREEN_WIDTH*9/16 + 464;
        if (changeHeight > 240) {
            _contentSizeHeightConstraint.constant = fixedHeight + changeHeight;
        } else {
            _contentSizeHeightConstraint.constant = fixedHeight + 240;
        }
    }
    
    //留言
    NSInteger messageCount = _eventModel.messages.count>=3 ? 3 : _eventModel.messages.count;
    if (messageCount == 0) {
        _subMessageView2.hidden = true;
        _subMessageView3.hidden = true;
        _subMessageView4.hidden = true;
        _subMessageUserLabel1.hidden = true;
        _subMessageContentLabel1.hidden = true;
        _subMessageHeaderImageView1.hidden = true;
    } else if (messageCount == 1) {
        _subMessageView2.hidden = true;
        _subMessageView3.hidden = true;
        _subMessageView4.hidden = true;
        _subMessageUserLabel2.hidden = true;
        _subMessageContentLabel2.hidden = true;
        _subMessageHeaderImageView2.hidden = true;
        _subMessageMoreLabel1.hidden = true;
        
        _subMessageUserLabel1.text = [[_eventModel.messages objectAtIndex:0] nick];
        _subMessageContentLabel1.text = [[_eventModel.messages objectAtIndex:0] content];
        [_subMessageHeaderImageView1 sd_setImageWithURL:[NSURL URLWithString:[[_eventModel.messages objectAtIndex:0] portrait]] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
        
        _subMessageHeaderImageView1.layer.cornerRadius = 4;
        _subMessageHeaderImageView1.layer.masksToBounds = true;
    } else if (messageCount == 2) {
        _subMessageView3.hidden = true;
        _subMessageView4.hidden = true;
        _subMessageUserLabel3.hidden = true;
        _subMessageContentLabel3.hidden = true;
        _subMessageHeaderImageView3.hidden = true;
        _subMessageMoreLabel1.hidden = true;
        
        _subMessageUserLabel1.text = [[_eventModel.messages objectAtIndex:0] nick];
        _subMessageContentLabel1.text = [[_eventModel.messages objectAtIndex:0] content];;
        [_subMessageHeaderImageView1 sd_setImageWithURL:[NSURL URLWithString:[[_eventModel.messages objectAtIndex:0] portrait]] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
        _subMessageUserLabel2.text = [[_eventModel.messages objectAtIndex:1] nick];
        _subMessageContentLabel2.text = [[_eventModel.messages objectAtIndex:1] content];
        [_subMessageHeaderImageView2 sd_setImageWithURL:[NSURL URLWithString:[[_eventModel.messages objectAtIndex:1] portrait]] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
        
        _subMessageHeaderImageView1.layer.cornerRadius = 4;
        _subMessageHeaderImageView1.layer.masksToBounds = true;
        _subMessageHeaderImageView2.layer.cornerRadius = 4;
        _subMessageHeaderImageView2.layer.masksToBounds = true;
    } else if (messageCount == 3) {
#warning mark - 隐藏更多留言
        _subMessageView4.hidden = true;
        
        _subMessageMoreLabel1.hidden = true;
        
        _subMessageUserLabel1.text = [[_eventModel.messages objectAtIndex:0] nick];
        _subMessageContentLabel1.text = [[_eventModel.messages objectAtIndex:0] content];;
        [_subMessageHeaderImageView1 sd_setImageWithURL:[NSURL URLWithString:[[_eventModel.messages objectAtIndex:0] portrait]] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
        _subMessageUserLabel2.text = [[_eventModel.messages objectAtIndex:1] nick];
        _subMessageContentLabel2.text = [[_eventModel.messages objectAtIndex:1] content];
        [_subMessageHeaderImageView2 sd_setImageWithURL:[NSURL URLWithString:[[_eventModel.messages objectAtIndex:1] portrait]] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
        _subMessageUserLabel3.text = [[_eventModel.messages objectAtIndex:2] nick];
        _subMessageContentLabel3.text = [[_eventModel.messages objectAtIndex:2] content];
        [_subMessageHeaderImageView3 sd_setImageWithURL:[NSURL URLWithString:[[_eventModel.messages objectAtIndex:2] portrait]] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
        
        _subMessageHeaderImageView1.layer.cornerRadius = 4;
        _subMessageHeaderImageView1.layer.masksToBounds = true;
        _subMessageHeaderImageView2.layer.cornerRadius = 4;
        _subMessageHeaderImageView2.layer.masksToBounds = true;
        _subMessageHeaderImageView3.layer.cornerRadius = 4;
        _subMessageHeaderImageView3.layer.masksToBounds = true;
    }
    
    _scrollView.hidden = false;
    _shareButton.hidden = false;
    _messageButton.hidden = false;
    _signUpButton.hidden = false;
    _grayLineView.hidden = false;
}

- (void)setUpEnrollUsersWithHidden1:(BOOL)isHidden1 hidden2:(BOOL)isHidden2 hidden3:(BOOL)isHidden3 hidden4:(BOOL)isHidden4 {
    _signUpImageView1.hidden = isHidden1;
    _signUpImageView2.hidden = isHidden2;
    _signUpImageView3.hidden = isHidden3;
    _signUpImageView4.hidden = isHidden4;
}

- (void)setUpEnrollUsersImageWithNum:(NSInteger)countNum cornerRadius:(CGFloat)cornerRadius {
    NSArray <UIImageView *>*tempArray = @[_signUpImageView1,
                                          _signUpImageView2,
                                          _signUpImageView3,
                                          _signUpImageView4];
    for (int index=0; index<countNum; index++) {
        [tempArray[index] sd_setImageWithURL:[NSURL URLWithString:[_eventModel.enrollUsers[index] portrait]]
                            placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
        tempArray[index].layer.cornerRadius = cornerRadius;
        tempArray[index].layer.masksToBounds = true;
    }
}

#pragma mark - Observes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat yPosition = [(NSValue *)change[@"new"] CGPointValue].y;
        if (yPosition <= 0) {
            _navBarImageView.alpha = 1;
            _navBarView.alpha = 0;
        } else if (yPosition > 0 && yPosition <= 64) {
            _navBarImageView.alpha = 1-yPosition/64;
            _navBarView.alpha = yPosition/64;
        } else {
            _navBarImageView.alpha = 0;
            _navBarView.alpha = 1;
        }
    }
}

#pragma mark - Action
#pragma mark 返回,更多设置
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)moreButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if ([userId isEqualToString:_eventModel.user_id.userId]) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"解散运动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *confirmController = [UIAlertController alertControllerWithTitle:@"确认解散运动" message:nil
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                sender.userInteractionEnabled = true;
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                [[SPSportBusinessUnit shareInstance] dismissEventWithUserId:userId eventId:_eventId successful:^(NSString *successsfulString) {
                    if ([successsfulString isEqualToString:@"successful"]) {
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:@"解散成功" ToView:self.view];
                            [self.navigationController popViewControllerAnimated:true];
                        });
                    } else {
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                        });
                    }
                } failure:^(NSString *errorString) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                    });
                }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [confirmController addAction:confirmAction];
            [confirmController addAction:cancelAction];
            [self presentViewController:confirmController animated:true completion:nil];
        }];
        [alertController addAction:action];
    } else {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"退出运动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *confirmController = [UIAlertController alertControllerWithTitle:@"确认退出运动" message:nil
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                sender.userInteractionEnabled = true;
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                [[SPSportBusinessUnit shareInstance] exitEventWithUserId:userId eventId:_eventId successful:^(NSString *successsfulString) {
                    if ([successsfulString isEqualToString:@"successful"]) {
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:@"退出成功" ToView:self.view];
                            [self.navigationController popViewControllerAnimated:true];
                        });
                    } else {
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                        });
                    }
                } failure:^(NSString *errorString) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                    });
                }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [confirmController addAction:confirmAction];
            [confirmController addAction:cancelAction];
            [self presentViewController:confirmController animated:true completion:nil];
        
        }];
        [alertController addAction:action];
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        sender.userInteractionEnabled = true;
    }];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark 互动详情,留言
- (void)detailActivityTapAction:(UITapGestureRecognizer *)sender {
    if (_activityDetailBlueLabel.hidden) {
        _activityDetailBlueLabel.hidden = false;
        _descriptionLabel.hidden = false;
        _messageBlueLabel.hidden = true;
        _messageView.hidden = true;
    
        CGFloat fixedHeight = SCREEN_WIDTH*9/16 + 5 + 150 + 5 + 60 + 60 + 85 + 40 + 5 + 49;
        if (_descriptionViewHeightConstraint.constant > 240) {
            _contentSizeHeightConstraint.constant = _descriptionViewHeightConstraint.constant + fixedHeight;
        }
    }
}

- (void)detailMessageTapAction:(UITapGestureRecognizer *)sender {
    if (_messageBlueLabel.hidden) {
        _messageBlueLabel.hidden = false;
        _messageView.hidden = false;
        _activityDetailBlueLabel.hidden = true;
        _descriptionLabel.hidden = true;
        
        CGFloat fixedHeight = SCREEN_WIDTH*9/16 + 5 + 150 + 5 + 60 + 60 + 85 + 40 + 5 + 49;
        _contentSizeHeightConstraint.constant = 240 + fixedHeight;
    }
}

#pragma mark 关注操作
- (IBAction)focusButtonAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"+ 关注"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPSportBusinessUnit shareInstance] followWithUserId:userId sportId:_eventModel.sportId successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                [sender setBackgroundColor:[UIColor grayColor]];
                sender.userInteractionEnabled = false;
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
    }
}

#pragma mark 分享,留言,报名等操作
- (void)shareButtonAction:(UIButton *)sender {
    
//    if (!_imageViewBG) {
//        _imageViewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _imageViewBG.image = [UIImage imageNamed:@"Sports_create_windowBG"];
//        _imageViewBG.alpha = 0;
//        _imageViewBG.userInteractionEnabled = true;
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShareView:)];
//        [_imageViewBG addGestureRecognizer:tapGesture];
//    }
//    [self.view addSubview:_imageViewBG];
//    
//    if (!_shareView) {
//        _shareView = [[[NSBundle mainBundle] loadNibNamed:@"SPSportsEventShareView" owner:nil options:nil] lastObject];
//        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 145);
//        [_shareView setUpWithTitle:_eventModel.title time:_eventModel.start_time location:_locationDetailLabel.text image:_headImageView.image eventId:_eventId];
//    }
//    [self.view addSubview:_shareView];
//    
//    _shareView.sportsEventViewController = self;
//    
//    CGRect frame = _shareView.frame;
//    frame.origin.y = frame.origin.y - 145;
//    [UIView animateWithDuration:0.3 animations:^{
//        _imageViewBG.alpha = 0.5;
//        _shareView.frame = frame;
//    }];
    
    if (!_windowImageViewBG) {
        _windowImageViewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _windowImageViewBG.image = [UIImage imageNamed:@"Sports_create_windowBG"];
        _windowImageViewBG.alpha = 0;
    }
    [self.view addSubview:_windowImageViewBG];
    
    if (!_shareView) {
        _shareView = [[[NSBundle mainBundle] loadNibNamed:@"SPSportsPageShareView" owner:nil options:nil] lastObject];
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        _shareView.delegate = self;
    }
    [self.view addSubview:_shareView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _windowImageViewBG.alpha = 1;
        _shareView.shareView.alpha = 1;
        _shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    
}

#pragma mark - ShareNotification
- (void)notificationShareAction:(NSNotification *)notification {
//    CGRect frame = _shareView.frame;
//    frame.origin.y = SCREEN_HEIGHT;
//    [UIView animateWithDuration:0.5 animations:^{
//        _imageViewBG.alpha = 0;
//        _shareView.frame = frame;
//    } completion:^(BOOL finished) {
//        [_imageViewBG removeFromSuperview];
//        [_shareView removeFromSuperview];
//    }];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *type = notification.userInfo[@"type"];
    NSString *targetId = notification.userInfo[@"targetId"];
    NSString *title = notification.userInfo[@"title"];
    //NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    SPIMSendMessageModel *model = [[SPIMSendMessageModel alloc] init];
    model.eventId = _eventId;
    model.imageUrl = _eventModel._portrait.firstObject;
    model.shareTitle = _eventModel.title;
    NSString *timeStr = [_eventModel.start_time substringWithRange:NSMakeRange(0, 16)];
    NSString *location = nil;
    if (_eventModel.location.length != 0) {
        location = _eventModel.location;
    } else {
        location = @"地址待定";
    }
    model.content = [NSString stringWithFormat:@"%@\n%@",timeStr,location];
    //    NSString *jsonStr = [SPGlobalConfig toJsonString:model.toDictionary];
    //    NSLog(@"jsonStr:%@",jsonStr);
    
    RCConversationType conversationType;
    RCConversationModel *conversationModel = [[RCConversationModel alloc] init];
    conversationModel.conversationTitle = title;
    conversationModel.targetId = targetId;
    
    if ([type isEqualToString:@"person"]) {
        conversationType = ConversationType_PRIVATE;
    } else {
        conversationType = ConversationType_GROUP;
    }
    conversationModel.conversationType = conversationType;
    
    RCConversationViewController *conversationViewConntroller = nil;
    if (conversationType == ConversationType_PRIVATE) {
        SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:conversationType
                                                                                                 targetId:targetId];
        chatViewController.hidesBottomBarWhenPushed = true;
        chatViewController.model = conversationModel;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        chatViewController.indexPath = indexPath;
        conversationViewConntroller = chatViewController;
    } else if (conversationType == ConversationType_GROUP) {
        SPChatGroupViewController *groupChatViewController = [[SPChatGroupViewController alloc] initWithConversationType:ConversationType_GROUP targetId:targetId];
        groupChatViewController.hidesBottomBarWhenPushed = true;
        groupChatViewController.model = conversationModel;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        groupChatViewController.indexPath = indexPath;
        conversationViewConntroller = groupChatViewController;
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ((UITabBarController *)delegate.window.rootViewController).selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:false];
    //[((UITabBarController *)delegate.window.rootViewController).selectedViewController pushViewController:chatViewController animated:true];
    [((UITabBarController *)delegate.window.rootViewController).selectedViewController pushViewController:conversationViewConntroller animated:true];
    
    SPIMMessageContent *messageContent = [SPIMMessageContent messageWithContent:model.content];
    messageContent.eventId = model.eventId;
    messageContent.imageUrl = model.imageUrl;
    messageContent.shareTitle = model.shareTitle;
    messageContent.content = model.content;
    //[chatViewController sendMessage:messageContent pushContent:nil];
    [conversationViewConntroller sendMessage:messageContent pushContent:@"一条分享消息"];

}

- (void)messageButtonAction:(UIButton *)sender {
    [_messageTextView becomeFirstResponder];
}

- (void)sendMessageButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    if (_messageTextView.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"留言内容不能为空" ToView:self.view];
        sender.userInteractionEnabled = true;
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] postMessageWithUserId:userId eventId:_eventId replyId:nil content:_messageTextView.text successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"留言成功" ToView:self.view];
                sender.userInteractionEnabled = true;
                [_messageTextView resignFirstResponder];
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
            [SPGlobalConfig showTextOfHUD:@"网络连接失败" ToView:self.view];
            sender.userInteractionEnabled = true;
        });
    }];
}

- (void)tapScrollViewAction:(UITapGestureRecognizer *)sender {
    [_messageTextView resignFirstResponder];
    _messageTextView.text = @"";
}

- (void)signUpButtonAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"报名"]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPIMBusinessUnit shareInstance] getUserInfoWithUserId:userId success:^(JSONModel *model) {
            if (model) {
                if ([(SPUserInfoModel *)model mobile].length != 0) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    SPSPortsOrderViewController *orderViewcontroller = [[SPSPortsOrderViewController alloc] init];
                    [orderViewcontroller setUpWithModel:_eventModel];
                    [self.navigationController pushViewController:orderViewcontroller animated:true];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    SPCreateCompleteViewController *completeViewController = [[SPCreateCompleteViewController alloc] init];
                    [self.navigationController pushViewController:completeViewController animated:true];
                }
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络连接失败" ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络连接失败" ToView:self.view];
            });
        }];
        
    } else if ([sender.currentTitle isEqualToString:@"去评价"]) {
        
        SPSportsAppraiseViewController *appraiseViewController = [[SPSportsAppraiseViewController alloc] init];
        NSString *initiateStr = nil;
        if (_eventModel.user_id.nick.length == 0) {
            initiateStr = _eventModel.user_id.uname;
        } else {
            initiateStr = _eventModel.user_id.nick;
        }
        [appraiseViewController setUpWithImage:_headImageView.image title:_eventModel.title location:_eventModel.location time:_eventModel.start_time initiate:initiateStr eventId:_eventId imageUrl:nil];
        [self.navigationController pushViewController:appraiseViewController animated:true];
        
    } else if ([sender.currentTitle isEqualToString:@"锁定"]) {
        
        sender.userInteractionEnabled = false;
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPSportBusinessUnit shareInstance] lockWithUserId:userId eventId:_eventId successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"锁定成功" ToView:self.view];
                    [_signUpButton setTitle:@"解锁" forState:UIControlStateNormal];
                    _signUpButton.userInteractionEnabled = true;
                });
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    _signUpButton.userInteractionEnabled = true;
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"lock AFN ERROR:%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                _signUpButton.userInteractionEnabled = true;
            });
        }];
        
    } else if ([sender.currentTitle isEqualToString:@"解锁"]) {
        
        sender.userInteractionEnabled = false;
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        
        [[SPSportBusinessUnit shareInstance] unlockWithUserId:userId eventId:_eventId successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"解锁成功" ToView:self.view];
                    [_signUpButton setTitle:@"锁定" forState:UIControlStateNormal];
                    _signUpButton.userInteractionEnabled = true;
                });
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    _signUpButton.userInteractionEnabled = true;
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"unlock AFN ERROR:%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                _signUpButton.userInteractionEnabled = true;
            });
        }];
    } else if ([sender.currentTitle isEqualToString:@"结算"]) {
        
        SPSportsSettleViewController *settleViewController = [[SPSportsSettleViewController alloc] init];
        NSString *priceStr = [NSString stringWithFormat:@"%ld",_eventModel.enrollUsers.count*[_eventModel.price integerValue]];
        settleViewController.eventId = _eventId;
        settleViewController.priceStr = priceStr;
        [settleViewController setUpWithModel:_eventModel];
        [self.navigationController pushViewController:settleViewController animated:true];
        
    } else {
        NSLog(@"%s,%@",__func__,sender.currentTitle);
    }
}

#pragma mark 地址,电话,查看参与人
- (void)tapLocationAction:(UITapGestureRecognizer *)sender {
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([_eventModel.latitude doubleValue], [_eventModel.longitude doubleValue]);
    NSArray *array = [self getInstalledMapAppWithEndLocation:locationCoordinate];
    
    if (array.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还没有安装任何地图" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    } else {
        UIAlertController *alertSheetController = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertSheetController addAction:actionCancel];
        for (int i=0; i<array.count; i++) {
            NSString *title = [array[i] valueForKey:@"title"];
            if ([title isEqualToString:@"苹果地图"]) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self navAppleMap];
                }];
                [alertSheetController addAction:action];
            } else {
                UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *urlStr = [array[i] valueForKey:@"url"];
                    
                    NSString *version = [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0];
                    if ([version isEqualToString:@"10"]) {
                        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
                        #endif
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
                [alertSheetController addAction:action];
            }
        }
        [self presentViewController:alertSheetController animated:true completion:nil];
    }
}

- (void)tapTelophoneAction:(UITapGestureRecognizer *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    if (_eventModel.user_id.mobile.length != 0) {
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",_eventModel.user_id.mobile];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [self.view addSubview:callWebview];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"对方没有填写电话" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)tapMoreAction:(UITapGestureRecognizer *)sender {
    SPSportsSignedUpViewController *signedUpViewController = [[SPSportsSignedUpViewController alloc] init];
    SPUserInfoModel *model = _eventModel.user_id;
    model.relation = _eventModel.relation;
    signedUpViewController.initiateInfoModel = model;
    signedUpViewController.dataArray = _eventModel.enrollUsers;
    [self.navigationController pushViewController:signedUpViewController animated:true];
}

#pragma mark - MapAction
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation {
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *url = @"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02";
        NSString *urlStr = [NSString stringWithFormat:url,endLocation.latitude,endLocation.longitude];
        NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *url = @"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2";
        NSString *urlStr = [NSString stringWithFormat:url,@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude];
        NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *url = @"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving";
        NSString *urlStr = [NSString stringWithFormat:url,@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude];
        NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *url = @"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0";
        NSString *urlStr = [NSString stringWithFormat:url,endLocation.latitude,endLocation.longitude];
        NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    return maps;
}

- (void)navAppleMap {
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([_eventModel.latitude doubleValue], [_eventModel.longitude doubleValue]);
    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:locationCoordinate];
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

#pragma mark - MessageAction
#pragma mark keyboard
- (void)keyboardAppearAction:(NSNotification *)notification {
    if ([_messageTextView isFirstResponder]) {
        NSDictionary *userInfo = [notification userInfo];
        _keyboardHeight = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
        [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] getValue:&_animationDuration];
        _bottomConstraint.constant = _keyboardHeight;
        [UIView animateWithDuration:_animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardDisappearAction:(NSNotification *)notification {
    if ([_messageTextView isFirstResponder]) {
        _bottomConstraint.constant = -_messageView.frame.size.height;
        [UIView animateWithDuration:_animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - SPSportsPageShareViewProtocol
- (void)cancelShareView {
    [UIView animateWithDuration:0.5 animations:^{
        _windowImageViewBG.alpha = 0;
        _shareView.shareView.alpha = 0;
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        _windowImageViewBG.alpha = 1;
        [_windowImageViewBG removeFromSuperview];
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_shareView removeFromSuperview];
    }];
}

- (void)finishedShareToSportsPage {
    SPSportsShareViewController *shareViewController = [[SPSportsShareViewController alloc] init];
    shareViewController.type = @"eventShare";
    [self.navigationController pushViewController:shareViewController animated:true];
}

- (void)finishedShareToWeChatFriends {
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [NSString stringWithFormat:[SPPathConfig getShareH5Url],@"1",_eventId];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _eventModel.title;
    message.description = [NSString stringWithFormat:@"%@\n%@",_eventModel.start_time,_locationDetailLabel.text];
    UIImage *thumbImage = [self imageWithImage:_headImageView.image scaledToSize:CGSizeMake(100, 100)];
    [message setThumbImage:thumbImage];
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = false;
    req.message = message;
    req.scene = WXSceneSession;
    if (![WXApi sendReq:req]) {
        [SPGlobalConfig showTextOfHUD:@"分享失败" ToView:self.view];
    }
}

- (void)finishedShareToWeChatTimeLine {
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [NSString stringWithFormat:[SPPathConfig getShareH5Url],@"1",_eventId];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _eventModel.title;
    message.description = [NSString stringWithFormat:@"%@\n%@",_eventModel.start_time,_locationDetailLabel.text];
    UIImage *thumbImage = [self imageWithImage:_headImageView.image scaledToSize:CGSizeMake(100, 100)];
    [message setThumbImage:thumbImage];
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = false;
    req.message = message;
    req.scene = WXSceneTimeline;
    if (![WXApi sendReq:req]) {
        [SPGlobalConfig showTextOfHUD:@"分享失败" ToView:self.view];
    }
}

- (void)finishedShareToQQ {
    [[TencentOAuth alloc] initWithAppId:KEY_TENCENT andDelegate:self];
    
    NSString *url = [NSString stringWithFormat:[SPPathConfig getShareH5Url],@"1",_eventId];
    NSString *description = [NSString stringWithFormat:@"%@\n%@",_eventModel.start_time,_locationDetailLabel.text];
    NSData *imageData = [self imageDataWithImage:_headImageView.image scaledToSize:CGSizeMake(100, 100)];
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:_eventModel.title
                                                     description:description
                                                previewImageData:imageData];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    if (sent == EQQAPISENDSUCESS) {
        NSLog(@"分享成功");
    } else if (sent == EQQAPIVERSIONNEEDUPDATE) {
        NSLog(@"当前QQ版本太低，需要更新至新版本才可以支持");
    } else {
        NSLog(@"分享失败");
    }
}

- (void)finishedShareToQQZone {
    
    [[TencentOAuth alloc] initWithAppId:KEY_TENCENT andDelegate:self];
    
    NSString *url = @"https://www.baidu.com";
    NSString *description = [NSString stringWithFormat:@"%@\n%@",_eventModel.start_time,_locationDetailLabel.text];
    NSData *imageData = [self imageDataWithImage:_headImageView.image scaledToSize:CGSizeMake(100, 100)];
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:_eventModel.title
                                                     description:description
                                                previewImageData:imageData];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    if (sent == EQQAPISENDSUCESS) {
        NSLog(@"分享成功");
    } else if (sent == EQQAPIVERSIONNEEDUPDATE) {
        NSLog(@"当前QQ版本太低，需要更新至新版本才可以支持");
    } else {
        NSLog(@"分享失败");
    }
}

- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(newImage, 0.3);
    return [UIImage imageWithData:data];
}

- (NSData *)imageDataWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(newImage, 0.3);
    return data;
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

@end
