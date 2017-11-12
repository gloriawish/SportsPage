//
//  SPSportsCreateLocationTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsCreateLocationTableViewCell.h"

@interface SPSportsCreateLocationTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeAddressLabel;

@end

@implementation SPSportsCreateLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithPlaceName:(NSString *)name address:(NSString *)address {
    _placeNameLabel.text = name;
    _placeAddressLabel.text = address;
}

@end
