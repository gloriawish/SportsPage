//
//  SPPersonalAccountViewController.h
//  SportsPage
//
//  Created by Qin on 2016/11/29.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@interface SPPersonalAccountViewController : SPBaseViewController

@property (nonatomic,copy) NSString *balanceStr;

- (void)networkRequest;

@end
