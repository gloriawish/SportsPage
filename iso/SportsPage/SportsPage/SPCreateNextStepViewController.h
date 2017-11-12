//
//  SPCreateNextStepViewController.h
//  SportsPage
//
//  Created by Qin on 2016/11/9.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@interface SPCreateNextStepViewController : SPBaseViewController

@property (nonatomic,assign) BOOL isFirstActive;
@property (nonatomic,assign) BOOL isSubWindowDisplay;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIButton *finishedButton;

@property (nonatomic,strong) UIImage *uploadImage;
@property (nonatomic,copy) NSString *sportId;
@property (nonatomic,copy) NSString *sportsName;
@property (nonatomic,copy) NSString *sportsLocation;
@property (nonatomic,copy) NSString *sportsEvent;
@property (nonatomic,copy) NSString *sportsSummary;

@property (nonatomic,readwrite,strong) NSMutableArray *dataStringArray;
@property (nonatomic,readwrite,strong) NSMutableArray *imageArray;

@property (nonatomic,readwrite,strong) UIImageView *windowImageView;

@end
