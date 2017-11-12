//
//  SPIMMessageCustomShareClubCell.m
//  SportsPage
//
//  Created by Qin on 2017/3/31.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPIMMessageCustomShareClubCell.h"

#import "SPIMMessageContentShareClub.h"

#import "UIImageView+WebCache.h"

#define Test_Message_Font_Size 16

@interface SPIMMessageCustomShareClubCell () {
    UIView *_lineView;
}

@end

@implementation SPIMMessageCustomShareClubCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    
    CGFloat __messagecontentview_height = 70;
    
    __messagecontentview_height += extraHeight;
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] init];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.clubImageView = [[UIImageView alloc] init];
    self.clubImageView.backgroundColor = [UIColor redColor];
    self.clubImageView.layer.cornerRadius = 5;
    self.clubImageView.layer.masksToBounds = true;
    self.clubImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bubbleBackgroundView addSubview:self.clubImageView];
    
    self.typeLabel = [[RCAttributedLabel alloc] init];
    [self.typeLabel setFont:[UIFont systemFontOfSize:Test_Message_Font_Size-4]];
    [self.typeLabel setTextAlignment:NSTextAlignmentLeft];
    [self.typeLabel setTextColor:[UIColor blackColor]];
    [self.bubbleBackgroundView addSubview:self.typeLabel];
    
    _lineView = [[UIView alloc] init];
    [self.bubbleBackgroundView addSubview:_lineView];
    
    self.textLabel = [[RCAttributedLabel alloc] init];
    self.textLabel.numberOfLines = 0;
    [self.textLabel setFont:[UIFont systemFontOfSize:Test_Message_Font_Size-5]];
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    [self.textLabel setTextColor:[UIColor grayColor]];
    [self.bubbleBackgroundView addSubview:self.textLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextMessage:)];
    [self.bubbleBackgroundView addGestureRecognizer:tapGesture];
    
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:self.bubbleBackgroundView];
    }
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}

- (void)setAutoLayout {
    
    SPIMMessageContentShareClub *shareClubMessage = (SPIMMessageContentShareClub *)self.model.content;
    
    if (shareClubMessage) {
        self.textLabel.text = shareClubMessage.content;
        [self.clubImageView sd_setImageWithURL:[NSURL URLWithString:shareClubMessage.imageUrl]
                               placeholderImage:[UIImage imageNamed:@"Sports_main_mask"]];
        self.typeLabel.text = shareClubMessage.shareTitle;
    }
    
    //拉伸图片
    CGFloat portraitWidth = [RCIM sharedRCIM].globalMessagePortraitSize.width+20;
    CGFloat contentViewWidth = SCREEN_WIDTH-2*portraitWidth;
    
    if (MessageDirection_RECEIVE == self.messageDirection) {
        
        if ([self isDisplayNickname]) {
            self.messageContentView.frame = CGRectMake(portraitWidth, 10, contentViewWidth, 70);
        } else {
            self.messageContentView.frame = CGRectMake(portraitWidth, 0, contentViewWidth, 70);
        }
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 15, contentViewWidth, 70);
        
        self.clubImageView.frame = CGRectMake(13, 5, 60, 60);
        self.typeLabel.frame = CGRectMake(13+60+5, 5, contentViewWidth-13-60-8, 20);
        _lineView.frame = CGRectMake(13+60+5, 24, contentViewWidth-13-60-8, 1);
        self.textLabel.frame = CGRectMake(13+60+5, 25, contentViewWidth-13-60-8, 40);
        _lineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.8,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.2)];

    } else {

        self.messageContentView.frame = CGRectMake(portraitWidth, 0, contentViewWidth, 70);
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, contentViewWidth, 70);
        
        self.clubImageView.frame = CGRectMake(5, 5, 60, 60);
        self.typeLabel.frame = CGRectMake(5+60+5, 5, contentViewWidth-13-60-8, 20);
        _lineView.frame = CGRectMake(5+60+5, 24, contentViewWidth-13-60-8, 1);
        _lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.textLabel.frame = CGRectMake(5+60+5, 25, contentViewWidth-13-60-8, 40);
        
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_normal"
                                         ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image = [image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8,
                                                                                        image.size.width * 0.2,
                                                                                        image.size.height * 0.2,
                                                                                        image.size.width * 0.8)];
        
    }

}

@end
