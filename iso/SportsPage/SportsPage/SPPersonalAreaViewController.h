//
//  SPPersonalAreaViewController.h
//  SportsPage
//
//  Created by Qin on 2016/11/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

#import "SPPersonalInfoTableViewCell.h"

@interface SPPersonalAreaViewController : SPBaseViewController

@property (nonatomic,copy) NSString *contentStr;
@property (nonatomic,strong) SPPersonalInfoTableViewCell *personalInfoCell;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end
