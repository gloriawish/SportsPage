//
//  SPSearchResultTableViewController.h
//  SportsPage
//
//  Created by Qin on 2016/10/26.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserInfoModel.h"

@interface SPSearchResultTableViewController : UITableViewController

@property (nonatomic,readwrite,strong) NSMutableArray <SPUserInfoModel *>*searchResultsArray;

@end
