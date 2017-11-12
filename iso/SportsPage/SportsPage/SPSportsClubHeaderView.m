//
//  SPSportsClubHeaderView.m
//  SportsPage
//
//  Created by Qin on 2017/2/8.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsClubHeaderView.h"

//#import "SPSportsClubRelationCollectionViewCell.h"

#import "SPSportsClubRelationView.h"
#import "RPRingedPages.h"

#import "SPClubDetailResponseModel.h"

#import "UIImageView+WebCache.h"

@interface SPSportsClubHeaderView () <RPRingedPagesDelegate, RPRingedPagesDataSource,SPSportsClubRelationViewProtocol> {
    SPClubDetailResponseModel *_clubDetailResponseModel;
}

//基础信息
@property (weak, nonatomic) IBOutlet UIImageView    *clubHeaderImageView;

@property (weak, nonatomic) IBOutlet UIImageView    *clubImageView;
@property (weak, nonatomic) IBOutlet UILabel        *clubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel        *clubLevelLabel;

//操作按钮 加入&进去群聊
@property (weak, nonatomic) IBOutlet UIButton       *clubJoinButton;

//活跃度
@property (weak, nonatomic) IBOutlet UIView         *clubDynamicBackView;
@property (weak, nonatomic) IBOutlet UIView         *clubDynamicFrontView;
//活跃度标签
@property (weak, nonatomic) IBOutlet UILabel *clubDynamicLabel;
//活跃度具体值
@property (weak, nonatomic) IBOutlet UILabel        *clubDynamicValueLabel;
//活跃度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clubDynaicFrontViewRightConstraint;

//分享按钮
@property (weak, nonatomic) IBOutlet UIButton       *clubDynamicShareButton;

//公告
@property (weak, nonatomic) IBOutlet UILabel        *clubMessageLabel;

//成员
@property (weak, nonatomic) IBOutlet UIView         *clubMembersView;
@property (weak, nonatomic) IBOutlet UIImageView    *clubMembersImageView1;
@property (weak, nonatomic) IBOutlet UIImageView    *clubMembersImageView2;
@property (weak, nonatomic) IBOutlet UIImageView    *clubMembersImageView3;
@property (weak, nonatomic) IBOutlet UIImageView    *clubMembersImageView4;
@property (weak, nonatomic) IBOutlet UIImageView    *clubMembersImageView5;

//关联运动页
@property (weak, nonatomic) IBOutlet UIView *clubRelationTitleView;

@property (weak, nonatomic) IBOutlet UILabel *clubRelationNoSportsPageForAdminsLabel;
@property (weak, nonatomic) IBOutlet UILabel *clubRelationNoSportsPageForNorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clubRelationMoreImageView;
@property (weak, nonatomic) IBOutlet UIView *clubRelationView;

@property (nonatomic, strong) RPRingedPages *pages;
@property (nonatomic, strong) NSMutableArray <SPSportsPageModel *> *relationDataSourceArray;

//约战记录
@property (weak, nonatomic) IBOutlet UIView *clubQueueShadowView;
@property (weak, nonatomic) IBOutlet UIImageView    *clubQueueImageViewA;
@property (weak, nonatomic) IBOutlet UIImageView    *clubQueueImageViewB;
@property (weak, nonatomic) IBOutlet UILabel        *clubQueueNameLabelA;
@property (weak, nonatomic) IBOutlet UILabel        *clubQueueNameLabelB;
@property (weak, nonatomic) IBOutlet UILabel        *clubQueueTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton       *clubQueueActionButton;

//动态标签
@property (weak, nonatomic) IBOutlet UIView *clubTrendStartView;

//分割线
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UIView *lineView4;
@property (weak, nonatomic) IBOutlet UIView *lineView5;
@property (weak, nonatomic) IBOutlet UIView *lineView6;
@property (weak, nonatomic) IBOutlet UIView *lineView7;

@end

@implementation SPSportsClubHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - SetUp
- (void)setUp {
    [self setUpLine];
    [self setUpClubHeaderImageView];
    [self setUpClubView];
    [self setUpClubMembersListView];
    [self setUpRelationCollectionView];
    [self setUpRecordView];
    [self setUpTrendView];
}

- (void)setUpLine {
    [self setLineColor:_lineView1];
    [self setLineColor:_lineView2];
    [self setLineColor:_lineView3];
    [self setLineColor:_lineView4];
    [self setLineColor:_lineView5];
    [self setLineColor:_lineView6];
    [self setLineColor:_lineView7];
}

- (void)setLineColor:(UIView *)sender {
    sender.backgroundColor = [SPGlobalConfig anyColorWithRed:234 green:234 blue:234 alpha:1];
}

- (void)setUpClubHeaderImageView {
    
}

- (void)setUpClubView {
    
    _clubImageView.layer.cornerRadius = 5;
    _clubImageView.layer.masksToBounds = true;
    _clubImageView.layer.borderWidth = 1;
    _clubImageView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    
    _clubJoinButton.layer.cornerRadius = 5;
    _clubJoinButton.layer.masksToBounds = true;
    [_clubJoinButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_clubJoinButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
 
    _clubDynamicLabel.text = @"活跃度";
    
    _clubDynamicBackView.layer.cornerRadius = 6;
    _clubDynamicBackView.layer.masksToBounds = true;
    _clubDynamicBackView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _clubDynamicFrontView.layer.cornerRadius = 6;
    _clubDynamicFrontView.layer.masksToBounds = true;
    _clubDynamicFrontView.backgroundColor = [SPGlobalConfig themeColor];
    
    _clubDynamicValueLabel.textColor = [SPGlobalConfig themeColor];
    
    [_clubDynamicShareButton setTitle:@"分享俱乐部" forState:UIControlStateNormal];
    [_clubDynamicShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_clubDynamicShareButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

- (void)setUpClubMembersListView {
    UITapGestureRecognizer *tapMembersListView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clubTapMembersViewAction:)];
    [_clubMembersView addGestureRecognizer:tapMembersListView];
    _clubMembersView.userInteractionEnabled = true;
}

- (void)setUpRelationCollectionView {
    
    UITapGestureRecognizer *tapRelationView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clubTapRelationSportsPageAction:)];
    [_clubRelationTitleView addGestureRecognizer:tapRelationView];
    _clubRelationTitleView.userInteractionEnabled = true;
    
    [_clubRelationView layoutIfNeeded];
    CGRect pagesFrame = CGRectMake(0, 0, SCREEN_WIDTH, (89.0/15.0) * (2.0/25.0) * SCREEN_WIDTH);
    _pages = [[RPRingedPages alloc] initWithFrame:pagesFrame];
    CGFloat carouselHeight = pagesFrame.size.height - 15;
    _pages.carousel.mainPageSize = CGSizeMake(carouselHeight*48.0/37.0, carouselHeight);
    _pages.carousel.pageScale = 0.8;
    _pages.dataSource = self;
    _pages.delegate = self;
    
    _pages.showPageControl = false;
    _pages.carousel.autoScrollInterval = 0;
    
    [_clubRelationView addSubview:_pages];
}

- (void)setUpRecordView {
    
    _clubQueueShadowView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    _clubQueueShadowView.layer.shadowOpacity = 0.5;
    _clubQueueShadowView.layer.shadowOffset = CGSizeMake(1, 1);
    
    _clubQueueImageViewA.layer.cornerRadius = 5;
    _clubQueueImageViewA.layer.masksToBounds = true;
    _clubQueueImageViewB.layer.cornerRadius = 5;
    _clubQueueImageViewB.layer.masksToBounds = true;
    
    _clubQueueActionButton.layer.cornerRadius = 5;
    _clubQueueActionButton.layer.masksToBounds = true;
    _clubQueueActionButton.backgroundColor = [SPGlobalConfig themeColor];
    [_clubQueueActionButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

- (void)setUpTrendView {
    _clubTrendStartView.layer.cornerRadius = 5;
    _clubTrendStartView.layer.borderWidth = 2;
    _clubTrendStartView.layer.borderColor = [SPGlobalConfig anyColorWithRed:201 green:201 blue:201 alpha:1].CGColor;
}

- (void)setUpClubDetailResponseModel:(SPClubDetailResponseModel *)model {
    
    _clubDetailResponseModel = model;
    
    [_clubHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:nil];
    [_clubImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    
    //俱乐部名称
    if (model.name) {
        _clubTitleLabel.text = model.name;
    } else {
        _clubTitleLabel.text = @"";
    }
    
    //俱乐部等级
    if (model.level) {
        _clubLevelLabel.text = [NSString stringWithFormat:@"LV.%@",model.level];
    } else {
        _clubLevelLabel.text = @"LV.0";
    }
    
    //俱乐部操作按钮
    if ([model.op_permission isEqualToString:@"0"]) {
        [_clubJoinButton setTitle:@"加入俱乐部" forState:UIControlStateNormal];
    } else {
        [_clubJoinButton setTitle:@"进入群聊" forState:UIControlStateNormal];
    }
    
    //俱乐部活跃度
    _clubDynamicValueLabel.text = [NSString stringWithFormat:@"%@/%@",model.vitality,model.max_vitality];
    if ([model.vitality isEqualToString:@"0"]) {
        _clubDynaicFrontViewRightConstraint.constant = SCREEN_WIDTH - 90 + 20;
        _clubDynamicFrontView.hidden = true;
    } else if ([model.vitality integerValue] >= [model.max_vitality integerValue]) {
        _clubDynaicFrontViewRightConstraint.constant = 20;
    } else {
        CGFloat width = SCREEN_WIDTH - 90;
        _clubDynaicFrontViewRightConstraint.constant =
        (width - [model.vitality integerValue] * width / [model.max_vitality integerValue]) + 20;
    }
    
    //公告
    if (model.ann.content) {
        _clubMessageLabel.text = [NSString stringWithFormat:@"公告\n%@",model.ann.content];
    } else {
        _clubMessageLabel.text = @"暂无公告";
    }
    
    //成员
    [self setUpClubMembersImageViewHidden];
    NSArray <UIImageView *> *imageViewArray = @[_clubMembersImageView1,
                                                _clubMembersImageView2,
                                                _clubMembersImageView3,
                                                _clubMembersImageView4,
                                                _clubMembersImageView5];
    
    for (int i=0; i<model.top_member.count; i++) {
        [self setUpClubMembersImageView:imageViewArray[i]
                               imageUrl:[model.top_member[i] portrait]
                                 radius:(SCREEN_WIDTH-100)/10];
    }
    
    //关联运动页
    
    if (model.sports.count == 0) {
        if ([model.op_permission isEqualToString:@"0"]
            || [model.op_permission isEqualToString:@"1"]) {
            _clubRelationTitleView.userInteractionEnabled = false;
            _clubRelationNoSportsPageForAdminsLabel.hidden = true;
            _clubRelationNoSportsPageForNorLabel.text = @"未关联运动页";
            _clubRelationMoreImageView.hidden = true;
        } else {
            _clubRelationTitleView.userInteractionEnabled = true;
            _clubRelationNoSportsPageForNorLabel.hidden = true;
            _clubRelationNoSportsPageForAdminsLabel.text = @"未关联运动页";
        }
    } else {
        _clubRelationTitleView.userInteractionEnabled = true;
        _clubRelationNoSportsPageForNorLabel.hidden = true;
        _clubRelationNoSportsPageForAdminsLabel.hidden = true;
    }
    
//    if ([model.op_permission isEqualToString:@"0"]) {
//        if (model.sports.count == 0) {
//            _clubRelationTitleView.userInteractionEnabled = false;
//            _clubRelationMoreImageView.hidden = true;
//            _clubRelationNoSportsPageForAdminsLabel.hidden = true;
//            _clubRelationNoSportsPageForNorLabel.text = @"未关联运动页";
//        }
//    } else if ([model.op_permission isEqualToString:@"1"]
//               || [model.op_permission isEqualToString:@"2"]
//               || [model.op_permission isEqualToString:@"3"]) {
//        if (model.sports.count == 0) {
//            _clubRelationTitleView.userInteractionEnabled = true;
//            _clubRelationNoSportsPageForNorLabel.hidden = true;
//            _clubRelationNoSportsPageForAdminsLabel.text = @"未关联运动页";
//        }
//    }
    
    _relationDataSourceArray = model.sports;
    [_pages reloadData];
    
    
    //约战记录
    //Team_A
    [_clubQueueImageViewA sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    if (model.name) {
        _clubQueueNameLabelA.text = model.name;
    } else {
        _clubQueueNameLabelA.text = @"";
    }
    //Team_B
    /*
    [_clubQueueImageViewB sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    if (model.name) {
        _clubQueueNameLabelB.text = model.name;
    } else {
        _clubQueueNameLabelB.text = @"";
    }
    */
    
    /*
     if (model.time) {
     _clubQueueTimeLabel.text = model.time;
     } else {
     _clubQueueTimeLabel.text = @"";
     }
     */
    
    _clubQueueNameLabelB.text = @"虚位以待";
    
    [_clubQueueActionButton setBackgroundColor:[SPGlobalConfig anyColorWithRed:201 green:201 blue:201 alpha:1]];
    _clubQueueActionButton.userInteractionEnabled = false;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _clubQueueTimeLabel.text = [formatter stringFromDate:[NSDate date]];
}

- (void)setUpClubMembersImageViewHidden {
    _clubMembersImageView1.hidden = true;
    _clubMembersImageView2.hidden = true;
    _clubMembersImageView3.hidden = true;
    _clubMembersImageView4.hidden = true;
    _clubMembersImageView5.hidden = true;
}

- (void)setUpClubMembersImageView:(UIImageView *)sender imageUrl:(NSString *)imageUrl radius:(CGFloat)radius {
    sender.hidden = false;
    [sender sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    sender.layer.cornerRadius = radius;
    sender.layer.masksToBounds = true;
}

#pragma mark - Action
- (IBAction)clubHandleAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"加入俱乐部"]) {
        if ([_delegate respondsToSelector:@selector(clubHeaderJoinAction)]) {
            [_delegate clubHeaderJoinAction];
        }
    } else if ([sender.currentTitle isEqualToString:@"进入群聊"]) {
        if ([_delegate respondsToSelector:@selector(clubHeaderChattingActionWithTargetId:)]) {
            [_delegate clubHeaderChattingActionWithTargetId:_clubDetailResponseModel.group_id];
        }
    }
}

- (IBAction)clubShareAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(clubHeaderShareAction)]) {
        [_delegate clubHeaderShareAction];
    }
}

- (void)clubTapMembersViewAction:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(clubHeaderMembersListAction)]) {
        [_delegate clubHeaderMembersListAction];
    }
}

- (void)clubTapRelationSportsPageAction:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(clubHeaderReviewRelationSportsPageAction)]) {
        [_delegate clubHeaderReviewRelationSportsPageAction];
    }
}

#pragma mark - RPRingedPagesDataSource
- (NSInteger)numberOfItemsInRingedPages:(RPRingedPages *)pages {
    return _relationDataSourceArray.count;
}

- (UIView *)ringedPages:(RPRingedPages *)pages viewForItemAtIndex:(NSInteger)index {
    SPSportsClubRelationView *relationView = (SPSportsClubRelationView *)[pages dequeueReusablePage];
    if (![relationView isKindOfClass:[SPSportsClubRelationView class]]) {
        relationView = [[[NSBundle mainBundle] loadNibNamed:@"SPSportsClubRelationView" owner:nil options:nil] lastObject];
    }
    relationView.delegate = self;
    [relationView setUpSportsPageModel:_relationDataSourceArray[index]];
    return relationView;
}

#pragma mark - SPSportsClubRelationViewProtocol
- (void)clickSportsPageAction:(NSString *)sportsPageId status:(NSString *)status eventId:(NSString *)eventId {
    if ([_delegate respondsToSelector:@selector(clubHeaderClickRelationSportsPageAction:status:eventId:)]) {
        [_delegate clubHeaderClickRelationSportsPageAction:sportsPageId status:status eventId:eventId];
    }
}

#pragma mark - Interface
- (UIImage *)getClubCoverImageView {
    return _clubHeaderImageView.image;
}

- (UIImage *)getClubTeamImageView {
    return _clubImageView.image;
}

- (void)setUpClubCoverImageView:(UIImage *)image {
    _clubHeaderImageView.image = image;
}

- (void)setUpClubTeamImageView:(UIImage *)image {
    _clubImageView.image = image;
}

- (void)setUpClubName:(NSString *)clubName {
    _clubTitleLabel.text = clubName;
}

- (void)setUpClubPublicNotice:(NSString *)clubPublicNotice {
    NSString *publicNoticeString = [NSString stringWithFormat:@"公告\n%@",clubPublicNotice];
    _clubMessageLabel.text = publicNoticeString;
}

@end
