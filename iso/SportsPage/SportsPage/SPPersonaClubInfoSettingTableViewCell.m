//
//  SPPersonaClubInfoSettingTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2017/3/3.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonaClubInfoSettingTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface SPPersonaClubInfoSettingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *clubTeamImageView;

@property (weak, nonatomic) IBOutlet UILabel *clubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *clubContentLabel;

@end

@implementation SPPersonaClubInfoSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - SetUp
- (void)setUp {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setUpCellStyle:(SPPersonalClubInfoSettingTableViewCellSyle)style {
    if (style == SPPersonalClubInfoSettingTableViewCellSyleTeamImage) {
        _clubTitleLabel.text = @"队徽";
        _clubContentLabel.hidden = true;
    } else if (style == SPPersonalClubInfoSettingTableViewCellSyleClubName) {
        _clubTitleLabel.text = @"俱乐部名称";
        _clubTeamImageView.hidden = true;
    } else if (style == SPPersonalClubInfoSettingTableViewCellSyleClubEvent) {
        _clubTitleLabel.text = @"运动类型";
        _clubTeamImageView.hidden = true;
    }
}

- (void)setUpCellImage:(UIImage *)image {
    _clubTeamImageView.image = image;
}

//- (void)setUpCellImageName:(NSString *)imageName {
//    [_clubTeamImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
//}

- (void)setUpCellContent:(NSString *)content {
    _clubContentLabel.text = content;
}

@end
