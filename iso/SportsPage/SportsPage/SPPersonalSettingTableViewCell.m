//
//  SPPersonalSettingTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalSettingTableViewCell.h"

@interface SPPersonalSettingTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SPPersonalSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithContent:(NSString *)content {
    _contentLabel.text = content;
}

@end
