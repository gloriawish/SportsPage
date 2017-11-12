//
//  SPSportsAppraiseViewController.h
//  SportsPage
//
//  Created by Qin on 2016/12/8.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@interface SPSportsAppraiseViewController : SPBaseViewController

- (void)setUpWithImage:(UIImage *)image
                 title:(NSString *)title
              location:(NSString *)location
                  time:(NSString *)time
              initiate:(NSString *)initiate
               eventId:(NSString *)eventId
              imageUrl:(NSString *)imageUrl;

@end
