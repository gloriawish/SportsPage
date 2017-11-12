//
//  SPGroupSettingTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2017/1/3.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPUserInfoModel;

@protocol SPGroupSettingProtocol <NSObject>

- (void)groupSettingHeadActionWithTargetId:(NSString *)targetId;

@end

@interface SPGroupSettingTableViewCell : UITableViewCell

@property (nonatomic,weak) id<SPGroupSettingProtocol> delegate;

- (void)setUpWithModelArray:(NSMutableArray <SPUserInfoModel *>*)modelArray;

@end
